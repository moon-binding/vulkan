///|
/// MoonBit Vulkan SDK Bindings - Basic Structs
/// Vulkan basic structure types

// 2D Extent
pub struct VkExtent2D {
  width : Int
  height : Int
}

pub fn extent_2d(width : Int, height : Int) -> VkExtent2D {
  { width: width, height: height }
}

// 3D Extent
pub struct VkExtent3D {
  width : Int
  height : Int
  depth : Int
}

pub fn extent_3d(width : Int, height : Int, depth : Int) -> VkExtent3D {
  { width: width, height: height, depth: depth }
}

// 2D Offset
pub struct VkOffset2D {
  x : Int
  y : Int
}

pub fn offset_2d(x : Int, y : Int) -> VkOffset2D {
  { x: x, y: y }
}

// 3D Offset
pub struct VkOffset3D {
  x : Int
  y : Int
  z : Int
}

pub fn offset_3d(x : Int, y : Int, z : Int) -> VkOffset3D {
  { x: x, y: y, z: z }
}

// Viewport
pub struct VkViewport {
  x : Float
  y : Float
  width : Float
  height : Float
  minDepth : Float
  maxDepth : Float
}

pub fn viewport(x : Float, y : Float, width : Float, height : Float, minDepth : Float, maxDepth : Float) -> VkViewport {
  { x: x, y: y, width: width, height: height, minDepth: minDepth, maxDepth: maxDepth }
}

// Rect2D
pub struct VkRect2D {
  offset : VkOffset2D
  extent : VkExtent2D
}

pub fn rect_2d(offset : VkOffset2D, extent : VkExtent2D) -> VkRect2D {
  { offset: offset, extent: extent }
}

// Clear color value
pub type VkClearColorValue = Array[Float]

pub fn clear_color_value(r : Float, g : Float, b : Float, a : Float) -> VkClearColorValue {
  [r, g, b, a]
}

// Clear depth stencil value
pub struct VkClearDepthStencilValue {
  depth : Float
  stencil : Int
}

pub fn clear_depth_stencil_value(depth : Float, stencil : Int) -> VkClearDepthStencilValue {
  { depth: depth, stencil: stencil }
}

// Clear value union (represented as separate types for simplicity)
pub struct VkClearValue {
  color : Array[Float]
  depthStencil : VkClearDepthStencilValue
}

pub fn clear_value_color(color : Array[Float]) -> VkClearValue {
  { color: color, depthStencil: clear_depth_stencil_value(0.0, 0) }
}

pub fn clear_value_depth_stencil(depth : Float, stencil : Int) -> VkClearValue {
  { color: [0.0, 0.0, 0.0, 0.0], depthStencil: clear_depth_stencil_value(depth, stencil) }
}
