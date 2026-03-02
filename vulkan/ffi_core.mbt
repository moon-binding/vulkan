///|
/// Vulkan Core FFI Function Declarations
/// Direct bindings to Vulkan C API for instance and device management

// Core functions - Instance and Device
pub extern "C" fn vkCreateInstance(pCreateInfo : Int, pAllocator : Int, pInstance : Int) -> Int = "vulkan_vkCreateInstance"
pub extern "C" fn vkDestroyInstance(instance : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyInstance"
pub extern "C" fn vkEnumeratePhysicalDevices(instance : Int64, pPhysicalDeviceCount : Int, pPhysicalDevices : Int) -> Int = "vulkan_vkEnumeratePhysicalDevices"
pub extern "C" fn vkGetPhysicalDeviceProperties(physicalDevice : Int64, pProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceProperties"
pub extern "C" fn vkGetPhysicalDeviceFeatures(physicalDevice : Int64, pFeatures : Int) -> Unit = "vulkan_vkGetPhysicalDeviceFeatures"
pub extern "C" fn vkGetPhysicalDeviceMemoryProperties(physicalDevice : Int64, pMemoryProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceMemoryProperties"
pub extern "C" fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice : Int64, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceQueueFamilyProperties"
pub extern "C" fn vkGetPhysicalDeviceQueueFamilyPropertiesArray(devices : Int, deviceIndex : Int, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceQueueFamilyPropertiesArray"
pub extern "C" fn vkCreateDevice(physicalDevice : Int64, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vulkan_vkCreateDevice"
pub extern "C" fn vkCreateDeviceDirect(physicalDevice : Int64, queueFamily : Int, deviceIdx : Int) -> Int = "vulkan_vkCreateDeviceDirect"
pub extern "C" fn vkDestroyDevice(device : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyDevice"
pub extern "C" fn vkGetDeviceQueue(device : Int64, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vulkan_vkGetDeviceQueue"
pub extern "C" fn vkGetDeviceQueueArray(device : Int64, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vulkan_vkGetDeviceQueueArray"
pub extern "C" fn vkDeviceWaitIdle(device : Int64) -> Int = "vulkan_vkDeviceWaitIdle"
