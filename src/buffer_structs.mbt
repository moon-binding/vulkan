///|
/// MoonBit Vulkan SDK Bindings - Buffer and Image Structs
/// Vulkan buffer, image and resource structures

// Buffer Create Info
pub struct VkBufferCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  size : Int
  usage : Int
  sharingMode : Int
  queueFamilyIndexCount : Int
  pQueueFamilyIndices : Int
}

pub fn buffer_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  size : Int,
  usage : Int,
  sharingMode : Int,
  queueFamilyIndexCount : Int,
  pQueueFamilyIndices : Int
) -> VkBufferCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, size: size, usage: usage, sharingMode: sharingMode, queueFamilyIndexCount: queueFamilyIndexCount, pQueueFamilyIndices: pQueueFamilyIndices }
}

// Image Create Info
pub struct VkImageCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  imageType : Int
  format : Int
  extent : VkExtent3D
  mipLevels : Int
  arrayLayers : Int
  samples : Int
  tiling : Int
  usage : Int
  sharingMode : Int
  queueFamilyIndexCount : Int
  pQueueFamilyIndices : Int
  initialLayout : Int
}

pub fn image_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  imageType : Int,
  format : Int,
  extent : VkExtent3D,
  mipLevels : Int,
  arrayLayers : Int,
  samples : Int,
  tiling : Int,
  usage : Int,
  sharingMode : Int,
  queueFamilyIndexCount : Int,
  pQueueFamilyIndices : Int,
  initialLayout : Int
) -> VkImageCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, imageType: imageType, format: format, extent: extent, mipLevels: mipLevels, arrayLayers: arrayLayers, samples: samples, tiling: tiling, usage: usage, sharingMode: sharingMode, queueFamilyIndexCount: queueFamilyIndexCount, pQueueFamilyIndices: pQueueFamilyIndices, initialLayout: initialLayout }
}

// Image View Create Info
pub struct VkImageViewCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  image : Int
  viewType : Int
  format : Int
  components : VkComponentMapping
  subresourceRange : VkImageSubresourceRange
}

pub fn image_view_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  image : Int,
  viewType : Int,
  format : Int,
  components : VkComponentMapping,
  subresourceRange : VkImageSubresourceRange
) -> VkImageViewCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, image: image, viewType: viewType, format: format, components: components, subresourceRange: subresourceRange }
}

// Buffer Image Copy
pub struct VkBufferImageCopy {
  bufferOffset : Int
  bufferRowLength : Int
  bufferImageHeight : Int
  imageSubresource : VkImageSubresourceLayers
  imageOffset : VkOffset3D
  imageExtent : VkExtent3D
}

pub fn buffer_image_copy(
  bufferOffset : Int,
  bufferRowLength : Int,
  bufferImageHeight : Int,
  imageSubresource : VkImageSubresourceLayers,
  imageOffset : VkOffset3D,
  imageExtent : VkExtent3D
) -> VkBufferImageCopy {
  { bufferOffset: bufferOffset, bufferRowLength: bufferRowLength, bufferImageHeight: bufferImageHeight, imageSubresource: imageSubresource, imageOffset: imageOffset, imageExtent: imageExtent }
}
