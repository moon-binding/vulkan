///|
/// MoonBit Vulkan SDK Bindings - Pipeline State Structs
/// Vulkan pipeline state creation structures

// Pipeline Viewport State Create Info
pub struct VkPipelineViewportStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  viewportCount : Int
  pViewports : Int
  scissorCount : Int
  pScissors : Int
}

pub fn pipeline_viewport_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  viewportCount : Int,
  pViewports : Int,
  scissorCount : Int,
  pScissors : Int
) -> VkPipelineViewportStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, viewportCount: viewportCount, pViewports: pViewports, scissorCount: scissorCount, pScissors: pScissors }
}

// Pipeline Rasterization State Create Info
pub struct VkPipelineRasterizationStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  depthClampEnable : Int
  rasterizerDiscardEnable : Int
  polygonMode : Int
  cullMode : Int
  frontFace : Int
  depthBiasEnable : Int
  depthBiasConstantFactor : Float
  depthBiasClamp : Float
  depthBiasSlopeFactor : Float
  lineWidth : Float
}

pub fn pipeline_rasterization_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  depthClampEnable : Int,
  rasterizerDiscardEnable : Int,
  polygonMode : Int,
  cullMode : Int,
  frontFace : Int,
  depthBiasEnable : Int,
  depthBiasConstantFactor : Float,
  depthBiasClamp : Float,
  depthBiasSlopeFactor : Float,
  lineWidth : Float
) -> VkPipelineRasterizationStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, depthClampEnable: depthClampEnable, rasterizerDiscardEnable: rasterizerDiscardEnable, polygonMode: polygonMode, cullMode: cullMode, frontFace: frontFace, depthBiasEnable: depthBiasEnable, depthBiasConstantFactor: depthBiasConstantFactor, depthBiasClamp: depthBiasClamp, depthBiasSlopeFactor: depthBiasSlopeFactor, lineWidth: lineWidth }
}

// Pipeline Multisample State Create Info
pub struct VkPipelineMultisampleStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  rasterizationSamples : Int
  sampleShadingEnable : Int
  minSampleShading : Float
  pSampleMask : Int
  alphaToCoverageEnable : Int
  alphaToOneEnable : Int
}

pub fn pipeline_multisample_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  rasterizationSamples : Int,
  sampleShadingEnable : Int,
  minSampleShading : Float,
  pSampleMask : Int,
  alphaToCoverageEnable : Int,
  alphaToOneEnable : Int
) -> VkPipelineMultisampleStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, rasterizationSamples: rasterizationSamples, sampleShadingEnable: sampleShadingEnable, minSampleShading: minSampleShading, pSampleMask: pSampleMask, alphaToCoverageEnable: alphaToCoverageEnable, alphaToOneEnable: alphaToOneEnable }
}

// Pipeline Depth Stencil State Create Info
pub struct VkPipelineDepthStencilStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  depthTestEnable : Int
  depthWriteEnable : Int
  depthCompareOp : Int
  depthBoundsTestEnable : Int
  stencilTestEnable : Int
  front : VkStencilOpState
  back : VkStencilOpState
  minDepthBounds : Float
  maxDepthBounds : Float
}

pub fn pipeline_depth_stencil_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  depthTestEnable : Int,
  depthWriteEnable : Int,
  depthCompareOp : Int,
  depthBoundsTestEnable : Int,
  stencilTestEnable : Int,
  front : VkStencilOpState,
  back : VkStencilOpState,
  minDepthBounds : Float,
  maxDepthBounds : Float
) -> VkPipelineDepthStencilStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, depthTestEnable: depthTestEnable, depthWriteEnable: depthWriteEnable, depthCompareOp: depthCompareOp, depthBoundsTestEnable: depthBoundsTestEnable, stencilTestEnable: stencilTestEnable, front: front, back: back, minDepthBounds: minDepthBounds, maxDepthBounds: maxDepthBounds }
}

// Stencil Op State
pub struct VkStencilOpState {
  failOp : Int
  passOp : Int
  depthFailOp : Int
  compareOp : Int
  compareMask : Int
  writeMask : Int
  reference : Int
}

pub fn stencil_op_state(
  failOp : Int,
  passOp : Int,
  depthFailOp : Int,
  compareOp : Int,
  compareMask : Int,
  writeMask : Int,
  reference : Int
) -> VkStencilOpState {
  { failOp: failOp, passOp: passOp, depthFailOp: depthFailOp, compareOp: compareOp, compareMask: compareMask, writeMask: writeMask, reference: reference }
}
