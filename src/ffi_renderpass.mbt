///|
/// Vulkan Render Pass FFI Function Declarations
/// Direct bindings to Vulkan C API for render pass and framebuffer management

extern "C" fn vkCreateRenderPass(device : Int, pCreateInfo : Int, pAllocator : Int, pRenderPass : Int) -> Int = "vkCreateRenderPass"
extern "C" fn vkDestroyRenderPass(device : Int, renderPass : Int, pAllocator : Int) -> Unit = "vkDestroyRenderPass"
extern "C" fn vkCreateFramebuffer(device : Int, pCreateInfo : Int, pAllocator : Int, pFramebuffer : Int) -> Int = "vkCreateFramebuffer"
extern "C" fn vkDestroyFramebuffer(device : Int, framebuffer : Int, pAllocator : Int) -> Unit = "vkDestroyFramebuffer"
