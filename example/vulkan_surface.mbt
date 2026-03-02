///|
/// Vulkan Surface Creation using MoonBit
/// This module replaces C surface creation with MoonBit bindings

// Note: Surface creation requires GLFW functions that are already linked
// We'll use a C bridge function for now to simplify the implementation
extern "C" fn vk_create_surface_bridge(instance : Int64, window : Int64) -> Int64 = "moonbit_vk_create_surface_bridge"

// Result type for surface creation
pub enum SurfaceResult {
  SurfaceCreated(Int64)
  SurfaceError(String)
}

// Create Vulkan surface from window using C bridge
pub fn create_surface(instance : Int64, window : Int64) -> SurfaceResult {
  println("Creating Vulkan surface...")

  // Call C bridge function
  let surface = vk_create_surface_bridge(instance, window)

  // Check if surface creation succeeded
  if surface == 0 {
    return SurfaceError("Failed to create window surface")
  }

  println("Vulkan surface created successfully!")
  println("Surface handle: " + surface.to_string())

  SurfaceCreated(surface)
}

// Note: Surface destruction is handled by the C bridge's cleanup function

