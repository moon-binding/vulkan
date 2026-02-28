///|
/// MoonBit Vulkan SDK Bindings - Basic Structs
/// Vulkan basic structure types

// 2D Extent
pub struct VkExtent2D {
  width : UInt32
  height : UInt32
}

pub fn VkExtent2D_make(width : UInt32, height : UInt32) -> VkExtent2D {
  { width: width, height: height }
}

// 3D Extent
pub struct VkExtent3D {
  width : UInt32
  height : UInt32
  depth : UInt32
}

pub fn VkExtent3D_make(width : UInt32, height : UInt32, depth : UInt32) -> VkExtent3D {
  { width: width, height: height, depth: depth }
}

// 2D Offset
pub struct VkOffset2D {
  x : Int32
  y : Int32
}

pub fn VkOffset2D_make(x : Int32, y : Int32) -> VkOffset2D {
  { x: x, y: y }
}

// 3D Offset
pub struct VkOffset3D {
  x : Int32
  y : Int32
  z : Int32
}

pub fn VkOffset3D_make(x : Int32, y : Int32, z : Int32) -> VkOffset3D {
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

pub fn VkViewport_make(x : Float, y : Float, width : Float, height : Float, minDepth : Float, maxDepth : Float) -> VkViewport {
  { x: x, y: y, width: width, height: height, minDepth: minDepth, maxDepth: maxDepth }
}

// Rect2D
pub struct VkRect2D {
  offset : VkOffset2D
  extent : VkExtent2D
}

pub fn VkRect2D_make(offset : VkOffset2D, extent : VkExtent2D) -> VkRect2D {
  { offset: offset, extent: extent }
}

// Clear color value
pub type VkClearColorValue = Array[Float]

pub fn VkClearColorValue_make(r : Float, g : Float, b : Float, a : Float) -> VkClearColorValue {
  [r, g, b, a]
}

// Clear depth stencil value
pub struct VkClearDepthStencilValue {
  depth : Float
  stencil : UInt32
}

pub fn VkClearDepthStencilValue_make(depth : Float, stencil : UInt32) -> VkClearDepthStencilValue {
  { depth: depth, stencil: stencil }
}

// Clear value union (represented as separate types for simplicity)
pub struct VkClearValue {
  color : Array[Float]
  depthStencil : VkClearDepthStencilValue
}

pub fn VkClearValue_color(color : Array[Float]) -> VkClearValue {
  { color: color, depthStencil: VkClearDepthStencilValue_make(0.0, 0) }
}

pub fn VkClearValue_depthStencil(depth : Float, stencil : UInt32) -> VkClearValue {
  { color: [0.0, 0.0, 0.0, 0.0], depthStencil: VkClearDepthStencilValue_make(depth, stencil) }
}
