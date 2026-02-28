///|
/// MoonBit Vulkan SDK Bindings - Descriptor and Shader Structs
/// Vulkan descriptor sets and shader related structures

// Descriptor Type
pub enum VkDescriptorType {
  VK_DESCRIPTOR_TYPE_SAMPLER
  VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER
  VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE
  VK_DESCRIPTOR_TYPE_STORAGE_IMAGE
  VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER
  VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER
  VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER
  VK_DESCRIPTOR_TYPE_STORAGE_BUFFER
  VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC
  VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC
  VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT
}

// Descriptor Buffer Info
pub struct VkDescriptorBufferInfo {
  buffer : Int
  offset : Int
  range : Int
}

pub fn descriptor_buffer_info(buffer : Int, offset : Int, range : Int) -> VkDescriptorBufferInfo {
  { buffer: buffer, offset: offset, range: range }
}

// Descriptor Image Info
pub struct VkDescriptorImageInfo {
  sampler : Int
  imageView : Int
  imageLayout : Int
}

pub fn descriptor_image_info(sampler : Int, imageView : Int, imageLayout : Int) -> VkDescriptorImageInfo {
  { sampler: sampler, imageView: imageView, imageLayout: imageLayout }
}

// Descriptor Pool Size
pub struct VkDescriptorPoolSize {
  descriptorType : Int
  descriptorCount : Int
}

pub fn descriptor_pool_size(descriptorType : Int, descriptorCount : Int) -> VkDescriptorPoolSize {
  { descriptorType: descriptorType, descriptorCount: descriptorCount }
}

// Descriptor Set Layout Binding
pub struct VkDescriptorSetLayoutBinding {
  binding : Int
  descriptorType : Int
  descriptorCount : Int
  stageFlags : Int
  pImmutableSamplers : Int
}

pub fn descriptor_set_layout_binding(
  binding : Int,
  descriptorType : Int,
  descriptorCount : Int,
  stageFlags : Int,
  pImmutableSamplers : Int
) -> VkDescriptorSetLayoutBinding {
  { binding: binding, descriptorType: descriptorType, descriptorCount: descriptorCount, stageFlags: stageFlags, pImmutableSamplers: pImmutableSamplers }
}

// Descriptor Set Layout Create Info
pub struct VkDescriptorSetLayoutCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  bindingCount : Int
  pBindings : Int
}

pub fn descriptor_set_layout_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  bindingCount : Int,
  pBindings : Int
) -> VkDescriptorSetLayoutCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, bindingCount: bindingCount, pBindings: pBindings }
}

// Write Descriptor Set
pub struct VkWriteDescriptorSet {
  sType : Int
  pNext : Int
  dstSet : Int
  dstBinding : Int
  dstArrayElement : Int
  descriptorCount : Int
  descriptorType : Int
  pImageInfo : Int
  pBufferInfo : Int
  pTexelBufferView : Int
}

pub fn write_descriptor_set(
  sType : Int,
  pNext : Int,
  dstSet : Int,
  dstBinding : Int,
  dstArrayElement : Int,
  descriptorCount : Int,
  descriptorType : Int,
  pImageInfo : Int,
  pBufferInfo : Int,
  pTexelBufferView : Int
) -> VkWriteDescriptorSet {
  { sType: sType, pNext: pNext, dstSet: dstSet, dstBinding: dstBinding, dstArrayElement: dstArrayElement, descriptorCount: descriptorCount, descriptorType: descriptorType, pImageInfo: pImageInfo, pBufferInfo: pBufferInfo, pTexelBufferView: pTexelBufferView }
}

// Push Constant Range
pub struct VkPushConstantRange {
  stageFlags : Int
  offset : Int
  size : Int
}

pub fn push_constant_range(stageFlags : Int, offset : Int, size : Int) -> VkPushConstantRange {
  { stageFlags: stageFlags, offset: offset, size: size }
}

// Pipeline Layout Create Info
pub struct VkPipelineLayoutCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  setLayoutCount : Int
  pSetLayouts : Int
  pushConstantRangeCount : Int
  pPushConstantRanges : Int
}

pub fn pipeline_layout_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  setLayoutCount : Int,
  pSetLayouts : Int,
  pushConstantRangeCount : Int,
  pPushConstantRanges : Int
) -> VkPipelineLayoutCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, setLayoutCount: setLayoutCount, pSetLayouts: pSetLayouts, pushConstantRangeCount: pushConstantRangeCount, pPushConstantRanges: pPushConstantRanges }
}
