///|
/// Vulkan Command Buffer FFI Function Declarations
/// Direct bindings to Vulkan C API for command buffer management

pub extern "C" fn vkCreateCommandPool(device : Int64, pCreateInfo : Int, pAllocator : Int, pCommandPool : Int) -> Int = "vkCreateCommandPool"
pub extern "C" fn vkDestroyCommandPool(device : Int64, commandPool : Int64, pAllocator : Int) -> Unit = "vkDestroyCommandPool"
pub extern "C" fn vkResetCommandPool(device : Int64, commandPool : Int64, flags : Int) -> Int = "vkResetCommandPool"
pub extern "C" fn vkAllocateCommandBuffers(device : Int64, pAllocateInfo : Int, pCommandBuffers : Int) -> Int = "vkAllocateCommandBuffers"
pub extern "C" fn vkFreeCommandBuffers(device : Int64, commandPool : Int64, commandBufferCount : Int, pCommandBuffers : Int) -> Unit = "vkFreeCommandBuffers"
pub extern "C" fn vkBeginCommandBuffer(commandBuffer : Int64, pBeginInfo : Int) -> Int = "vkBeginCommandBuffer"
pub extern "C" fn vkEndCommandBuffer(commandBuffer : Int64) -> Int = "vkEndCommandBuffer"
pub extern "C" fn vkResetCommandBuffer(commandBuffer : Int64, flags : Int) -> Int = "vkResetCommandBuffer"
