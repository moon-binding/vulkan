///|
/// Vulkan Queue and Image View FFI Function Declarations
/// Direct bindings to Vulkan C API for queue submission and image management

pub extern "C" fn vkQueueSubmit(queue : Int, submitCount : Int, pSubmits : Int, fence : Int) -> Int = "vkQueueSubmit"
pub extern "C" fn vkQueueWaitIdle(queue : Int) -> Int = "vkQueueWaitIdle"
pub extern "C" fn vkCreateImageView(device : Int, pCreateInfo : Int, pAllocator : Int, pView : Int) -> Int = "vkCreateImageView"
pub extern "C" fn vkDestroyImageView(device : Int, imageView : Int, pAllocator : Int) -> Unit = "vkDestroyImageView"
pub extern "C" fn vkCreateImage(device : Int, pCreateInfo : Int, pAllocator : Int, pImage : Int) -> Int = "vkCreateImage"
pub extern "C" fn vkDestroyImage(device : Int, image : Int, pAllocator : Int) -> Unit = "vkDestroyImage"
pub extern "C" fn vkGetImageMemoryRequirements(device : Int, image : Int, pMemoryRequirements : Int) -> Unit = "vkGetImageMemoryRequirements"
pub extern "C" fn vkBindImageMemory(device : Int, image : Int, memory : Int, memoryOffset : Int) -> Int = "vkBindImageMemory"
