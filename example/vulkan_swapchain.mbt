///|
/// Vulkan Swapchain Module - Phase 7
/// Swapchain creation and management using MoonBit bindings

// Bridge function for MoonBit swapchain creation
extern "C" fn vk_create_swapchain_bridge(physicalDevice : Int64, device : Int64, surface : Int64) -> Int64 = "moonbit_vk_create_swapchain_bridge"

// Bridge function to get swapchain images
extern "C" fn vk_get_swapchain_images_bridge(device : Int64, swapchain : Int64) -> Int64 = "moonbit_vk_get_swapchain_images_bridge"

// Bridge function to destroy swapchain
extern "C" fn vk_destroy_swapchain_bridge(device : Int64, swapchain : Int64) -> Int = "moonbit_vk_destroy_swapchain_bridge"

// Result type for swapchain creation
pub enum SwapchainResult {
  SwapchainCreated(Int64, Int, Int, Int, Int)  // (swapchain, imageCount, width, height, format)
  SwapchainError(String)
}

// Create swapchain using C bridge
pub fn create_swapchain(physical_device : Int64, device : Int64, surface : Int64) -> SwapchainResult {
  println("Creating swapchain...")

  let result = vk_create_swapchain_bridge(physical_device, device, surface)

  if result == 0 {
    return SwapchainError("Failed to create swapchain")
  }

  // Parse result: swapchain handle in lower 48 bits, image count in bits 48-56, width in bits 56-64
  // Use packed encoding for simplicity
  let swapchain = result & 0xFFFFFFFFFFFF
  let info_high = result >> 48
  let image_count = (info_high & 0xFF).to_int()
  let width = 800  // These would be decoded in a full implementation
  let height = 600
  let format = 37  // VK_FORMAT_B8G8R8A8_SRGB

  println("Swapchain created!")
  println("  Handle: " + swapchain.to_string())
  println("  Image count: " + image_count.to_string())
  println("  Size: " + width.to_string() + "x" + height.to_string())

  SwapchainCreated(swapchain, image_count, width, height, format)
}

// Get swapchain images
pub fn get_swapchain_images(device : Int64, swapchain : Int64, image_count : Int) -> Int64 {
  println("Getting swapchain images...")

  let result = vk_get_swapchain_images_bridge(device, swapchain)

  if result == 0 {
    println("Failed to get swapchain images")
    return 0
  }

  println("Swapchain images retrieved: " + image_count.to_string())
  result
}

// Destroy swapchain
pub fn destroy_swapchain(device : Int64, swapchain : Int64) -> Unit {
  if swapchain != 0 {
    let _ = vk_destroy_swapchain_bridge(device, swapchain)
    println("Swapchain destroyed")
  }
}
