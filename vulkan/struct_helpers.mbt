///|
/// MoonBit Vulkan SDK Bindings - Struct Helpers
/// Helper functions for allocating, initializing, and managing Vulkan structures
///
/// This module provides utilities to work with Vulkan structures in MoonBit,
/// including memory allocation, field access, and conversion between MoonBit
/// structs and C-compatible pointers.

// Note: Structure type constants are defined in structure_types.mbt
// and are accessible in the same package

// Allocate memory for a structure
pub extern "C" fn vulkan_alloc_struct(size : Int) -> Int = "vulkan_alloc_struct"

// Free structure memory
pub extern "C" fn vulkan_free_struct(ptr : Int) -> Unit = "vulkan_free_struct"

// Allocate and initialize VkApplicationInfo
pub fn alloc_application_info() -> Int {
  let size = 56 // sizeof(VkApplicationInfo) = 7 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  // Initialize fields
  put_int32(ptr, 0, VK_STRUCTURE_TYPE_APPLICATION_INFO)       // sType
  put_int64(ptr, 8, 0)                                        // pNext
  put_int64(ptr, 16, 0)                                       // pApplicationName
  put_int32(ptr, 24, 0)                                       // applicationVersion
  put_int64(ptr, 32, 0)                                       // pEngineName
  put_int32(ptr, 40, 0)                                       // engineVersion
  put_int32(ptr, 48, 4206822)                                 // apiVersion (1.3.0)

  ptr
}

// Set application name (simplified - just stores pointer)
pub fn set_application_name(app_info : Int, name : Int) -> Unit {
  put_int64(app_info, 16, name)
}

// Set engine name (simplified - just stores pointer)
pub fn set_engine_name(app_info : Int, name : Int) -> Unit {
  put_int64(app_info, 32, name)
}

// Set application version
pub fn set_application_version(app_info : Int, version : Int) -> Unit {
  put_int32(app_info, 24, version)
}

// Set engine version
pub fn set_engine_version(app_info : Int, version : Int) -> Unit {
  put_int32(app_info, 40, version)
}

// Allocate and initialize VkInstanceCreateInfo
pub fn alloc_instance_create_info() -> Int {
  let size = 64 // sizeof(VkInstanceCreateInfo) = 8 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  // Initialize fields
  put_int32(ptr, 0, VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO)   // sType
  put_int64(ptr, 8, 0)                                        // pNext
  put_int32(ptr, 16, 0)                                       // flags
  put_int64(ptr, 24, 0)                                       // pApplicationInfo
  put_int32(ptr, 32, 0)                                       // enabledLayerCount
  put_int64(ptr, 40, 0)                                       // ppEnabledLayerNames
  put_int32(ptr, 48, 0)                                       // enabledExtensionCount
  put_int64(ptr, 56, 0)                                       // ppEnabledExtensionNames

  ptr
}

// Set application info in instance create info
pub fn set_instance_app_info(create_info : Int, app_info : Int) -> Unit {
  put_int64(create_info, 24, app_info)
}

// Enable extensions in instance create info
pub fn set_instance_extensions(create_info : Int, count : Int, names : Int) -> Unit {
  put_int32(create_info, 48, count)
  put_int64(create_info, 56, names)
}

// Allocate and initialize VkDeviceQueueCreateInfo
pub fn alloc_device_queue_create_info() -> Int {
  let size = 48 // sizeof(VkDeviceQueueCreateInfo) = 6 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  // Initialize fields
  put_int32(ptr, 0, VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO) // sType
  put_int64(ptr, 8, 0)                                        // pNext
  put_int32(ptr, 16, 0)                                       // flags
  put_int32(ptr, 24, 0)                                       // queueFamilyIndex
  put_int32(ptr, 28, 1)                                       // queueCount
  put_int64(ptr, 32, 0)                                       // pQueuePriorities

  ptr
}

// Set queue family index
pub fn set_queue_family_index(queue_info : Int, index : Int) -> Unit {
  put_int32(queue_info, 24, index)
}

// Set queue count
pub fn set_queue_count(queue_info : Int, count : Int) -> Unit {
  put_int32(queue_info, 28, count)
}

// Set queue priorities pointer
pub fn set_queue_priorities(queue_info : Int, priorities : Int) -> Unit {
  put_int64(queue_info, 32, priorities)
}

