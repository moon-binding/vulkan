///|
/// Vulkan Physical Device Selection using MoonBit
/// This module demonstrates selecting and creating Vulkan devices using MoonBit
///
/// Note: This module relies on common FFI bindings and constants defined in
/// vulkan_instance.mbt to avoid duplication.

// FFI bindings for device enumeration and creation
extern "C" fn vkEnumeratePhysicalDevices(instance : Int64, pPhysicalDeviceCount : Int, pPhysicalDevices : Int) -> Int = "vulkan_vkEnumeratePhysicalDevices"
extern "C" fn vkGetPhysicalDeviceProperties(physicalDevice : Int64, pProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceProperties"
extern "C" fn vkGetPhysicalDeviceFeatures(physicalDevice : Int64, pFeatures : Int) -> Unit = "vulkan_vkGetPhysicalDeviceFeatures"
extern "C" fn vkCreateDeviceDirect(physicalDevice : Int64, queueFamily : Int, deviceIdx : Int) -> Int = "vulkan_vkCreateDeviceDirect"
extern "C" fn vkDestroyDevice(device : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyDevice"

// Memory helper functions (defined in vulkan_ffi.c)
extern "C" fn vulkan_get_device_name(properties_idx : Int) -> Int = "vulkan_get_device_name"
extern "C" fn vulkan_read_char(str_idx : Int, offset : Int) -> Int = "vulkan_read_char"

// Queue family properties
extern "C" fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice : Int64, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceQueueFamilyProperties"
extern "C" fn vkGetDeviceQueue(device : Int64, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vulkan_vkGetDeviceQueue"

// Additional Vulkan constants (device-specific)
pub const VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO : Int = 5
pub const VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO : Int = 6
pub const VK_QUEUE_GRAPHICS_BIT : Int = 0x00000001
pub const VK_MAX_PHYSICAL_DEVICE_NAME_SIZE : Int = 256

// Result type for physical device selection
pub enum DeviceSelectionResult {
  DeviceSelected(Int64, Int64)  // (physical device, logical device)
  DeviceError(String)
}

// Result type for logical device creation
pub enum LogicalDeviceResult {
  DeviceCreated(Int64)  // Logical device handle
  DeviceError(String)
}

// Helper function to read device name from properties
fn get_device_name_from_properties(properties_idx : Int) -> String {
  let name_idx = vulkan_get_device_name(properties_idx)

  // For simplicity, just return a placeholder name
  // In a real implementation, we would read the actual device name
  let mut i = 0
  while i < VK_MAX_PHYSICAL_DEVICE_NAME_SIZE {
    let ch = vulkan_read_char(name_idx, i)
    if ch == 0 {
      break  // Null terminator
    }
    i = i + 1
  }

  "Physical Device"
}

// Enumerate physical devices and select the first suitable one
pub fn select_physical_device(instance : Int64) -> Int64 {
  println("Enumerating physical devices...")

  // First call to get the count
  let count_buffer = vulkan_alloc_struct(4)
  let result = vkEnumeratePhysicalDevices(instance, count_buffer, 0)

  if result != VK_SUCCESS {
    println("Failed to enumerate physical devices")
    return 0
  }

  let device_count = vulkan_get_int32(count_buffer, 0)
  println("Found " + device_count.to_string() + " physical device(s)")

  if device_count == 0 {
    println("No physical devices available")
    return 0
  }

  // Allocate buffer for device handles
  let devices_buffer = vulkan_alloc_struct(device_count * 8)

  // Second call to get the actual devices
  // We need to pass the count buffer again
  let result = vkEnumeratePhysicalDevices(instance, count_buffer, devices_buffer)

  if result != VK_SUCCESS {
    println("Failed to get physical devices list, error: " + result.to_string())
    return 0
  }

  // For simplicity, just select the first device
  let physical_device = vulkan_get_int64(devices_buffer, 0)

  // Get and print device name
  let properties_buffer = vulkan_alloc_struct(512)  // VkPhysicalDeviceProperties size
  vkGetPhysicalDeviceProperties(physical_device, properties_buffer)
  let device_name = get_device_name_from_properties(properties_buffer)
  println("Selected physical device: " + device_name)

  physical_device
}

// Find a queue family that supports graphics operations
pub fn find_graphics_queue_family(physical_device : Int64) -> Int {
  println("Finding graphics queue family...")

  // First call to get count
  let count_buffer = vulkan_alloc_struct(4)
  vkGetPhysicalDeviceQueueFamilyProperties(physical_device, count_buffer, 0)

  let queue_family_count = vulkan_get_int32(count_buffer, 0)
  println("Queue family count: " + queue_family_count.to_string())

  // Allocate buffer for queue family properties
  // VkQueueFamilyProperties is typically 32 bytes (8 + 4 + 4 + 4 + 4 + 4 + 4)
  let properties_buffer = vulkan_alloc_struct(queue_family_count * 32)

  // Second call to get actual properties - pass count_buffer again
  vkGetPhysicalDeviceQueueFamilyProperties(physical_device, count_buffer, properties_buffer)

  // Find first queue family that supports graphics
  let mut i = 0
  while i < queue_family_count {
    // VkQueueFamilyProperties structure layout:
    // offset 0: queueFlags (VkQueueFlags = uint32_t)
    // offset 4: queueCount (uint32_t)
    // offset 8: timestampValidBits (uint32_t)
    // offset 12: minImageTransferGranularity (VkExtent3D = 3 * uint32_t)
    let queue_flags = vulkan_get_int32(properties_buffer, i * 32)
    let queue_count = vulkan_get_int32(properties_buffer, i * 32 + 4)

    println("Queue family " + i.to_string() + ": flags=" + queue_flags.to_string() +
            ", count=" + queue_count.to_string())

    if (queue_flags & VK_QUEUE_GRAPHICS_BIT) != 0 {
      println("Found graphics queue family: " + i.to_string())
      return i
    }

    i = i + 1
  }

  println("No graphics queue family found!")
  return -1
}

// Create a logical device
pub fn create_logical_device(physical_device : Int64, queue_family_index : Int) -> LogicalDeviceResult {
  println("Creating logical device...")

  // Allocate buffer to receive device handle
  let device_buffer = vulkan_alloc_struct(8)

  // Create device using the simplified Direct API
  let result = vkCreateDeviceDirect(physical_device, queue_family_index, device_buffer)

  if result != VK_SUCCESS {
    return DeviceError("Failed to create logical device, error code: " + result.to_string())
  }

  let device = vulkan_get_int64(device_buffer, 0)
  println("Logical device created successfully!")

  DeviceCreated(device)
}

// Complete device selection and creation process
pub fn initialize_device(instance : Int64) -> DeviceSelectionResult {
  // Select physical device
  let physical_device = select_physical_device(instance)

  if physical_device == 0 {
    return DeviceError("Failed to select physical device")
  }

  // Find graphics queue family
  let queue_family = find_graphics_queue_family(physical_device)

  if queue_family < 0 {
    return DeviceError("Failed to find graphics queue family")
  }

  // Create logical device
  match create_logical_device(physical_device, queue_family) {
    DeviceCreated(device) => {
      DeviceSelected(physical_device, device)
    }
    DeviceError(msg) => {
      DeviceError(msg)
    }
  }
}

// Destroy logical device
pub fn destroy_logical_device(device : Int64) -> Unit {
  if device != 0 {
    vkDestroyDevice(device, 0)
    println("Logical device destroyed")
  }
}
