///|
/// Vulkan Instance Creation using MoonBit
/// This module demonstrates creating a Vulkan instance without C code
///
/// Note: This is a first step towards replacing C code with MoonBit.
/// Currently, we still use some C FFI functions, but the logic is in MoonBit.

// FFI bindings for Vulkan instance creation
extern "C" fn vkCreateInstance(pCreateInfo : Int, pAllocator : Int, pInstance : Int) -> Int = "vulkan_vkCreateInstance"
extern "C" fn vkDestroyInstance(instance : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyInstance"

// Bridge function for instance creation with proper extension support
extern "C" fn vk_create_instance_bridge(appName : Int) -> Int64 = "moonbit_vk_create_instance_bridge"

// Memory helper functions (from vulkan_ffi.c)
extern "C" fn vulkan_alloc_struct(size : Int) -> Int = "vulkan_alloc_struct"
extern "C" fn vulkan_free_struct(ptr : Int) -> Unit = "vulkan_free_struct"
extern "C" fn vulkan_put_int32(ptr : Int, offset : Int, value : Int) -> Unit = "vulkan_put_int32"
extern "C" fn vulkan_get_int32(ptr : Int, offset : Int) -> Int = "vulkan_get_int32"
extern "C" fn vulkan_get_int64(ptr : Int, offset : Int) -> Int64 = "vulkan_get_int64"

// Vulkan constants (from Vulkan SDK)
pub const VK_SUCCESS : Int = 0
pub const VK_ERROR_OUT_OF_HOST_MEMORY : Int = -1
pub const VK_ERROR_OUT_OF_DEVICE_MEMORY : Int = -2
pub const VK_ERROR_INITIALIZATION_FAILED : Int = -3
pub const VK_ERROR_LAYER_NOT_PRESENT : Int = -4
pub const VK_ERROR_EXTENSION_NOT_PRESENT : Int = -5
pub const VK_ERROR_INCOMPATIBLE_DRIVER : Int = -6

// VkStructureType values
pub const VK_STRUCTURE_TYPE_APPLICATION_INFO : Int = 0
pub const VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO : Int = 1

// Result type
pub enum InstanceResult {
  InstanceCreated(Int64)  // Instance handle
  InstanceError(String)
}

// Helper function to initialize VkApplicationInfo structure
fn alloc_application_info() -> Int {
  let ptr = vulkan_alloc_struct(56)  // sizeof(VkApplicationInfo) = 7 * 8 bytes

  // Initialize fields (offsets in bytes)
  vulkan_put_int32(ptr, 0, VK_STRUCTURE_TYPE_APPLICATION_INFO)  // sType
  vulkan_put_int32(ptr, 8, 0)   // pNext (NULL)
  vulkan_put_int32(ptr, 16, 0)  // pApplicationName (NULL)
  vulkan_put_int32(ptr, 24, 0)  // applicationVersion
  vulkan_put_int32(ptr, 32, 0)  // pEngineName (NULL)
  vulkan_put_int32(ptr, 40, 0)  // engineVersion
  vulkan_put_int32(ptr, 44, 4206822)  // apiVersion (1.3.0)

  ptr
}

// Helper function to initialize VkInstanceCreateInfo structure
fn alloc_instance_create_info() -> Int {
  let ptr = vulkan_alloc_struct(56)  // Approximate size

  // Initialize fields
  vulkan_put_int32(ptr, 0, VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO)  // sType
  vulkan_put_int32(ptr, 8, 0)   // pNext (NULL)
  vulkan_put_int32(ptr, 16, 0)  // flags
  vulkan_put_int32(ptr, 24, 0)  // pApplicationInfo (NULL for now)
  vulkan_put_int32(ptr, 32, 0)  // enabledLayerCount
  vulkan_put_int32(ptr, 40, 0)  // ppEnabledLayerNames (NULL)
  vulkan_put_int32(ptr, 48, 0)  // enabledExtensionCount
  vulkan_put_int32(ptr, 56, 0)  // ppEnabledExtensionNames (NULL)

  ptr
}

// Create Vulkan instance using C bridge (for proper extension support)
pub fn create_vulkan_instance() -> InstanceResult {
  println("Creating Vulkan instance with MoonBit (using C bridge for extensions)...")

  // Use C bridge which properly handles GLFW extensions
  // Pass 0 for title - C bridge will use a default title
  let instance = vk_create_instance_bridge(0)

  if instance == 0 {
    return InstanceError("Failed to create Vulkan instance")
  }

  println("Vulkan instance created successfully!")
  println("Instance handle: " + instance.to_string())

  InstanceCreated(instance)
}

// Destroy Vulkan instance
pub fn destroy_vulkan_instance(instance : Int64) -> Unit {
  if instance != 0 {
    vkDestroyInstance(instance, 0)
    println("Vulkan instance destroyed")
  }
}
