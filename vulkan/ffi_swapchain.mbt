///|
/// Vulkan Swapchain FFI Function Declarations
/// Direct bindings to Vulkan C API for swapchain management

pub extern "C" fn vkCreateSwapchainKHR(device : Int64, pCreateInfo : Int, pAllocator : Int, pSwapchain : Int) -> Int = "vulkan_vkCreateSwapchainKHR"
pub extern "C" fn vkDestroySwapchainKHR(device : Int64, swapchain : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroySwapchainKHR"
pub extern "C" fn vkGetSwapchainImagesKHR(device : Int64, swapchain : Int64, pSwapchainImageCount : Int, pSwapchainImages : Int) -> Int = "vulkan_vkGetSwapchainImagesKHR"
pub extern "C" fn vkAcquireNextImageKHR(device : Int64, swapchain : Int64, timeout : Int64, semaphore : Int64, fence : Int64, pImageIndex : Int) -> Int = "vulkan_vkAcquireNextImageKHR"
pub extern "C" fn vkQueuePresentKHR(queue : Int64, pPresentInfo : Int) -> Int = "vulkan_vkQueuePresentKHR"
