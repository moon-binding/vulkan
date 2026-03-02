///|
/// Vulkan Initialization Module - Phase 1
/// Basic Vulkan initialization using MoonBit bindings

// Create GLFW window with Vulkan support
extern "C" fn glfwCreateWindow(width : Int, height : Int, title : Int, monitor : Int, share : Int) -> Int64 = "glfwCreateWindow"

// Initialize GLFW
extern "C" fn glfwInit() -> Int = "glfwInit"

// Terminate GLFW
extern "C" fn glfwTerminate() -> Unit = "glfwTerminate"

// Window hints
extern "C" fn glfwWindowHint(hint : Int, value : Int) -> Unit = "glfwWindowHint"

pub const GLFW_CLIENT_API : Int = 0x00022001
pub const GLFW_NO_API : Int = 0
pub const GLFW_RESIZABLE : Int = 0x00020003

pub const GLFW_TRUE : Int = 1
pub const GLFW_FALSE : Int = 0

// Result type for initialization
pub enum VulkanInitResult {
  VkSuccess(Int64)  // Instance handle
  VkError(String)
}

// Initialize GLFW
pub fn init_glfw() -> Bool {
  let result = glfwInit()
  result == GLFW_TRUE
}

// Terminate GLFW
pub fn terminate_glfw() -> Unit {
  glfwTerminate()
}

// Create window
pub fn create_window(width : Int, height : Int, title : String) -> Int64 {
  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)
  glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE)

  // For now, create window without title string conversion
  let window = glfwCreateWindow(width, height, 0, 0, 0)
  window
}

// Create Vulkan instance
pub fn create_instance(app_name : String, engine_name : String) -> VulkanInitResult {
  println("Creating Vulkan instance...")
  println("App name: " + app_name)
  println("Engine name: " + engine_name)

  // For now, just return success
  VkSuccess(0)
}
