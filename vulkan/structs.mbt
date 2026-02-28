///|
/// MoonBit Vulkan SDK Bindings - Basic Structs
/// Vulkan basic structure types

// Component Swizzle constants (VkComponentSwizzle enum values)
pub const VK_COMPONENT_SWIZZLE_IDENTITY : Int = 0
pub const VK_COMPONENT_SWIZZLE_ZERO : Int = 1
pub const VK_COMPONENT_SWIZZLE_ONE : Int = 2
pub const VK_COMPONENT_SWIZZLE_R : Int = 3
pub const VK_COMPONENT_SWIZZLE_G : Int = 4
pub const VK_COMPONENT_SWIZZLE_B : Int = 5
pub const VK_COMPONENT_SWIZZLE_A : Int = 6

// Component Mapping
pub struct VkComponentMapping {
  r : Int
  g : Int
  b : Int
  a : Int
}

pub fn component_mapping(r : Int, g : Int, b : Int, a : Int) -> VkComponentMapping {
  { r: r, g: g, b: b, a: a }
}

// Image Subresource
pub struct VkImageSubresource {
  aspectMask : Int
  mipLevel : Int
  arrayLayer : Int
}

pub fn image_subresource(aspectMask : Int, mipLevel : Int, arrayLayer : Int) -> VkImageSubresource {
  { aspectMask: aspectMask, mipLevel: mipLevel, arrayLayer: arrayLayer }
}

// Image Subresource Range
pub struct VkImageSubresourceRange {
  aspectMask : Int
  baseMipLevel : Int
  levelCount : Int
  baseArrayLayer : Int
  layerCount : Int
}

pub fn image_subresource_range(aspectMask : Int, baseMipLevel : Int, levelCount : Int, baseArrayLayer : Int, layerCount : Int) -> VkImageSubresourceRange {
  { aspectMask: aspectMask, baseMipLevel: baseMipLevel, levelCount: levelCount, baseArrayLayer: baseArrayLayer, layerCount: layerCount }
}

// Image Subresource Layers
pub struct VkImageSubresourceLayers {
  aspectMask : Int
  mipLevel : Int
  baseArrayLayer : Int
  layerCount : Int
}

pub fn image_subresource_layers(aspectMask : Int, mipLevel : Int, baseArrayLayer : Int, layerCount : Int) -> VkImageSubresourceLayers {
  { aspectMask: aspectMask, mipLevel: mipLevel, baseArrayLayer: baseArrayLayer, layerCount: layerCount }
}

// Rect Layer KHR
pub struct VkRectLayerKHR {
  offset : VkOffset2D
  extent : VkExtent2D
  layer : Int
}

pub fn rect_layer_khr(offset : VkOffset2D, extent : VkExtent2D, layer : Int) -> VkRectLayerKHR {
  { offset: offset, extent: extent, layer: layer }
}

// Clear Attachment
pub struct VkClearAttachment {
  aspectMask : Int
  colorAttachment : Int
  clearValue : VkClearValue
}

pub fn clear_attachment(aspectMask : Int, colorAttachment : Int, clearValue : VkClearValue) -> VkClearAttachment {
  { aspectMask: aspectMask, colorAttachment: colorAttachment, clearValue: clearValue }
}

// Clear Rect
pub struct VkClearRect {
  rect : VkRect2D
  baseArrayLayer : Int
  layerCount : Int
}

pub fn clear_rect(rect : VkRect2D, baseArrayLayer : Int, layerCount : Int) -> VkClearRect {
  { rect: rect, baseArrayLayer: baseArrayLayer, layerCount: layerCount }
}

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
