///|
/// Vulkan Initialization Module - Phase 1
/// Basic Vulkan initialization using MoonBit bindings

// C FFI functions for GLFW
extern "C" fn glfwInit() -> Int = "glfwInit"
extern "C" fn glfwTerminate() -> Unit = "glfwTerminate"
extern "C" fn glfwWindowHint(hint : Int, value : Int) -> Unit = "glfwWindowHint"
extern "C" fn glfwCreateWindow(width : Int, height : Int, title : Int, monitor : Int, share : Int) -> Int64 = "glfwCreateWindow"

// Constants
pub const GLFW_CLIENT_API : Int = 0x00022001
pub const GLFW_NO_API : Int = 0
pub const GLFW_RESIZABLE : Int = 0x00020003
pub const GLFW_TRUE : Int = 1
pub const GLFW_FALSE : Int = 0

// Initialize GLFW
pub fn init_glfw() -> Bool {
  let result = glfwInit()
  result == GLFW_TRUE
}

// Terminate GLFW
pub fn terminate_glfw() -> Unit {
  glfwTerminate()
}

// Create GLFW window
pub fn create_glfw_window(width : Int, height : Int) -> Int64 {
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)
  glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE)
  glfwCreateWindow(width, height, 0, 0, 0)
}