// Allocate and initialize VkDeviceCreateInfo
pub fn alloc_device_create_info() -> Int {
  let size = 72 // sizeof(VkDeviceCreateInfo) = 9 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  // Initialize fields
  put_int32(ptr, 0, VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO)       // sType
  put_int64(ptr, 8, 0)                                        // pNext
  put_int32(ptr, 16, 0)                                       // flags
  put_int32(ptr, 24, 0)                                       // queueCreateInfoCount
  put_int64(ptr, 32, 0)                                       // pQueueCreateInfos
  put_int32(ptr, 40, 0)                                       // enabledLayerCount
  put_int64(ptr, 48, 0)                                       // ppEnabledLayerNames
  put_int32(ptr, 56, 0)                                       // enabledExtensionCount
  put_int64(ptr, 64, 0)                                       // ppEnabledExtensionNames
  put_int64(ptr, 72, 0)                                       // pEnabledFeatures

  ptr
}

// Set queue create infos
pub fn set_device_queues(create_info : Int, count : Int, queues : Int) -> Unit {
  put_int32(create_info, 24, count)
  put_int64(create_info, 32, queues)
}

// Set device extensions
pub fn set_device_extensions(create_info : Int, count : Int, names : Int) -> Unit {
  put_int32(create_info, 56, count)
  put_int64(create_info, 64, names)
}

// Allocate and initialize VkSwapchainCreateInfoKHR
pub fn alloc_swapchain_create_info() -> Int {
  let size = 112 // sizeof(VkSwapchainCreateInfoKHR) = 14 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  // Initialize fields
  put_int32(ptr, 0, VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR) // sType
  put_int64(ptr, 8, 0)                                              // pNext
  put_int32(ptr, 16, 0)                                             // flags
  put_int64(ptr, 24, 0)                                             // surface
  put_int32(ptr, 32, 2)                                             // minImageCount
  put_int32(ptr, 36, 37)                                            // imageFormat (VK_FORMAT_B8G8R8A8_SRGB)
  put_int32(ptr, 40, 0)                                             // imageColorSpace
  put_int32(ptr, 44, 800)                                           // imageExtent.width
  put_int32(ptr, 48, 600)                                           // imageExtent.height
  put_int32(ptr, 52, 1)                                             // imageArrayLayers
  put_int32(ptr, 56, 16)                                            // imageUsage (VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT)
  put_int32(ptr, 60, 0)                                             // imageSharingMode (VK_SHARING_MODE_EXCLUSIVE)
  put_int32(ptr, 64, 0)                                             // queueFamilyIndexCount
  put_int64(ptr, 72, 0)                                             // pQueueFamilyIndices
  put_int32(ptr, 80, 1)                                             // preTransform (VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR)
  put_int32(ptr, 84, 1)                                             // compositeAlpha (VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR)
  put_int32(ptr, 88, 1)                                             // presentMode (VK_PRESENT_MODE_FIFO_KHR)
  put_int32(ptr, 92, 1)                                             // clipped
  put_int64(ptr, 96, 0)                                             // oldSwapchain

  ptr
}

// Set surface in swapchain create info
pub fn set_swapchain_surface(create_info : Int, surface : Int) -> Unit {
  put_int64(create_info, 24, surface)
}

// Set image extent
pub fn set_swapchain_extent(create_info : Int, width : Int, height : Int) -> Unit {
  put_int32(create_info, 44, width)
  put_int32(create_info, 48, height)
}

// Set min image count
pub fn set_swapchain_min_image_count(create_info : Int, count : Int) -> Unit {
  put_int32(create_info, 32, count)
}

// Memory access helpers (using C functions)
pub extern "C" fn put_int32(ptr : Int, offset : Int, value : Int) -> Unit = "vulkan_put_int32"
pub extern "C" fn put_int64(ptr : Int, offset : Int, value : Int) -> Unit = "vulkan_put_int64"
pub extern "C" fn get_int32(ptr : Int, offset : Int) -> Int = "vulkan_get_int32"
pub extern "C" fn get_int64(ptr : Int, offset : Int) -> Int = "vulkan_get_int64"

// Utility function to create string for Vulkan
pub extern "C" fn vulkan_create_string(s : String) -> Int = "vulkan_create_string"
pub extern "C" fn vulkan_free_string(ptr : Int) -> Unit = "vulkan_free_string"
