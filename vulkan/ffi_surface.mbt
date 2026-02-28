///|
/// Vulkan Surface FFI Function Declarations
/// Direct bindings to Vulkan C API for surface management

pub extern "C" fn vkCreateSurfaceKHR(instance : Int, pCreateInfo : Int, pAllocator : Int, pSurface : Int) -> Int = "vkCreateSurfaceKHR"
pub extern "C" fn vkDestroySurfaceKHR(instance : Int, surface : Int, pAllocator : Int) -> Unit = "vkDestroySurfaceKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice : Int, queueFamilyIndex : Int, surface : Int, pSupported : Int) -> Int = "vkGetPhysicalDeviceSurfaceSupportKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice : Int, surface : Int, pSurfaceCapabilities : Int) -> Int = "vkGetPhysicalDeviceSurfaceCapabilitiesKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice : Int, surface : Int, pSurfaceFormatCount : Int, pSurfaceFormats : Int) -> Int = "vkGetPhysicalDeviceSurfaceFormatsKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice : Int, surface : Int, pPresentModeCount : Int, pPresentModes : Int) -> Int = "vkGetPhysicalDeviceSurfacePresentModesKHR"
