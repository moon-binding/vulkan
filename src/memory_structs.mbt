///|
/// MoonBit Vulkan SDK Bindings - Memory and Command Buffer Structs
/// Vulkan memory allocation and command buffer structures

// Memory Requirements
pub struct VkMemoryRequirements {
  size : Int
  alignment : Int
  memoryTypeBits : Int
}

// Memory Allocate Info
pub struct VkMemoryAllocateInfo {
  sType : Int
  pNext : Int
  allocationSize : Int
  memoryTypeIndex : Int
}

pub fn memory_allocate_info(
  sType : Int,
  pNext : Int,
  allocationSize : Int,
  memoryTypeIndex : Int
) -> VkMemoryAllocateInfo {
  { sType: sType, pNext: pNext, allocationSize: allocationSize, memoryTypeIndex: memoryTypeIndex }
}

// Command Pool Create Info
pub struct VkCommandPoolCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  queueFamilyIndex : Int
}

pub fn command_pool_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  queueFamilyIndex : Int
) -> VkCommandPoolCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, queueFamilyIndex: queueFamilyIndex }
}

// Command Buffer Allocate Info
pub struct VkCommandBufferAllocateInfo {
  sType : Int
  pNext : Int
  commandPool : Int
  level : Int
  commandBufferCount : Int
}

pub fn command_buffer_allocate_info(
  sType : Int,
  pNext : Int,
  commandPool : Int,
  level : Int,
  commandBufferCount : Int
) -> VkCommandBufferAllocateInfo {
  { sType: sType, pNext: pNext, commandPool: commandPool, level: level, commandBufferCount: commandBufferCount }
}

// Command Buffer Begin Info
pub struct VkCommandBufferBeginInfo {
  sType : Int
  pNext : Int
  flags : Int
  pInheritanceInfo : Int
}

pub fn command_buffer_begin_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  pInheritanceInfo : Int
) -> VkCommandBufferBeginInfo {
  { sType: sType, pNext: pNext, flags: flags, pInheritanceInfo: pInheritanceInfo }
}

// Buffer Copy
pub struct VkBufferCopy {
  srcOffset : Int
  dstOffset : Int
  size : Int
}

pub fn buffer_copy(srcOffset : Int, dstOffset : Int, size : Int) -> VkBufferCopy {
  { srcOffset: srcOffset, dstOffset: dstOffset, size: size }
}

// Image Copy
pub struct VkImageCopy {
  srcSubresource : VkImageSubresourceLayers
  srcOffset : VkOffset3D
  dstSubresource : VkImageSubresourceLayers
  dstOffset : VkOffset3D
  extent : VkExtent3D
}

pub fn image_copy(
  srcSubresource : VkImageSubresourceLayers,
  srcOffset : VkOffset3D,
  dstSubresource : VkImageSubresourceLayers,
  dstOffset : VkOffset3D,
  extent : VkExtent3D
) -> VkImageCopy {
  { srcSubresource: srcSubresource, srcOffset: srcOffset, dstSubresource: dstSubresource, dstOffset: dstOffset, extent: extent }
}

// Image Blit
pub struct VkImageBlit {
  srcSubresource : VkImageSubresourceLayers
  srcOffsets : Array[VkOffset3D]
  dstSubresource : VkImageSubresourceLayers
  dstOffsets : Array[VkOffset3D]
}

pub fn image_blit(
  srcSubresource : VkImageSubresourceLayers,
  srcOffsets : Array[VkOffset3D],
  dstSubresource : VkImageSubresourceLayers,
  dstOffsets : Array[VkOffset3D]
) -> VkImageBlit {
  { srcSubresource: srcSubresource, srcOffsets: srcOffsets, dstSubresource: dstSubresource, dstOffsets: dstOffsets }
}
