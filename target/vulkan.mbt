// Generated MoonBit Vulkan bindings
// DO NOT EDIT - generated from vk.xml

foreign vulkan lib "libvulkan.so"

// Handles
type VkInstance = U64
type VkPhysicalDevice = U64

// Enums
type VkResult =
  | SUCCESS
  | NOT_READY
  | TIMEOUT
  | EVENT_SET
  | EVENT_RESET
  | INCOMPLETE
  | ERROR_OUT_OF_HOST_MEMORY
  | ERROR_OUT_OF_DEVICE_MEMORY
  | ERROR_INITIALIZATION_FAILED

// Note: In MoonBit, enum constructors ARE the values
// For FFI with C enums, we need to map between them
fn vk_result_to_int(r : VkResult) -> U32 {
  match r {
    SUCCESS => 0U32
    NOT_READY => 1U32
    TIMEOUT => 2U32
    EVENT_SET => 3U32
    EVENT_RESET => 4U32
    INCOMPLETE => 5U32
    ERROR_OUT_OF_HOST_MEMORY => 4294967295U32  // -1 as U32
    ERROR_OUT_OF_DEVICE_MEMORY => 4294967294U32  // -2 as U32
    ERROR_INITIALIZATION_FAILED => 4294967293U32  // -3 as U32
  }
}

fn int_to_vk_result(i : U32) -> VkResult {
  match i {
    0U32 => SUCCESS
    1U32 => NOT_READY
    2U32 => TIMEOUT
    3U32 => EVENT_SET
    4U32 => EVENT_RESET
    5U32 => INCOMPLETE
    4294967295U32 => ERROR_OUT_OF_HOST_MEMORY
    4294967294U32 => ERROR_OUT_OF_DEVICE_MEMORY
    4294967293U32 => ERROR_INITIALIZATION_FAILED
    _ => SUCCESS
  }
}

// Convenience constants (using MoonBit enum constructors)
let VK_SUCCESS = SUCCESS
let VK_NOT_READY = NOT_READY
let VK_TIMEOUT = TIMEOUT
let VK_EVENT_SET = EVENT_SET
let VK_EVENT_RESET = EVENT_RESET
let VK_INCOMPLETE = INCOMPLETE
let VK_ERROR_OUT_OF_HOST_MEMORY = ERROR_OUT_OF_HOST_MEMORY
let VK_ERROR_OUT_OF_DEVICE_MEMORY = ERROR_OUT_OF_DEVICE_MEMORY
let VK_ERROR_INITIALIZATION_FAILED = ERROR_INITIALIZATION_FAILED

type VkStructureType =
  | APPLICATION_INFO
  | INSTANCE_CREATE_INFO

let VK_STRUCTURE_TYPE_APPLICATION_INFO = APPLICATION_INFO
let VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO = INSTANCE_CREATE_INFO

// Structs
type VkApplicationInfo {
  sType : VkStructureType
  pNext : U64  // void*
  pApplicationName : U64  // const char*
  applicationVersion : U32
  pEngineName : U64  // const char*
  engineVersion : U32
  apiVersion : U32
}

fn vk_application_info(sType : VkStructureType, pNext : U64, pApplicationName : U64,
                        applicationVersion : U32, pEngineName : U64, engineVersion : U32,
                        apiVersion : U32) -> VkApplicationInfo {
  { sType, pNext, pApplicationName, applicationVersion, pEngineName, engineVersion, apiVersion }
}

type VkInstanceCreateInfo {
  sType : VkStructureType
  pNext : U64
  flags : U32
  pApplicationInfo : U64  // const VkApplicationInfo*
  enabledLayerCount : U32
  ppEnabledLayerNames : U64  // const char* const*
  enabledExtensionCount : U32
  ppEnabledExtensionNames : U64  // const char* const*
}

fn vk_instance_create_info(sType : VkStructureType, pNext : U64, flags : U32,
                            pApplicationInfo : U64, enabledLayerCount : U32,
                            ppEnabledLayerNames : U64, enabledExtensionCount : U32,
                            ppEnabledExtensionNames : U64) -> VkInstanceCreateInfo {
  { sType, pNext, flags, pApplicationInfo, enabledLayerCount, ppEnabledLayerNames,
    enabledExtensionCount, ppEnabledExtensionNames }
}

// Commands - these map directly to C functions
// Parameters passed as U64 pointers for MVP simplicity
fn vk_create_instance(pCreateInfo : U64, pAllocator : U64, pInstance : U64) -> U32 = "vkCreateInstance"
fn vk_enumerate_physical_devices(instance : VkInstance, pPhysicalDeviceCount : U64,
                                  pPhysicalDevices : U64) -> U32 = "vkEnumeratePhysicalDevices"
