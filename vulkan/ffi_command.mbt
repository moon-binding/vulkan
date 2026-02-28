///|
/// Vulkan Command Buffer FFI Function Declarations
/// Direct bindings to Vulkan C API for command buffer management

pub extern "C" fn vkCreateCommandPool(device : Int, pCreateInfo : Int, pAllocator : Int, pCommandPool : Int) -> Int = "vkCreateCommandPool"
pub extern "C" fn vkDestroyCommandPool(device : Int, commandPool : Int, pAllocator : Int) -> Unit = "vkDestroyCommandPool"
pub extern "C" fn vkResetCommandPool(device : Int, commandPool : Int, flags : Int) -> Int = "vkResetCommandPool"
pub extern "C" fn vkAllocateCommandBuffers(device : Int, pAllocateInfo : Int, pCommandBuffers : Int) -> Int = "vkAllocateCommandBuffers"
pub extern "C" fn vkFreeCommandBuffers(device : Int, commandPool : Int, commandBufferCount : Int, pCommandBuffers : Int) -> Unit = "vkFreeCommandBuffers"
pub extern "C" fn vkBeginCommandBuffer(commandBuffer : Int, pBeginInfo : Int) -> Int = "vkBeginCommandBuffer"
pub extern "C" fn vkEndCommandBuffer(commandBuffer : Int) -> Int = "vkEndCommandBuffer"
pub extern "C" fn vkResetCommandBuffer(commandBuffer : Int, flags : Int) -> Int = "vkResetCommandBuffer"
