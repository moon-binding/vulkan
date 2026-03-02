///|
/// Vulkan Render Pass FFI Function Declarations
/// Direct bindings to Vulkan C API for render pass and framebuffer management

pub extern "C" fn vkCreateRenderPass(device : Int64, pCreateInfo : Int, pAllocator : Int, pRenderPass : Int) -> Int = "vkCreateRenderPass"
pub extern "C" fn vkDestroyRenderPass(device : Int64, renderPass : Int64, pAllocator : Int) -> Unit = "vkDestroyRenderPass"
pub extern "C" fn vkCreateFramebuffer(device : Int64, pCreateInfo : Int, pAllocator : Int, pFramebuffer : Int) -> Int = "vkCreateFramebuffer"
pub extern "C" fn vkDestroyFramebuffer(device : Int64, framebuffer : Int64, pAllocator : Int) -> Unit = "vkDestroyFramebuffer"
