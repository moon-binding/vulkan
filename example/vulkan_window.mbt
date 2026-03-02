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

// GLFW FFI bindings (will be replaced with package imports once package structure is fixed)
extern "C" fn glfw_init() -> Int = "glfwInit"
extern "C" fn glfw_terminate() -> Unit = "glfwTerminate"
extern "C" fn glfw_window_hint(hint : Int, value : Int) -> Unit = "glfwWindowHint"
extern "C" fn glfw_create_window(width : Int, height : Int, title : Int, monitor : Int, share : Int) -> Int64 = "glfwCreateWindow"
extern "C" fn glfw_destroy_window(window : Int64) -> Unit = "glfwDestroyWindow"
extern "C" fn glfw_window_should_close(window : Int64) -> Int = "glfwWindowShouldClose"
extern "C" fn glfw_poll_events() -> Unit = "glfwPollEvents"
extern "C" fn glfw_wait_events() -> Unit = "glfwWaitEvents"

// GLFW constants
pub const GLFW_CLIENT_API : Int = 0x00022001
pub const GLFW_NO_API : Int = 0
pub const GLFW_RESIZABLE : Int = 0x00020003
pub const GLFW_TRUE : Int = 1
pub const GLFW_FALSE : Int = 0

// Initialize GLFW and create window
pub fn init_window(_title : String, width : Int, height : Int) -> WindowResult {
  println("Initializing GLFW...")

  // Initialize GLFW
  let result = glfw_init()
  if result != GLFW_TRUE {
    return WindowError("Failed to initialize GLFW")
  }

  // Set window hints for Vulkan
  glfw_window_hint(GLFW_CLIENT_API, GLFW_NO_API)
  glfw_window_hint(GLFW_RESIZABLE, GLFW_FALSE)

  // Create window
  let window = glfw_create_window(width, height, 0, 0, 0)

  if window == 0 {
    glfw_terminate()
    return WindowError("Failed to create GLFW window")
  }

  println("Window created: " + width.to_string() + "x" + height.to_string())
  WindowCreated(window)
}

// Check if window should close
pub fn window_should_close(window : WindowHandle) -> Bool {
  if window == 0 {
    return true
  }
  glfw_window_should_close(window) == GLFW_TRUE
}

// Poll for window events
pub fn poll_events() -> Unit {
  glfw_poll_events()
}

// Wait for window events
pub fn wait_events() -> Unit {
  glfw_wait_events()
}

// Cleanup window resources
pub fn cleanup_window(window : WindowHandle) -> Unit {
  if window != 0 {
    glfw_destroy_window(window)
    glfw_terminate()
    println("GLFW cleaned up")
  }
}
