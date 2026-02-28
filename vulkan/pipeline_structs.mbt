///|
/// MoonBit Vulkan SDK Bindings - Pipeline Structs
/// Vulkan pipeline and vertex input structures

// Vertex Input Rate
pub enum VkVertexInputRate {
  VK_VERTEX_INPUT_RATE_VERTEX
  VK_VERTEX_INPUT_RATE_INSTANCE
}

// Vertex Input Binding Description
pub struct VkVertexInputBindingDescription {
  binding : Int
  stride : Int
  inputRate : Int
}

pub fn vertex_input_binding_description(binding : Int, stride : Int, inputRate : Int) -> VkVertexInputBindingDescription {
  { binding: binding, stride: stride, inputRate: inputRate }
}

// Vertex Input Attribute Description
pub struct VkVertexInputAttributeDescription {
  location : Int
  binding : Int
  format : Int
  offset : Int
}

pub fn vertex_input_attribute_description(location : Int, binding : Int, format : Int, offset : Int) -> VkVertexInputAttributeDescription {
  { location: location, binding: binding, format: format, offset: offset }
}

// Primitive Topology
pub enum VkPrimitiveTopology {
  VK_PRIMITIVE_TOPOLOGY_POINT_LIST
  VK_PRIMITIVE_TOPOLOGY_LINE_LIST
  VK_PRIMITIVE_TOPOLOGY_LINE_STRIP
  VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST
  VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP
  VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN
  VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY
  VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY
  VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY
  VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY
  VK_PRIMITIVE_TOPOLOGY_PATCH_LIST
}

// Pipeline Vertex Input State Create Info
pub struct VkPipelineVertexInputStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  vertexBindingDescriptionCount : Int
  pVertexBindingDescriptions : Int
  vertexAttributeDescriptionCount : Int
  pVertexAttributeDescriptions : Int
}

pub fn pipeline_vertex_input_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  vertexBindingDescriptionCount : Int,
  pVertexBindingDescriptions : Int,
  vertexAttributeDescriptionCount : Int,
  pVertexAttributeDescriptions : Int
) -> VkPipelineVertexInputStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, vertexBindingDescriptionCount: vertexBindingDescriptionCount, pVertexBindingDescriptions: pVertexBindingDescriptions, vertexAttributeDescriptionCount: vertexAttributeDescriptionCount, pVertexAttributeDescriptions: pVertexAttributeDescriptions }
}

// Pipeline Input Assembly State Create Info
pub struct VkPipelineInputAssemblyStateCreateInfo {
  sType : Int
  pNext : Int
  flags : Int
  topology : Int
  primitiveRestartEnable : Int
}

pub fn pipeline_input_assembly_state_create_info(
  sType : Int,
  pNext : Int,
  flags : Int,
  topology : Int,
  primitiveRestartEnable : Int
) -> VkPipelineInputAssemblyStateCreateInfo {
  { sType: sType, pNext: pNext, flags: flags, topology: topology, primitiveRestartEnable: primitiveRestartEnable }
}
