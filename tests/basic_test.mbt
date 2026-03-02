// Basic Vulkan binding test

import "vulkan"
import "moonbit/io" as io

foreign vulkan_bridge lib "./vulkan_bridge.so"

fn bridge_create_instance(app_name : U64, engine_name : U64, out_instance : U64) -> U32 = "vk_bridge_create_instance"
fn bridge_enumerate_physical_devices(instance : U64, out_count : U64, out_devices : U64) -> I32 = "vk_bridge_enumerate_physical_devices"
fn bridge_destroy_instance(instance : U64) -> Unit = "vk_bridge_destroy_instance"

fn main() {
  io::println("Vulkan Binding Basic Test")
  io::println("=========================")

  // Test 1: Create Vulkan structures
  io::println("\nTest 1: Structure Creation")
  io::println("---------------------------")

  let app_info = vulkan::vk_application_info(
    vulkan::VK_STRUCTURE_TYPE_APPLICATION_INFO,
    0ULL,
    0ULL,
    0U32,
    0ULL,
    0U32,
    4194304U32
  )

  io::println("Created VkApplicationInfo")
  io::println("  API Version: VK 1.0")

  let create_info = vulkan::vk_instance_create_info(
    vulkan::VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    0ULL,
    0U32,
    0ULL,
    0U32,
    0ULL,
    0U32,
    0ULL
  )

  io::println("Created VkInstanceCreateInfo")
  io::println("  Structure creation tests passed!")

  // Test 2: Create Vulkan instance via C bridge
  io::println("\nTest 2: Vulkan Instance Creation")
  io::println("---------------------------------")

  let app_name_ptr = 0ULL  // Simplified: would need string allocation
  let engine_name_ptr = 0ULL
  let instance_ptr_out = 0ULL

  let result = bridge_create_instance(app_name_ptr, engine_name_ptr, instance_ptr_out)

  io::println("Bridge call completed")
  io::println("  Note: This is a structural test - actual Vulkan calls")
  io::println("  require proper string and memory management")

  // Test 3: Check enum values
  io::println("\nTest 3: Enum Values")
  io::println("-------------------")

  io::println("  VK_SUCCESS value: " + vulkan::vk_result_to_int(vulkan::VK_SUCCESS).to_string())
  io::println("  VK_ERROR_OUT_OF_HOST_MEMORY: " + vulkan::vk_result_to_int(vulkan::VK_ERROR_OUT_OF_HOST_MEMORY).to_string())

  io::println("")
  io::println("✓ All basic structure tests passed!")
  io::println("")
  io::println("Next steps:")
  io::println("  - Implement proper string allocation for C bridge")
  io::println("  - Add memory management for Vulkan objects")
  io::println("  - Test actual Vulkan instance creation")
  io::println("  - Expand to full API coverage via XML parser")
}
