///|
/// Vulkan Core FFI Function Declarations
/// Direct bindings to Vulkan C API for instance and device management

// Core functions - Instance and Device
pub extern "C" fn vkCreateInstance(pCreateInfo : Int, pAllocator : Int, pInstance : Int) -> Int = "vkCreateInstance"
pub extern "C" fn vkDestroyInstance(instance : Int, pAllocator : Int) -> Unit = "vkDestroyInstance"
pub extern "C" fn vkEnumeratePhysicalDevices(instance : Int, pPhysicalDeviceCount : Int, pPhysicalDevices : Int) -> Int = "vkEnumeratePhysicalDevices"
pub extern "C" fn vkGetPhysicalDeviceProperties(physicalDevice : Int, pProperties : Int) -> Unit = "vkGetPhysicalDeviceProperties"
pub extern "C" fn vkGetPhysicalDeviceFeatures(physicalDevice : Int, pFeatures : Int) -> Unit = "vkGetPhysicalDeviceFeatures"
pub extern "C" fn vkGetPhysicalDeviceMemoryProperties(physicalDevice : Int, pMemoryProperties : Int) -> Unit = "vkGetPhysicalDeviceMemoryProperties"
pub extern "C" fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice : Int, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vkGetPhysicalDeviceQueueFamilyProperties"
pub extern "C" fn vkCreateDevice(physicalDevice : Int, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vkCreateDevice"
pub extern "C" fn vkDestroyDevice(device : Int, pAllocator : Int) -> Unit = "vkDestroyDevice"
pub extern "C" fn vkGetDeviceQueue(device : Int, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vkGetDeviceQueue"
pub extern "C" fn vkDeviceWaitIdle(device : Int) -> Int = "vkDeviceWaitIdle"
