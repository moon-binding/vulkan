///|
/// Vulkan Surface FFI Function Declarations
/// Direct bindings to Vulkan C API for surface management

extern "C" fn vkCreateSurfaceKHR(instance : Int, pCreateInfo : Int, pAllocator : Int, pSurface : Int) -> Int = "vkCreateSurfaceKHR"
extern "C" fn vkDestroySurfaceKHR(instance : Int, surface : Int, pAllocator : Int) -> Unit = "vkDestroySurfaceKHR"
extern "C" fn vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice : Int, queueFamilyIndex : Int, surface : Int, pSupported : Int) -> Int = "vkGetPhysicalDeviceSurfaceSupportKHR"
extern "C" fn vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice : Int, surface : Int, pSurfaceCapabilities : Int) -> Int = "vkGetPhysicalDeviceSurfaceCapabilitiesKHR"
extern "C" fn vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice : Int, surface : Int, pSurfaceFormatCount : Int, pSurfaceFormats : Int) -> Int = "vkGetPhysicalDeviceSurfaceFormatsKHR"
extern "C" fn vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice : Int, surface : Int, pPresentModeCount : Int, pPresentModes : Int) -> Int = "vkGetPhysicalDeviceSurfacePresentModesKHR"
