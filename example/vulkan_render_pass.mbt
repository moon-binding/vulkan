///|
/// Vulkan Render Pass Module - Phase 9
/// Render pass creation for rendering operations

// Bridge function for MoonBit render pass creation
extern "C" fn vk_create_render_pass_bridge(device : Int64, format : Int) -> Int64 = "moonbit_vk_create_render_pass_bridge"

// Bridge function to destroy render pass
extern "C" fn vk_destroy_render_pass_bridge(device : Int64, renderPass : Int64) -> Int = "moonbit_vk_destroy_render_pass_bridge"

// Result type for render pass creation
pub enum RenderPassResult {
  RenderPassCreated(Int64)  // Render pass handle
  RenderPassError(String)
}

// Create render pass using C bridge
pub fn create_render_pass(device : Int64, format : Int) -> RenderPassResult {
  println("Creating render pass...")

  let result = vk_create_render_pass_bridge(device, format)

  if result == 0 {
    return RenderPassError("Failed to create render pass")
  }

  println("Render pass created! Handle: " + result.to_string())
  RenderPassCreated(result)
}

// Destroy render pass
pub fn destroy_render_pass(device : Int64, render_pass : Int64) -> Unit {
  if render_pass != 0 {
    let _ = vk_destroy_render_pass_bridge(device, render_pass)
    println("Render pass destroyed")
  }
}
