///|
/// Vulkan Initialization Module - Phase 1
/// Basic Vulkan initialization using MoonBit bindings

// Get required GLFW instance extensions
extern "C" fn glfwGetRequiredInstanceExtensions(count : Int) -> Int = "glfwGetRequiredInstanceExtensions"

// Create GLFW window with Vulkan support
extern "C" fn glfwCreateWindow(width : Int, height : Int, title : Int, monitor : Int, share : Int) -> Int64 = "glfwCreateWindow"

// Destroy GLFW window
extern "C" fn glfwDestroyWindow(window : Int64) -> Unit = "glfwDestroyWindow"

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

pub const GLFW_FALSE : Int = 0

// Result type for initialization
pub type VulkanInitResult {
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

  let title_idx = vulkan::struct_helpers::vulkan_create_string(title)
  let window = glfwCreateWindow(width, height, title_idx, 0, 0)
  window
}

// Create Vulkan instance
pub fn create_instance(app_name : String, engine_name : String) -> VulkanInitResult {
  // Allocate application info
  let app_info_idx = vulkan::struct_helpers::alloc_application_info()
  vulkan::struct_helpers::set_application_name(app_info_idx, vulkan::struct_helpers::vulkan_create_string(app_name))
  vulkan::struct_helpers::set_application_version(app_info_idx, vulkan::constants::make_version(1, 0, 0))
  vulkan::struct_helpers::set_engine_name(app_info_idx, vulkan::struct_helpers::vulkan_create_string(engine_name))
  vulkan::struct_helpers::set_engine_version(app_info_idx, vulkan::constants::make_version(1, 0, 0))

  // Allocate instance create info
  let instance_create_info_idx = vulkan::struct_helpers::alloc_instance_create_info()
  vulkan::struct_helpers::set_instance_app_info(instance_create_info_idx, app_info_idx)

  // Allocate instance handle buffer
  let instance_buffer_idx = vulkan::struct_helpers::vulkan_alloc_struct(8)

  // Create instance (simplified - no extensions for now)
  let result = vulkan::ffi_core::vkCreateInstance(instance_create_info_idx, 0, instance_buffer_idx)

  if result != 0 {
    return VkError("Failed to create Vulkan instance: " + vulkan::core::vk_result_to_string(0))
  }

  // Read instance handle from buffer
  let instance = vulkan::struct_helpers::get_int64(instance_buffer_idx, 0)

  println("Vulkan instance created successfully")
  VkSuccess(instance)
}
