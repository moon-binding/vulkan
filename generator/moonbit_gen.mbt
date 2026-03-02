// Generate MoonBit bindings from Vulkan registry model

use vk_model.{VkRegistry, VkEnum, VkEnumValue, VkStruct, VkHandle, VkCommand, VkParam}

// Type mapping: C types to MoonBit FFI types
fn map_c_type(c_type : String) -> String {
  match c_type {
    "void" => "Unit"
    "uint32_t" => "U32"
    "uint64_t" => "U64"
    "int32_t" => "I32"
    "int" => "I32"
    "unsigned int" => "U32"
    "float" => "Float32"
    "double" => "Float64"
    "VkBool32" => "U32"
    "VkResult" => "U32"
    "VkFlags" => "U32"
    "VkDeviceSize" => "U64"
    "VkDeviceAddress" => "U64"
    "VkSampleMask" => "U32"
    "char" => "Byte"
    t if String::starts_with(t, "Vk") => {
      // Vulkan type - use as handle or enum
      t
    }
    t if String::contains(t, "*") => {
      // Pointer - handle at parse time
      "Ptr"
    }
    _ => c_type
  }
}

// Generate MoonBit code for a registry
pub fn generate_bindings(registry : VkRegistry, selected_types : Array[String],
                         selected_commands : Array[String]) -> String {
  let mut code = ""
  code = code + "// Generated MoonBit Vulkan bindings\n"
  code = code + "// DO NOT EDIT - generated from vk.xml\n\n"

  // Generate handles
  code = code + "// Handles\n"
  code = code + "foreign vulkan\n"
  for handle in registry.handles {
    if should_include(handle.name, selected_types) {
      code = code + generate_handle(handle) + "\n"
    }
  }
  code = code + "\n"

  // Generate enums
  code = code + "// Enums\n"
  for enum in registry.enums {
    if should_include(enum.name, selected_types) {
      code = code + generate_enum(enum) + "\n"
    }
  }
  code = code + "\n"

  // Generate structs
  code = code + "// Structs\n"
  for struct in registry.structs {
    if should_include(struct.name, selected_types) {
      code = code + generate_struct(struct) + "\n"
    }
  }
  code = code + "\n"

  // Generate commands
  code = code + "// Commands\n"
  for command in registry.commands {
    if should_include(command.name, selected_commands) {
      code = code + generate_command(command) + "\n"
    }
  }

  code
}

fn should_include(name : String, selected : Array[String]) -> Bool {
  if selected.length() == 0 {
    true  // Empty selection means include all
  } else {
    for s in selected {
      if s == name {
        return true
      }
    }
    false
  }
}

fn generate_handle(handle : VkHandle) -> String {
  let moonbit_type = map_c_type(handle.name)
  // Handle types are opaque pointers in C, use U64 for MoonBit FFI
  "type " + handle.name + " = U64\n"
}

fn generate_enum(enum : VkEnum) -> String {
  let mut code = "type " + enum.name + " {\n"

  for value in enum.values {
    let moonbit_value_name = enum_to_moonbit_name(value.name)
    code = code + "  " + moonbit_value_name + "\n"
  }

  code = code + "}\n"

  // Generate const values
  code = code + "\n"
  for value in enum.values {
    let const_name = enum_to_const_name(value.name)
    let val = value.value
    code = code + "const " + const_name + " : " + enum.name + " = " + const_name + "\n"
  }

  code
}

fn enum_to_moonbit_name(vk_name : String) -> String {
  // Convert VK_ENUM_NAME to EnumName
  if String::starts_with(vk_name, "VK_") {
    let rest = String::drop_prefix(vk_name, 3)
    rest
  } else {
    vk_name
  }
}

fn enum_to_const_name(vk_name : String) -> String {
  vk_name
}

fn generate_struct(struct : VkStruct) -> String {
  let mut code = "type " + struct.name + " {\n"

  for member in struct.members {
    let moonbit_type = map_c_type(member.c_type)
    let field_name = to_camel_case(member.name)
    code = code + "  " + field_name + " : " + moonbit_type + "\n"
  }

  code = code + "}\n"

  // Generate create function
  code = code + "\n"
  code = code + "fn " + to_snake_case(struct.name) + "("
  code = code + struct.members |> Array::map(fn(m) {
    to_snake_case(m.name) + " : " + map_c_type(m.c_type)
  }) |> Array::join(", ")
  code = code + ") -> " + struct.name + " {\n"
  code = code + "  { "
  code = code + struct.members |> Array::map(fn(m) {
    to_camel_case(m.name)
  }) |> Array::join(", ")
  code = code + " }\n"
  code = code + "}\n"

  code
}

fn generate_command(command : VkCommand) -> String {
  let moonbit_name = to_snake_case(String::drop_prefix(command.name, 2))  // Drop "vk"

  // Return type
  let moonbit_return = map_c_type(command.return_type)

  // Parameters
  let mut params_code = ""
  for param in command.params {
    params_code = params_code + to_snake_case(param.name) + " : "
    params_code = params_code + map_param_type(param)
    params_code = params_code + ", "
  }

  // Remove trailing comma
  if String::length(params_code) > 2 {
    params_code = String::substring(params_code, 0, String::length(params_code) - 2)
  }

  let mut code = "fn " + moonbit_name + "(" + params_code + ") -> " + moonbit_return + " = \"" + command.name + "\"\n"

  code
}

fn map_param_type(param : VkParam) -> String {
  let base_type = map_c_type(param.c_type)

  match (param.is_pointer, param.is_pointer_pointer) {
    (false, false) => base_type
    (true, false) => {
      // Single pointer - use Array or Ptr
      if param.array_len.is_some() {
        "Array[" + base_type + "]"
      } else {
        base_type  // Assume opaque handles don't need Array notation
      }
    }
    (_, true) => {
      // Double pointer
      "Array[" + base_type + "]"
    }
  }
}

fn to_snake_case(camel : String) -> String {
  let mut result = ""
  let chars = String::to_array(camel)

  for (i, c) in Array::enumerate(chars) {
    if Char::is_uppercase(c) && i > 0 {
      result = result + "_" + Char::to_lowercase(c)
    } else {
      result = result + Char::to_lowercase(c)
    }
  }

  result
}

fn to_camel_case(snake : String) -> String {
  let mut result = ""
  let mut capitalize_next = false

  for c in String::to_array(snake) {
    if c == '_' {
      capitalize_next = true
    } else {
      if capitalize_next {
        result = result + Char::to_uppercase(c)
        capitalize_next = false
      } else {
        result = result + c
      }
    }
  }

  // Capitalize first letter
  if String::length(result) > 0 {
    let first = String::substring(result, 0, 1)
    let rest = String::drop_prefix(result, 1)
    String::uppercase(first) + rest
  } else {
    result
  }
}
