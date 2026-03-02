///|
/// GLFW FFI Bindings for Vulkan
/// Direct bindings to GLFW library for window creation and event handling

// GLFW initialization
pub extern "C" fn glfw_init() -> Int = "glfwInit"
pub extern "C" fn glfw_terminate() -> Unit = "glfwTerminate"

// Window hints
pub extern "C" fn glfw_window_hint(hint : Int, value : Int) -> Unit = "glfwWindowHint"

// Window creation
pub extern "C" fn glfw_create_window(width : Int, height : Int, title : Int, monitor : Int, share : Int) -> Int64 = "glfwCreateWindow"

// Window destruction
pub extern "C" fn glfw_destroy_window(window : Int64) -> Unit = "glfwDestroyWindow"

// Event loop
pub extern "C" fn glfw_window_should_close(window : Int64) -> Int = "glfwWindowShouldClose"
pub extern "C" fn glfw_poll_events() -> Unit = "glfwPollEvents"
pub extern "C" fn glfw_wait_events() -> Unit = "glfwWaitEvents"

// Framebuffer size
pub extern "C" fn glfw_get_framebuffer_size(window : Int64, width : Int, height : Int) -> Unit = "glfwGetFramebufferSize"

// Vulkan surface
pub extern "C" fn glfw_create_window_surface(instance : Int64, window : Int64, allocator : Int, surface : Int) -> Int = "glfwCreateWindowSurface"

// GLFW constants
pub const GLFW_CLIENT_API : Int = 0x00022001
pub const GLFW_NO_API : Int = 0
pub const GLFW_RESIZABLE : Int = 0x00020003
pub const GLFW_TRUE : Int = 1
pub const GLFW_FALSE : Int = 0
