///|
/// Vulkan Core FFI Function Declarations
/// Direct bindings to Vulkan C API for instance and device management

// Core functions - Instance and Device
extern "C" fn vkCreateInstance(pCreateInfo : Int, pAllocator : Int, pInstance : Int) -> Int = "vkCreateInstance"
extern "C" fn vkDestroyInstance(instance : Int, pAllocator : Int) -> Unit = "vkDestroyInstance"
extern "C" fn vkEnumeratePhysicalDevices(instance : Int, pPhysicalDeviceCount : Int, pPhysicalDevices : Int) -> Int = "vkEnumeratePhysicalDevices"
extern "C" fn vkGetPhysicalDeviceProperties(physicalDevice : Int, pProperties : Int) -> Unit = "vkGetPhysicalDeviceProperties"
extern "C" fn vkGetPhysicalDeviceFeatures(physicalDevice : Int, pFeatures : Int) -> Unit = "vkGetPhysicalDeviceFeatures"
extern "C" fn vkGetPhysicalDeviceMemoryProperties(physicalDevice : Int, pMemoryProperties : Int) -> Unit = "vkGetPhysicalDeviceMemoryProperties"
extern "C" fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice : Int, pQueueFamilyPropertyCount : Int, pQueueFamilyProperties : Int) -> Unit = "vkGetPhysicalDeviceQueueFamilyProperties"
extern "C" fn vkCreateDevice(physicalDevice : Int, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vkCreateDevice"
extern "C" fn vkDestroyDevice(device : Int, pAllocator : Int) -> Unit = "vkDestroyDevice"
extern "C" fn vkGetDeviceQueue(device : Int, queueFamilyIndex : Int, queueIndex : Int, pQueue : Int) -> Unit = "vkGetDeviceQueue"
extern "C" fn vkDeviceWaitIdle(device : Int) -> Int = "vkDeviceWaitIdle"
