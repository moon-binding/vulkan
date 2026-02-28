///|
/// Vulkan Memory FFI Function Declarations
/// Direct bindings to Vulkan C API for memory management

pub extern "C" fn vkAllocateMemory(device : Int, pAllocateInfo : Int, pAllocator : Int, pMemory : Int) -> Int = "vkAllocateMemory"
pub extern "C" fn vkFreeMemory(device : Int, memory : Int, pAllocator : Int) -> Unit = "vkFreeMemory"
pub extern "C" fn vkMapMemory(device : Int, memory : Int, offset : Int, size : Int, flags : Int, ppData : Int) -> Int = "vkMapMemory"
pub extern "C" fn vkUnmapMemory(device : Int, memory : Int) -> Unit = "vkUnmapMemory"
pub extern "C" fn vkFlushMappedMemoryRanges(device : Int, memoryRangeCount : Int, pMemoryRanges : Int) -> Int = "vkFlushMappedMemoryRanges"
pub extern "C" fn vkInvalidateMappedMemoryRanges(device : Int, memoryRangeCount : Int, pMemoryRanges : Int) -> Int = "vkInvalidateMappedMemoryRanges"
