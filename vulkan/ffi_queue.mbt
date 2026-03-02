///|
/// Vulkan Queue and Image View FFI Function Declarations
/// Direct bindings to Vulkan C API for queue submission and image management

pub extern "C" fn vkQueueSubmit(queue : Int64, submitCount : Int, pSubmits : Int, fence : Int64) -> Int = "vkQueueSubmit"
pub extern "C" fn vkQueueWaitIdle(queue : Int64) -> Int = "vkQueueWaitIdle"
pub extern "C" fn vkCreateImageView(device : Int64, pCreateInfo : Int, pAllocator : Int, pView : Int) -> Int = "vkCreateImageView"
pub extern "C" fn vkDestroyImageView(device : Int64, imageView : Int64, pAllocator : Int) -> Unit = "vkDestroyImageView"
pub extern "C" fn vkCreateImage(device : Int64, pCreateInfo : Int, pAllocator : Int, pImage : Int) -> Int = "vkCreateImage"
pub extern "C" fn vkDestroyImage(device : Int64, image : Int64, pAllocator : Int) -> Unit = "vkDestroyImage"
pub extern "C" fn vkGetImageMemoryRequirements(device : Int64, image : Int64, pMemoryRequirements : Int) -> Unit = "vkGetImageMemoryRequirements"
pub extern "C" fn vkBindImageMemory(device : Int64, image : Int64, memory : Int64, memoryOffset : Int) -> Int = "vkBindImageMemory"
