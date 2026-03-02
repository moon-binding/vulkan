///|
/// Vulkan Image Views Module - Phase 8
/// Image view creation for swapchain images

// Bridge function for MoonBit image views creation
extern "C" fn vk_create_image_views_bridge(device : Int64, swapchain : Int64, format : Int, imageCount : Int) -> Int64 = "moonbit_vk_create_image_views_bridge"

// Bridge function to destroy image views
extern "C" fn vk_destroy_image_views_bridge(device : Int64, imageViews : Int64, imageCount : Int) -> Int = "moonbit_vk_destroy_image_views_bridge"

// Result type for image views creation
pub enum ImageViewsResult {
  ImageViewsCreated(Int64, Int)  // (imageViews pointer, image count)
  ImageViewsError(String)
}

// Create image views for swapchain images using C bridge
pub fn create_image_views(device : Int64, swapchain : Int64, format : Int, image_count : Int) -> ImageViewsResult {
  println("Creating image views...")

  let result = vk_create_image_views_bridge(device, swapchain, format, image_count)

  if result == 0 {
    return ImageViewsError("Failed to create image views")
  }

  println("Image views created!")
  println("  Count: " + image_count.to_string())

  ImageViewsCreated(result, image_count)
}

// Destroy image views
pub fn destroy_image_views(device : Int64, image_views : Int64, image_count : Int) -> Unit {
  if image_views != 0 {
    let _ = vk_destroy_image_views_bridge(device, image_views, image_count)
    println("Image views destroyed")
  }
}
