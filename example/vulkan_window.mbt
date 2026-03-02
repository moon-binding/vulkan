///|
/// Vulkan Window Management using MoonBit
/// This module replaces C GLFW initialization with MoonBit bindings

// Window handle - use a mutable reference type
pub type WindowHandle = Int64

// Result type for window operations
pub enum WindowResult {
  WindowCreated(WindowHandle)
  WindowError(String)
}

// Use C bridge for window creation with proper title support
extern "C" fn vk_init_window_bridge(title : Int, width : Int, height : Int) -> Int64 = "moonbit_vk_init_window_bridge"

// Initialize GLFW and create window using C bridge
pub fn init_window(title : String, width : Int, height : Int) -> WindowResult {
  println("Initializing GLFW...")

  // Use C bridge to create window with proper title support
  // For now, we pass 0 for title pointer - in a full implementation
  // we'd convert MoonBit string to C string
  let window = vk_init_window_bridge(0, width, height)

  if window == 0 {
    return WindowError("Failed to create GLFW window")
  }

  println("Window created: " + width.to_string() + "x" + height.to_string())
  WindowCreated(window)
}

// Check if window should close
pub fn window_should_close(_window : WindowHandle) -> Bool {
  // For now, always return true to exit immediately
  // In a full implementation, this would call glfwWindowShouldClose
  false
}

// Poll for window events
pub fn poll_events() -> Unit {
  // TODO: Implement with glfw_poll_events
}

// Wait for window events
pub fn wait_events() -> Unit {
  // TODO: Implement with glfw_wait_events
}

// Cleanup window resources
pub fn cleanup_window(_window : WindowHandle) -> Unit {
  // TODO: Implement proper cleanup
  println("Window cleanup (stub)")
}
