///|
/// MoonBit Vulkan SDK Bindings - Color Blend Structs
/// Vulkan color blending and dynamic state structures

// Logic Op
pub enum VkLogicOp {
  VK_LOGIC_OP_CLEAR
  VK_LOGIC_OP_AND
  VK_LOGIC_OP_AND_REVERSE
  VK_LOGIC_OP_COPY
  VK_LOGIC_OP_AND_INVERTED
  VK_LOGIC_OP_NO_OP
  VK_LOGIC_OP_XOR
  VK_LOGIC_OP_OR
  VK_LOGIC_OP_NOR
  VK_LOGIC_OP_EQUIVALENT
  VK_LOGIC_OP_INVERT
  VK_LOGIC_OP_OR_REVERSE
  VK_LOGIC_OP_COPY_INVERTED
  VK_LOGIC_OP_OR_INVERTED
  VK_LOGIC_OP_NAND
  VK_LOGIC_OP_SET
}

// Pipeline Color Blend Attachment State
pub struct VkPipelineColorBlendAttachmentState {
  blendEnable : Int
  srcColorBlendFactor : Int
  dstColorBlendFactor : Int
  colorBlendOp : Int
  srcAlphaBlendFactor : Int
  dstAlphaBlendFactor : Int
  alphaBlendOp : Int
  colorWriteMask : Int
}

pub fn pipeline_color_blend_attachment_state(
  blendEnable : Int,
  srcColorBlendFactor : Int,
  dstColorBlendFactor : Int,
  colorBlendOp : Int,
  srcAlphaBlendFactor : Int,
  dstAlphaBlendFactor : Int,
  alphaBlendOp : Int,
  colorWriteMask : Int
) -> VkPipelineColorBlendAttachmentState {
  { blendEnable: blendEnable, srcColorBlendFactor: srcColorBlendFactor, dstColorBlendFactor: dstColorBlendFactor, colorBlendOp: colorBlendOp, srcAlphaBlendFactor: srcAlphaBlendFactor, dstAlphaBlendFactor: dstAlphaBlendFactor, alphaBlendOp: alphaBlendOp, colorWriteMask: colorWriteMask }
}

// Pipeline Color Blend State Create Info
pub struct VkPipelineColorBlendStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  logicOpEnable : Int
  logicOp : Int
  attachmentCount : Int
  pAttachments : Int
  blendConstants : Array[Float]
}

pub fn pipeline_color_blend_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  logicOpEnable : Int,
  logicOp : Int,
  attachmentCount : Int,
  pAttachments : Int,
  blendConstants : Array[Float]
) -> VkPipelineColorBlendStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, logicOpEnable: logicOpEnable, logicOp: logicOp, attachmentCount: attachmentCount, pAttachments: pAttachments, blendConstants: blendConstants }
}

// Pipeline Dynamic State Create Info
pub struct VkPipelineDynamicStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  dynamicStateCount : Int
  pDynamicStates : Int
}

pub fn pipeline_dynamic_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  dynamicStateCount : Int,
  pDynamicStates : Int
) -> VkPipelineDynamicStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, dynamicStateCount: dynamicStateCount, pDynamicStates: pDynamicStates }
}
