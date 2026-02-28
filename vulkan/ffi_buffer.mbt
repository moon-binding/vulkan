///|
/// Vulkan Buffer FFI Function Declarations
/// Direct bindings to Vulkan C API for buffer management

pub extern "C" fn vkCreateBuffer(device : Int, pCreateInfo : Int, pAllocator : Int, pBuffer : Int) -> Int = "vkCreateBuffer"
pub extern "C" fn vkDestroyBuffer(device : Int, buffer : Int, pAllocator : Int) -> Unit = "vkDestroyBuffer"
pub extern "C" fn vkGetBufferMemoryRequirements(device : Int, buffer : Int, pMemoryRequirements : Int) -> Unit = "vkGetBufferMemoryRequirements"
pub extern "C" fn vkBindBufferMemory(device : Int, buffer : Int, memory : Int, memoryOffset : Int) -> Int = "vkBindBufferMemory"
pub extern "C" fn vkCreateBufferView(device : Int, pCreateInfo : Int, pAllocator : Int, pView : Int) -> Int = "vkCreateBufferView"
pub extern "C" fn vkDestroyBufferView(device : Int, bufferView : Int, pAllocator : Int) -> Unit = "vkDestroyBufferView"
