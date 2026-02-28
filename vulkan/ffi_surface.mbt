///|
/// Vulkan Surface FFI Function Declarations
/// Direct bindings to Vulkan C API for surface management

pub extern "C" fn vkCreateSurfaceKHR(instance : Int64, pCreateInfo : Int, pAllocator : Int, pSurface : Int) -> Int = "vulkan_vkCreateSurfaceKHR"
pub extern "C" fn vkDestroySurfaceKHR(instance : Int64, surface : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroySurfaceKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice : Int64, queueFamilyIndex : Int, surface : Int64, pSupported : Int) -> Int = "vulkan_vkGetPhysicalDeviceSurfaceSupportKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfaceSupportKHRArray(devices : Int, deviceIndex : Int, queueFamilyIndex : Int, surface : Int64, pSupported : Int) -> Int = "vulkan_vkGetPhysicalDeviceSurfaceSupportKHRArray"
pub extern "C" fn vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice : Int64, surface : Int64, pSurfaceCapabilities : Int) -> Int = "vulkan_vkGetPhysicalDeviceSurfaceCapabilitiesKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice : Int64, surface : Int64, pSurfaceFormatCount : Int, pSurfaceFormats : Int) -> Int = "vulkan_vkGetPhysicalDeviceSurfaceFormatsKHR"
pub extern "C" fn vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice : Int64, surface : Int64, pPresentModeCount : Int, pPresentModes : Int) -> Int = "vulkan_vkGetPhysicalDeviceSurfacePresentModesKHR"
