// Vulkan API data model

pub enum VkTypeCategory {
  Handle
  Enum
  Struct
  FuncPointer
  BaseType
  Define
}

pub enum VkMemberOptional {
  Optional
  Required
}

pub struct VkEnumValue {
  name : String
  value : String
  comment : String
}

pub struct VkEnum {
  name : String
  values : Array[VkEnumValue]
}

pub struct VkStructMember {
  name : String
  c_type : String
  optional : VkMemberOptional
  array_len : Option[String]  // e.g., "enabledLayerCount"
}

pub struct VkStruct {
  name : String
  members : Array[VkStructMember]
  struct_extends : Option[String]  // parent structure name
}

pub struct VkHandle {
  name : String
  parent : Option[String]  // parent handle name
  is_dispatchable : Bool    // VK_DEFINE_HANDLE vs VK_DEFINE_NON_DISPATCHABLE_HANDLE
}

pub struct VkCommand {
  name : String
  params : Array[VkParam]
  return_type : String
}

pub struct VkParam {
  name : String
  c_type : String
  is_const : Bool
  is_pointer : Bool
  is_pointer_pointer : Bool
  array_len : Option[String]
}

pub struct VkRegistry {
  enums : Array[VkEnum]
  structs : Array[VkStruct]
  handles : Array[VkHandle]
  commands : Array[VkCommand]
}

pub fn new_registry() -> VkRegistry {
  { enums: [], structs: [], handles: [], commands: [] }
}

pub fn add_enum(registry : VkRegistry, enum : VkEnum) -> VkRegistry {
  { registry with enums: registry.enums |> Array::append([enum]) }
}

pub fn add_struct(registry : VkRegistry, struct : VkStruct) -> VkRegistry {
  { registry with structs: registry.structs |> Array::append([struct]) }
}

pub fn add_handle(registry : VkRegistry, handle : VkHandle) -> VkRegistry {
  { registry with handles: registry.handles |> Array::append([handle]) }
}

pub fn add_command(registry : VkRegistry, command : VkCommand) -> VkRegistry {
  { registry with commands: registry.commands |> Array::append([command]) }
}

// Find enum by name
pub fn find_enum(registry : VkRegistry, name : String) -> Option[VkEnum] {
  for e in registry.enums {
    if e.name == name {
      return Some(e)
    }
  }
  None
}

// Find struct by name
pub fn find_struct(registry : VkRegistry, name : String) -> Option[VkStruct] {
  for s in registry.structs {
    if s.name == name {
      return Some(s)
    }
  }
  None
}

// Find handle by name
pub fn find_handle(registry : VkRegistry, name : String) -> Option[VkHandle] {
  for h in registry.handles {
    if h.name == name {
      return Some(h)
    }
  }
  None
}

// Find command by name
pub fn find_command(registry : VkRegistry, name : String) -> Option[VkCommand] {
  for c in registry.commands {
    if c.name == name {
      return Some(c)
    }
  }
  None
}
