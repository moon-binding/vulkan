///|
/// Vulkan Queue and Image View FFI Function Declarations
/// Direct bindings to Vulkan C API for queue submission and image management

extern "C" fn vkQueueSubmit(queue : Int, submitCount : Int, pSubmits : Int, fence : Int) -> Int = "vkQueueSubmit"
extern "C" fn vkQueueWaitIdle(queue : Int) -> Int = "vkQueueWaitIdle"
extern "C" fn vkCreateImageView(device : Int, pCreateInfo : Int, pAllocator : Int, pView : Int) -> Int = "vkCreateImageView"
extern "C" fn vkDestroyImageView(device : Int, imageView : Int, pAllocator : Int) -> Unit = "vkDestroyImageView"
extern "C" fn vkCreateImage(device : Int, pCreateInfo : Int, pAllocator : Int, pImage : Int) -> Int = "vkCreateImage"
extern "C" fn vkDestroyImage(device : Int, image : Int, pAllocator : Int) -> Unit = "vkDestroyImage"
extern "C" fn vkGetImageMemoryRequirements(device : Int, image : Int, pMemoryRequirements : Int) -> Unit = "vkGetImageMemoryRequirements"
extern "C" fn vkBindImageMemory(device : Int, image : Int, memory : Int, memoryOffset : Int) -> Int = "vkBindImageMemory"
