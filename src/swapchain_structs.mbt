///|
/// MoonBit Vulkan SDK Bindings - Swapchain Structs
/// Vulkan swapchain and presentation structures

// Present Mode KHR
pub enum VkPresentModeKHR {
  VK_PRESENT_MODE_IMMEDIATE_KHR
  VK_PRESENT_MODE_MAILBOX_KHR
  VK_PRESENT_MODE_FIFO_KHR
  VK_PRESENT_MODE_FIFO_RELAXED_KHR
  VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR
  VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR
  VK_PRESENT_MODE_FIFO_LATEST_READY_KHR
}

// Color Space KHR
pub enum VkColorSpaceKHR {
  VK_COLOR_SPACE_SRGB_NONLINEAR_KHR
}

// Swapchain Create Info KHR
pub struct VkSwapchainCreateInfoKHR {
  sType : Int
  pNext : Int
  flags : Int
  surface : Int
  minImageCount : Int
  imageFormat : Int
  imageColorSpace : Int
  imageExtent : VkExtent2D
  imageArrayLayers : Int
  imageUsage : Int
  imageSharingMode : Int
  queueFamilyIndexCount : Int
  pQueueFamilyIndices : Int
  preTransform : Int
  compositeAlpha : Int
  presentMode : Int
  clipped : Int
  oldSwapchain : Int
}

pub fn swapchain_create_info_khr(
  sType : Int,
  pNext : Int,
  flags : Int,
  surface : Int,
  minImageCount : Int,
  imageFormat : Int,
  imageColorSpace : Int,
  imageExtent : VkExtent2D,
  imageArrayLayers : Int,
  imageUsage : Int,
  imageSharingMode : Int,
  queueFamilyIndexCount : Int,
  pQueueFamilyIndices : Int,
  preTransform : Int,
  compositeAlpha : Int,
  presentMode : Int,
  clipped : Int,
  oldSwapchain : Int
) -> VkSwapchainCreateInfoKHR {
  { sType: sType, pNext: pNext, flags: flags, surface: surface, minImageCount: minImageCount, imageFormat: imageFormat, imageColorSpace: imageColorSpace, imageExtent: imageExtent, imageArrayLayers: imageArrayLayers, imageUsage: imageUsage, imageSharingMode: imageSharingMode, queueFamilyIndexCount: queueFamilyIndexCount, pQueueFamilyIndices: pQueueFamilyIndices, preTransform: preTransform, compositeAlpha: compositeAlpha, presentMode: presentMode, clipped: clipped, oldSwapchain: oldSwapchain }
}

// Present Info KHR
pub struct VkPresentInfoKHR {
  sType : Int
  pNext : Int
  waitSemaphoreCount : Int
  pWaitSemaphores : Int
  swapchainCount : Int
  pSwapchains : Int
  pImageIndices : Int
  pResults : Int
}

pub fn present_info_khr(
  sType : Int,
  pNext : Int,
  waitSemaphoreCount : Int,
  pWaitSemaphores : Int,
  swapchainCount : Int,
  pSwapchains : Int,
  pImageIndices : Int,
  pResults : Int
) -> VkPresentInfoKHR {
  { sType: sType, pNext: pNext, waitSemaphoreCount: waitSemaphoreCount, pWaitSemaphores: pWaitSemaphores, swapchainCount: swapchainCount, pSwapchains: pSwapchains, pImageIndices: pImageIndices, pResults: pResults }
}
