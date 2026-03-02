///|
/// Vulkan Graphics Pipeline and Framebuffers Module - Phase 10 & 11
/// Graphics pipeline and framebuffer creation

// Bridge function for MoonBit graphics pipeline creation
extern "C" fn vk_create_graphics_pipeline_bridge(device : Int64, renderPass : Int64, extentWidth : Int, extentHeight : Int) -> Int64 = "moonbit_vk_create_graphics_pipeline_bridge"

// Bridge function to destroy graphics pipeline
extern "C" fn vk_destroy_graphics_pipeline_bridge(device : Int64, pipeline : Int64, pipelineLayout : Int64) -> Int = "moonbit_vk_destroy_graphics_pipeline_bridge"

// Bridge function for MoonBit framebuffers creation
extern "C" fn vk_create_framebuffers_bridge(device : Int64, renderPass : Int64, imageViews : Int64, imageCount : Int, width : Int, height : Int) -> Int64 = "moonbit_vk_create_framebuffers_bridge"

// Bridge function to destroy framebuffers
extern "C" fn vk_destroy_framebuffers_bridge(device : Int64, framebuffers : Int64, imageCount : Int) -> Int = "moonbit_vk_destroy_framebuffers_bridge"

// Result type for graphics pipeline creation
pub enum GraphicsPipelineResult {
  GraphicsPipelineCreated(Int64, Int64)  // (pipeline, pipelineLayout)
  GraphicsPipelineError(String)
}

// Result type for framebuffers creation
pub enum FramebuffersResult {
  FramebuffersCreated(Int64, Int)  // (framebuffers pointer, count)
  FramebuffersError(String)
}

// Create graphics pipeline using C bridge
pub fn create_graphics_pipeline(device : Int64, render_pass : Int64, width : Int, height : Int) -> GraphicsPipelineResult {
  println("Creating graphics pipeline...")

  let result = vk_create_graphics_pipeline_bridge(device, render_pass, width, height)

  if result == 0 {
    return GraphicsPipelineError("Failed to create graphics pipeline")
  }

  // Parse result: pipeline handle in lower 48 bits, pipeline layout in upper 16 bits
  let pipeline = result & 0xFFFFFFFFFFFF
  let pipeline_layout = result >> 48

  println("Graphics pipeline created! Handle: " + pipeline.to_string())
  GraphicsPipelineCreated(pipeline, pipeline_layout)
}

// Destroy graphics pipeline
pub fn destroy_graphics_pipeline(device : Int64, pipeline : Int64, pipeline_layout : Int64) -> Unit {
  if pipeline != 0 {
    let _ = vk_destroy_graphics_pipeline_bridge(device, pipeline, pipeline_layout)
    println("Graphics pipeline destroyed")
  }
}

// Create framebuffers using C bridge
pub fn create_framebuffers(device : Int64, render_pass : Int64, image_views : Int64, image_count : Int, width : Int, height : Int) -> FramebuffersResult {
  println("Creating framebuffers...")

  let result = vk_create_framebuffers_bridge(device, render_pass, image_views, image_count, width, height)

  if result == 0 {
    return FramebuffersError("Failed to create framebuffers")
  }

  println("Framebuffers created! Count: " + image_count.to_string())
  FramebuffersCreated(result, image_count)
}

// Destroy framebuffers
pub fn destroy_framebuffers(device : Int64, framebuffers : Int64, image_count : Int) -> Unit {
  if framebuffers != 0 {
    let _ = vk_destroy_framebuffers_bridge(device, framebuffers, image_count)
    println("Framebuffers destroyed")
  }
}
