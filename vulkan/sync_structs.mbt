///|
/// MoonBit Vulkan SDK Bindings - Synchronization Structs
/// Vulkan synchronization and barrier structures

// Memory Barrier
pub struct VkMemoryBarrier {
  sType : Int
  pNext : Int
  srcAccessMask : Int
  dstAccessMask : Int
}

pub fn memory_barrier(sType : Int, pNext : Int, srcAccessMask : Int, dstAccessMask : Int) -> VkMemoryBarrier {
  { sType: sType, pNext: pNext, srcAccessMask: srcAccessMask, dstAccessMask: dstAccessMask }
}

// Buffer Memory Barrier
pub struct VkBufferMemoryBarrier {
  sType : Int
  pNext : Int
  srcAccessMask : Int
  dstAccessMask : Int
  srcQueueFamilyIndex : Int
  dstQueueFamilyIndex : Int
  buffer : Int
  offset : Int
  size : Int
}

pub fn buffer_memory_barrier(
  sType : Int,
  pNext : Int,
  srcAccessMask : Int,
  dstAccessMask : Int,
  srcQueueFamilyIndex : Int,
  dstQueueFamilyIndex : Int,
  buffer : Int,
  offset : Int,
  size : Int
) -> VkBufferMemoryBarrier {
  { sType: sType, pNext: pNext, srcAccessMask: srcAccessMask, dstAccessMask: dstAccessMask, srcQueueFamilyIndex: srcQueueFamilyIndex, dstQueueFamilyIndex: dstQueueFamilyIndex, buffer: buffer, offset: offset, size: size }
}

// Image Memory Barrier
pub struct VkImageMemoryBarrier {
  sType : Int
  pNext : Int
  srcAccessMask : Int
  dstAccessMask : Int
  oldLayout : Int
  newLayout : Int
  srcQueueFamilyIndex : Int
  dstQueueFamilyIndex : Int
  image : Int
  subresourceRange : VkImageSubresourceRange
}

pub fn image_memory_barrier(
  sType : Int,
  pNext : Int,
  srcAccessMask : Int,
  dstAccessMask : Int,
  oldLayout : Int,
  newLayout : Int,
  srcQueueFamilyIndex : Int,
  dstQueueFamilyIndex : Int,
  image : Int,
  subresourceRange : VkImageSubresourceRange
) -> VkImageMemoryBarrier {
  { sType: sType, pNext: pNext, srcAccessMask: srcAccessMask, dstAccessMask: dstAccessMask, oldLayout: oldLayout, newLayout: newLayout, srcQueueFamilyIndex: srcQueueFamilyIndex, dstQueueFamilyIndex: dstQueueFamilyIndex, image: image, subresourceRange: subresourceRange }
}
