///|
/// Vulkan Core FFI Function Declarations
/// Direct bindings to Vulkan C API for instance and device management

// Core functions - Instance and Device
// Note: These use wrapper functions in vulkan_ffi.c to handle pointer table conversion
pub extern "C" fn vkCreateInstance(pCreateInfo : Int, pAllocator : Int, pInstance : Int) -> Int = "vulkan_vkCreateInstance"
pub extern "C" fn vkDestroyInstance(instance : Int, pAllocator : Int) -> Unit = "vulkan_vkDestroyInstance"
pub extern "C" fn vkEnumeratePhysicalDevices(instance : Int, pPhysicalDeviceCount : Int, pPhysicalDevices : Int) -> Int = "vulkan_vkEnumeratePhysicalDevices"
pub extern "C" fn vkGetPhysicalDeviceProperties(physicalDevice : Int, pProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceProperties"
pub extern "C" fn vkGetPhysicalDeviceFeatures(physicalDevice : Int, pFeatures : Int) -> Unit = "vulkan_vkGetPhysicalDeviceFeatures"
pub extern "C" fn vkGetPhysicalDeviceMemoryProperties(physicalDevice : Int, pMemoryProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceMemoryProperties"
pub extern "C" fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice : Int, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceQueueFamilyProperties"
pub extern "C" fn vkGetPhysicalDeviceQueueFamilyPropertiesArray(devices : Int, deviceIndex : Int, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vulkan_vkGetPhysicalDeviceQueueFamilyPropertiesArray"
pub extern "C" fn vkCreateDevice(physicalDevice : Int, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vulkan_vkCreateDevice"
pub extern "C" fn vkCreateDeviceArray(devices : Int, deviceIndex : Int, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vulkan_vkCreateDeviceArray"
pub extern "C" fn vkCreateDeviceArraySimple(devices : Int, deviceIndex : Int, queueFamily : Int, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vulkan_vkCreateDeviceArraySimple"
pub extern "C" fn vkDestroyDevice(device : Int, pAllocator : Int) -> Unit = "vulkan_vkDestroyDevice"
pub extern "C" fn vkGetDeviceQueue(device : Int, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vulkan_vkGetDeviceQueue"
pub extern "C" fn vkGetDeviceQueueArray(device : Int, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vulkan_vkGetDeviceQueueArray"
pub extern "C" fn vkDeviceWaitIdle(device : Int) -> Int = "vulkan_vkDeviceWaitIdle"
