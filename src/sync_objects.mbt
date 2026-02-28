///|
/// MoonBit Vulkan SDK Bindings - Sync Objects
/// Vulkan synchronization objects: semaphores, fences

// Semaphore Create Info
pub struct VkSemaphoreCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
}

pub fn semaphore_create_info(sType : Int, pNext : Int, flags : Int) -> VkSemaphoreCreateInfo {
  { sType: sType, pNext: pNext, flags: flags }
}

// Fence Create Info
pub struct VkFenceCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
}

pub fn fence_create_info(sType : Int, pNext : Int, flags : Int) -> VkFenceCreateInfo {
  { sType: sType, pNext: pNext, flags: flags }
}

// Fence Create Flags
pub const VK_FENCE_CREATE_SIGNALED_BIT : Int = 0x00000001

// Submit Info
pub struct VkSubmitInfo {
  sType : Int
  pNext : Int
  waitSemaphoreCount : Int
  pWaitSemaphores : Int
  pWaitDstStageMask : Int
  commandBufferCount : Int
  pCommandBuffers : Int
  signalSemaphoreCount : Int
  pSignalSemaphores : Int
}

pub fn submit_info(
  sType : Int,
  pNext : Int,
  waitSemaphoreCount : Int,
  pWaitSemaphores : Int,
  pWaitDstStageMask : Int,
  commandBufferCount : Int,
  pCommandBuffers : Int,
  signalSemaphoreCount : Int,
  pSignalSemaphores : Int
) -> VkSubmitInfo {
  { sType: sType, pNext: pNext, waitSemaphoreCount: waitSemaphoreCount, pWaitSemaphores: pWaitSemaphores, pWaitDstStageMask: pWaitDstStageMask, commandBufferCount: commandBufferCount, pCommandBuffers: pCommandBuffers, signalSemaphoreCount: signalSemaphoreCount, pSignalSemaphores: pSignalSemaphores }
}
