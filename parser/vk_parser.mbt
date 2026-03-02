// Parse Vulkan XML registry into data model

use xml_parser.{XmlNode, XmlElement, find_children, find_child, get_attr, get_text}
use vk_model.{VkRegistry, VkEnum, VkEnumValue, VkStruct, VkStructMember,
               VkHandle, VkCommand, VkParam, VkTypeCategory,
               VkMemberOptional, new_registry, add_enum, add_struct, add_handle, add_command}

pub fn parse_vk_registry(xml_content : String) -> Result[VkRegistry, String] {
  let xml_node = xml_parser::parse_xml(xml_content)?

  // Find the root <registry> element
  let registry_node = find_registry_root(xml_node)?
  let mut registry = new_registry()

  // Parse types (handles, structs, enums)
  let types_node = find_child(registry_node, "types")
  match types_node {
    None => { }
    Some(types) => {
      for type_node in find_children(types, "type") {
        let category = get_attr(type_node, "category")

        match category {
          Some("handle") => {
            match parse_handle(type_node) {
              Ok(handle) => {
                // Only add if it's not a define (actual handle type)
                registry = add_handle(registry, handle)
              }
              Err(_) => { }
            }
          }
          Some("struct") => {
            match parse_struct(type_node) {
              Ok(s) => { registry = add_struct(registry, s) }
              Err(_) => { }
            }
          }
          _ => { }
        }
      }
    }
  }

  // Parse enums
  let enums_node = find_child(registry_node, "enums")
  match enums_node {
    None => { }
    Some(enums) => {
      for enum_node in find_children(enums, "enum") {
        match parse_enum(enum_node) {
          Ok(e) => { registry = add_enum(registry, e) }
          Err(_) => { }
        }
      }
    }
  }

  // Parse commands
  let commands_node = find_child(registry_node, "commands")
  match commands_node {
    None => { }
    Some(commands) => {
      for command_node in find_children(commands, "command") {
        match parse_command(command_node) {
          Ok(cmd) => { registry = add_command(registry, cmd) }
          Err(_) => { }
        }
      }
    }
  }

  Ok(registry)
}

fn find_registry_root(node : XmlNode) -> Result[XmlNode, String] {
  match node {
    XmlElement("registry", _, children) => {
      // Return registry node (but need to reconstruct it)
      Ok(node)
    }
    XmlElement(name, _, children) => {
      for child in children {
        match find_registry_root(child) {
          Ok(n) => return Ok(n)
          Err(_) => { }
        }
      }
      Err("Registry root not found")
    }
    _ => Err("Invalid XML structure")
  }
}

fn parse_handle(node : XmlNode) -> Result[VkHandle, String] {
  let name_opt = get_attr(node, "name")
  match name_opt {
    None => Err("Handle missing name")
    Some(name) => {
      let parent = get_attr(node, "parent")
      let is_dispatchable = match get_attr(node, "objtypeenum") {
        None => true  // Default to dispatchable
        Some(_) => {
          // Check if it uses VK_DEFINE_NON_DISPATCHABLE_HANDLE
          let text = get_text(node)
          String::contains(text, "VK_DEFINE_NON_DISPATCHABLE_HANDLE") |> not
        }
      }
      Ok({ name: name, parent: parent, is_dispatchable: is_dispatchable })
    }
  }
}

fn parse_struct(node : XmlNode) -> Result[VkStruct, String] {
  let name = get_attr(node, "name")?
  let struct_extends = get_attr(node, "structextends")

  let mut members : Array[VkStructMember] = []
  for member_node in find_children(node, "member") {
    match parse_struct_member(member_node) {
      Ok(m) => { members = members |> Array::append([m]) }
      Err(_) => { }
    }
  }

  Ok({ name: name, members: members, struct_extends: struct_extends })
}

fn parse_struct_member(node : XmlNode) -> Result[VkStructMember, String] {
  let optional = if get_attr(node, "optional").is_some() {
    VkMemberOptional::Optional
  } else {
    VkMemberOptional::Required
  }

  let array_len = get_attr(node, "len")

  // Parse type and name from member text
  let text = get_text(node)
  let parts = String::split(String::trim(text), " ")
    |> Array::filter(fn(s) { s != "" && s != ";" && s != "const" })

  let c_type = match Array::get(parts, 0) {
    None => return Err("Member missing type"),
    Some(t) => t
  }

  let name = match Array::get(parts, Array::length(parts) - 1) {
    None => return Err("Member missing name"),
    Some(n) => {
      // Remove trailing semicolon if present
      if String::ends_with(n, ";") {
        String::drop_suffix(n, 1)
      } else {
        n
      }
    }
  }

  Ok({ name: name, c_type: c_type, optional: optional, array_len: array_len })
}

fn parse_enum(node : XmlNode) -> Result[VkEnum, String] {
  let name = get_attr(node, "name")

  // Parse as top-level enum (not just a value)
  match name {
    None => Err("Enum missing name"),
    Some(enum_name) => {
      let value = get_attr(node, "value")
      let comment = get_attr(node, "comment").unwrap_or("")

      // Single enum value (used in inline contexts)
      Ok({
        name: enum_name,
        values: [{ name: enum_name, value: value.unwrap_or(""), comment: comment }]
      })
    }
  }
}

fn parse_command(node : XmlNode) -> Result[VkCommand, String] {
  // Command can be a proto (prototype) or full definition
  let proto = find_child(node, "proto")
  match proto {
    None => {
      // Might be a reference without proto, skip
      Err("Command missing proto")
    }
    Some(p) => {
      let name_node = find_child(p, "name")
      let name = match name_node {
        None => return Err("Command missing name"),
        Some(n) => get_text(n)
      }

      // Determine return type
      let return_type_node = find_child(p, "type")
      let return_type = match return_type_node {
        None => "void",
        Some(t) => get_text(t)
      }

      // Parse parameters
      let mut params : Array[VkParam] = []
      for param_node in find_children(node, "param") {
        match parse_param(param_node) {
          Ok(p) => { params = params |> Array::append([p]) }
          Err(_) => { }
        }
      }

      Ok({ name: name, params: params, return_type: return_type })
    }
  }
}

fn parse_param(node : XmlNode) -> Result[VkParam, String] {
  let optional = get_attr(node, "optional").is_some()
  let array_len = get_attr(node, "len")

  let name_node = find_child(node, "name")
  let name = match name_node {
    None => return Err("Param missing name"),
    Some(n) => get_text(n)
  }

  let type_node = find_child(node, "type")
  let c_type = match type_node {
    None => "void",
    Some(t) => get_text(t)
  }

  // Check for const and pointer
  let text = get_text(node)
  let is_const = String::contains(text, "const")
  let is_pointer = String::contains(text, "*") && not (String::contains(text, "**"))
  let is_pointer_pointer = String::contains(text, "**")

  Ok({
    name: name,
    c_type: c_type,
    is_const: is_const,
    is_pointer: is_pointer,
    is_pointer_pointer: is_pointer_pointer,
    array_len: array_len
  })
}
