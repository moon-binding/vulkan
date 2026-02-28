///|
/// MoonBit Vulkan SDK Bindings - Initialization Structs
/// Vulkan instance and device creation structures

// Application Info
pub struct VkApplicationInfo {
  sType : Int
  pNext : Int
  pApplicationName : Int
  applicationVersion : Int
  pEngineName : Int
  engineVersion : Int
  apiVersion : Int
}

pub fn application_info(
  sType : Int,
  pNext : Int,
  pApplicationName : Int,
  applicationVersion : Int,
  pEngineName : Int,
  engineVersion : Int,
  apiVersion : Int
) -> VkApplicationInfo {
  { sType: sType, pNext: pNext, pApplicationName: pApplicationName, applicationVersion: applicationVersion, pEngineName: pEngineName, engineVersion: engineVersion, apiVersion: apiVersion }
}

// Instance Create Info
pub struct VkInstanceCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  pApplicationInfo : Int
  enabledLayerCount : Int
  ppEnabledLayerNames : Int
  enabledExtensionCount : Int
  ppEnabledExtensionNames : Int
}

pub fn instance_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  pApplicationInfo : Int,
  enabledLayerCount : Int,
  ppEnabledLayerNames : Int,
  enabledExtensionCount : Int,
  ppEnabledExtensionNames : Int
) -> VkInstanceCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, pApplicationInfo: pApplicationInfo, enabledLayerCount: enabledLayerCount, ppEnabledLayerNames: ppEnabledLayerNames, enabledExtensionCount: enabledExtensionCount, ppEnabledExtensionNames: ppEnabledExtensionNames }
}

// Device Queue Create Info
pub struct VkDeviceQueueCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  queueFamilyIndex : Int
  queueCount : Int
  pQueuePriorities : Int
}

pub fn device_queue_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  queueFamilyIndex : Int,
  queueCount : Int,
  pQueuePriorities : Int
) -> VkDeviceQueueCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, queueFamilyIndex: queueFamilyIndex, queueCount: queueCount, pQueuePriorities: pQueuePriorities }
}

// Device Create Info
pub struct VkDeviceCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  queueCreateInfoCount : Int
  pQueueCreateInfos : Int
  enabledLayerCount : Int
  ppEnabledLayerNames : Int
  enabledExtensionCount : Int
  ppEnabledExtensionNames : Int
  pEnabledFeatures : Int
}

pub fn device_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  queueCreateInfoCount : Int,
  pQueueCreateInfos : Int,
  enabledLayerCount : Int,
  ppEnabledLayerNames : Int,
  enabledExtensionCount : Int,
  ppEnabledExtensionNames : Int,
  pEnabledFeatures : Int
) -> VkDeviceCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, queueCreateInfoCount: queueCreateInfoCount, pQueueCreateInfos: pQueueCreateInfos, enabledLayerCount: enabledLayerCount, ppEnabledLayerNames: ppEnabledLayerNames, enabledExtensionCount: enabledExtensionCount, ppEnabledExtensionNames: ppEnabledExtensionNames, pEnabledFeatures: pEnabledFeatures }
}

// Queue Family Properties
pub struct VkQueueFamilyProperties {
  queueFlags : Int
  queueCount : Int
  timestampValidBits : Int
  minImageTransferGranularity : VkExtent3D
}
