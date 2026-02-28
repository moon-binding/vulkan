///|
/// Vulkan Command Buffer FFI Function Declarations
/// Direct bindings to Vulkan C API for command buffer management

extern "C" fn vkCreateCommandPool(device : Int, pCreateInfo : Int, pAllocator : Int, pCommandPool : Int) -> Int = "vkCreateCommandPool"
extern "C" fn vkDestroyCommandPool(device : Int, commandPool : Int, pAllocator : Int) -> Unit = "vkDestroyCommandPool"
extern "C" fn vkResetCommandPool(device : Int, commandPool : Int, flags : Int) -> Int = "vkResetCommandPool"
extern "C" fn vkAllocateCommandBuffers(device : Int, pAllocateInfo : Int, pCommandBuffers : Int) -> Int = "vkAllocateCommandBuffers"
extern "C" fn vkFreeCommandBuffers(device : Int, commandPool : Int, commandBufferCount : Int, pCommandBuffers : Int) -> Unit = "vkFreeCommandBuffers"
extern "C" fn vkBeginCommandBuffer(commandBuffer : Int, pBeginInfo : Int) -> Int = "vkBeginCommandBuffer"
extern "C" fn vkEndCommandBuffer(commandBuffer : Int) -> Int = "vkEndCommandBuffer"
extern "C" fn vkResetCommandBuffer(commandBuffer : Int, flags : Int) -> Int = "vkResetCommandBuffer"
