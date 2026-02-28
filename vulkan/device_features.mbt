///|
/// MoonBit Vulkan SDK Bindings - Device Features
/// Vulkan physical device features structure

// Physical Device Features
pub struct VkPhysicalDeviceFeatures {
  robustBufferAccess : Int
  fullDrawIndexUint32 : Int
  imageCubeArray : Int
  independentBlend : Int
  geometryShader : Int
  tessellationShader : Int
  sampleRateShading : Int
  dualSrcBlend : Int
  logicOp : Int
  multiDrawIndirect : Int
  drawIndirectFirstInstance : Int
  depthClamp : Int
  depthBiasClamp : Int
  fillModeNonSolid : Int
  depthBounds : Int
  wideLines : Int
  largePoints : Int
  alphaToOne : Int
  multiViewport : Int
  samplerAnisotropy : Int
  textureCompressionETC2 : Int
  textureCompressionASTC_LDR : Int
  textureCompressionBC : Int
  occlusionQueryPrecise : Int
  pipelineStatisticsQuery : Int
  vertexPipelineStoresAndAtomics : Int
  fragmentStoresAndAtomics : Int
  shaderTessellationAndGeometryPointSize : Int
  shaderImageGatherExtended : Int
  shaderStorageImageExtendedFormats : Int
  shaderStorageImageReadWithoutFormat : Int
  shaderStorageImageWriteWithoutFormat : Int
  shaderUniformBufferArrayDynamicIndexing : Int
  shaderSampledImageArrayDynamicIndexing : Int
  shaderStorageBufferArrayDynamicIndexing : Int
  shaderStorageImageArrayDynamicIndexing : Int
  shaderClipDistance : Int
  shaderCullDistance : Int
  shaderFloat64 : Int
  shaderInt64 : Int
  shaderInt64Atomics : Int
  shaderInt16 : Int
  shaderResourceResidency : Int
  shaderResourceMinLod : Int
  sparseBinding : Int
  sparseResidencyBuffer : Int
  sparseResidencyImage2D : Int
  sparseResidencyImage3D : Int
  sparseResidency2Samples : Int
  sparseResidency4Samples : Int
  sparseResidency8Samples : Int
  sparseResidency16Samples : Int
  sparseResidencyAliased : Int
  variableMultisampleRate : Int
  inheritedQueries : Int
}
