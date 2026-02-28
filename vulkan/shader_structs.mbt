///|
/// MoonBit Vulkan SDK Bindings - Shader and Pipeline Structs
/// Vulkan shader module and pipeline creation structures

// Shader Module Create Info
pub struct VkShaderModuleCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  codeSize : Int
  pCode : Int
}

pub fn shader_module_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  codeSize : Int,
  pCode : Int
) -> VkShaderModuleCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, codeSize: codeSize, pCode: pCode }
}

// Pipeline Shader Stage Create Info
pub struct VkPipelineShaderStageCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  stage : Int
  module : Int
  pName : Int
  pSpecializationInfo : Int
}

pub fn pipeline_shader_stage_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  stage : Int,
  module : Int,
  pName : Int,
  pSpecializationInfo : Int
) -> VkPipelineShaderStageCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, stage: stage, module: module, pName: pName, pSpecializationInfo: pSpecializationInfo }
}

// Compute Pipeline Create Info
pub struct VkComputePipelineCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  stage : VkPipelineShaderStageCreateInfo
  layout : Int
  basePipelineHandle : Int
  basePipelineIndex : Int
}

pub fn compute_pipeline_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  stage : VkPipelineShaderStageCreateInfo,
  layout : Int,
  basePipelineHandle : Int,
  basePipelineIndex : Int
) -> VkComputePipelineCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, stage: stage, layout: layout, basePipelineHandle: basePipelineHandle, basePipelineIndex: basePipelineIndex }
}

// Graphics Pipeline Create Info
pub struct VkGraphicsPipelineCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  stageCount : Int
  pStages : Int
  pVertexInputState : Int
  pInputAssemblyState : Int
  pTessellationState : Int
  pViewportState : Int
  pRasterizationState : Int
  pMultisampleState : Int
  pDepthStencilState : Int
  pColorBlendState : Int
  pDynamicState : Int
  layout : Int
  renderPass : Int
  subpass : Int
  basePipelineHandle : Int
  basePipelineIndex : Int
}

pub fn graphics_pipeline_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  stageCount : Int,
  pStages : Int,
  pVertexInputState : Int,
  pInputAssemblyState : Int,
  pTessellationState : Int,
  pViewportState : Int,
  pRasterizationState : Int,
  pMultisampleState : Int,
  pDepthStencilState : Int,
  pColorBlendState : Int,
  pDynamicState : Int,
  layout : Int,
  renderPass : Int,
  subpass : Int,
  basePipelineHandle : Int,
  basePipelineIndex : Int
) -> VkGraphicsPipelineCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, stageCount: stageCount, pStages: pStages, pVertexInputState: pVertexInputState, pInputAssemblyState: pInputAssemblyState, pTessellationState: pTessellationState, pViewportState: pViewportState, pRasterizationState: pRasterizationState, pMultisampleState: pMultisampleState, pDepthStencilState: pDepthStencilState, pColorBlendState: pColorBlendState, pDynamicState: pDynamicState, layout: layout, renderPass: renderPass, subpass: subpass, basePipelineHandle: basePipelineHandle, basePipelineIndex: basePipelineIndex }
}
