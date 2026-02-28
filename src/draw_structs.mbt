///|
/// MoonBit Vulkan SDK Bindings - Command and Draw Structs
/// Vulkan command buffer and draw operation structures

// Dispatch Indirect Command
pub struct VkDispatchIndirectCommand {
  x : Int
  y : Int
  z : Int
}

pub fn dispatch_indirect_command(x : Int, y : Int, z : Int) -> VkDispatchIndirectCommand {
  { x: x, y: y, z: z }
}

// Draw Indirect Command
pub struct VkDrawIndirectCommand {
  vertexCount : Int
  instanceCount : Int
  firstVertex : Int
  firstInstance : Int
}

pub fn draw_indirect_command(vertexCount : Int, instanceCount : Int, firstVertex : Int, firstInstance : Int) -> VkDrawIndirectCommand {
  { vertexCount: vertexCount, instanceCount: instanceCount, firstVertex: firstVertex, firstInstance: firstInstance }
}

// Draw Indexed Indirect Command
pub struct VkDrawIndexedIndirectCommand {
  indexCount : Int
  instanceCount : Int
  firstIndex : Int
  vertexOffset : Int
  firstInstance : Int
}

pub fn draw_indexed_indirect_command(indexCount : Int, instanceCount : Int, firstIndex : Int, vertexOffset : Int, firstInstance : Int) -> VkDrawIndexedIndirectCommand {
  { indexCount: indexCount, instanceCount: instanceCount, firstIndex: firstIndex, vertexOffset: vertexOffset, firstInstance: firstInstance }
}

// Draw Mesh Tasks Indirect Command NV
pub struct VkDrawMeshTasksIndirectCommandNV {
  taskCount : Int
  firstTask : Int
}

pub fn draw_mesh_tasks_indirect_command_nv(taskCount : Int, firstTask : Int) -> VkDrawMeshTasksIndirectCommandNV {
  { taskCount: taskCount, firstTask: firstTask }
}

// Draw Mesh Tasks Indirect Command EXT
pub struct VkDrawMeshTasksIndirectCommandEXT {
  groupCountX : Int
  groupCountY : Int
  groupCountZ : Int
}

pub fn draw_mesh_tasks_indirect_command_ext(groupCountX : Int, groupCountY : Int, groupCountZ : Int) -> VkDrawMeshTasksIndirectCommandEXT {
  { groupCountX: groupCountX, groupCountY: groupCountY, groupCountZ: groupCountZ }
}
