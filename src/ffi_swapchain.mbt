///|
/// Vulkan Swapchain FFI Function Declarations
/// Direct bindings to Vulkan C API for swapchain management

extern "C" fn vkCreateSwapchainKHR(device : Int, pCreateInfo : Int, pAllocator : Int, pSwapchain : Int) -> Int = "vkCreateSwapchainKHR"
extern "C" fn vkDestroySwapchainKHR(device : Int, swapchain : Int, pAllocator : Int) -> Unit = "vkDestroySwapchainKHR"
extern "C" fn vkGetSwapchainImagesKHR(device : Int, swapchain : Int, pSwapchainImageCount : Int, pSwapchainImages : Int) -> Int = "vkGetSwapchainImagesKHR"
extern "C" fn vkAcquireNextImageKHR(device : Int, swapchain : Int, timeout : Int, semaphore : Int, fence : Int, pImageIndex : Int) -> Int = "vkAcquireNextImageKHR"
extern "C" fn vkQueuePresentKHR(queue : Int, pPresentInfo : Int) -> Int = "vkQueuePresentKHR"
