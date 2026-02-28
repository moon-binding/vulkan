///|
/// MoonBit Vulkan SDK Bindings - Render Pass and Framebuffer Structs
/// Vulkan render pass and framebuffer related structures

// Pipeline Bind Point
pub enum VkPipelineBindPoint {
  VK_PIPELINE_BIND_POINT_GRAPHICS
  VK_PIPELINE_BIND_POINT_COMPUTE
}

// Attachment Reference
pub struct VkAttachmentReference {
  attachment : Int
  layout : Int
}

pub fn attachment_reference(attachment : Int, layout : Int) -> VkAttachmentReference {
  { attachment: attachment, layout: layout }
}

// Attachment Description
pub struct VkAttachmentDescription {
  flags : Int
  format : Int
  samples : Int
  loadOp : Int
  storeOp : Int
  stencilLoadOp : Int
  stencilStoreOp : Int
  initialLayout : Int
  finalLayout : Int
}

pub fn attachment_description(
  flags : Int,
  format : Int,
  samples : Int,
  loadOp : Int,
  storeOp : Int,
  stencilLoadOp : Int,
  stencilStoreOp : Int,
  initialLayout : Int,
  finalLayout : Int
) -> VkAttachmentDescription {
  { flags: flags, format: format, samples: samples, loadOp: loadOp, storeOp: storeOp, stencilLoadOp: stencilLoadOp, stencilStoreOp: stencilStoreOp, initialLayout: initialLayout, finalLayout: finalLayout }
}

// Subpass Description
pub struct VkSubpassDescription {
  flags : Int
  pipelineBindPoint : Int
  inputAttachmentCount : Int
  pInputAttachments : Int
  colorAttachmentCount : Int
  pColorAttachments : Int
  pResolveAttachments : Int
  pDepthStencilAttachment : Int
  preserveAttachmentCount : Int
  pPreserveAttachments : Int
}

pub fn subpass_description(
  flags : Int,
  pipelineBindPoint : Int,
  inputAttachmentCount : Int,
  pInputAttachments : Int,
  colorAttachmentCount : Int,
  pColorAttachments : Int,
  pResolveAttachments : Int,
  pDepthStencilAttachment : Int,
  preserveAttachmentCount : Int,
  pPreserveAttachments : Int
) -> VkSubpassDescription {
  { flags: flags, pipelineBindPoint: pipelineBindPoint, inputAttachmentCount: inputAttachmentCount, pInputAttachments: pInputAttachments, colorAttachmentCount: colorAttachmentCount, pColorAttachments: pColorAttachments, pResolveAttachments: pResolveAttachments, pDepthStencilAttachment: pDepthStencilAttachment, preserveAttachmentCount: preserveAttachmentCount, pPreserveAttachments: pPreserveAttachments }
}

// Render Pass Create Info
pub struct VkRenderPassCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  attachmentCount : Int
  pAttachments : Int
  subpassCount : Int
  pSubpasses : Int
  dependencyCount : Int
  pDependencies : Int
}

pub fn render_pass_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  attachmentCount : Int,
  pAttachments : Int,
  subpassCount : Int,
  pSubpasses : Int,
  dependencyCount : Int,
  pDependencies : Int
) -> VkRenderPassCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, attachmentCount: attachmentCount, pAttachments: pAttachments, subpassCount: subpassCount, pSubpasses: pSubpasses, dependencyCount: dependencyCount, pDependencies: pDependencies }
}

// Render Pass Begin Info
pub struct VkRenderPassBeginInfo {
  sType : Int
  pNext : Int
  renderPass : Int
  framebuffer : Int
  renderArea : VkRect2D
  clearValueCount : Int
  pClearValues : Int
}

pub fn render_pass_begin_info(
  sType : Int,
  pNext : Int,
  renderPass : Int,
  framebuffer : Int,
  renderArea : VkRect2D,
  clearValueCount : Int,
  pClearValues : Int
) -> VkRenderPassBeginInfo {
  { sType: sType, pNext: pNext, renderPass: renderPass, framebuffer: framebuffer, renderArea: renderArea, clearValueCount: clearValueCount, pClearValues: pClearValues }
}

// Framebuffer Create Info
pub struct VkFramebufferCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  renderPass : Int
  attachmentCount : Int
  pAttachments : Int
  width : Int
  height : Int
  layers : Int
}

pub fn framebuffer_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  renderPass : Int,
  attachmentCount : Int,
  pAttachments : Int,
  width : Int,
  height : Int,
  layers : Int
) -> VkFramebufferCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, renderPass: renderPass, attachmentCount: attachmentCount, pAttachments: pAttachments, width: width, height: height, layers: layers }
}
