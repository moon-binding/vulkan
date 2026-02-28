///|
/// Vulkan Synchronization FFI Function Declarations
/// Direct bindings to Vulkan C API for synchronization objects

pub extern "C" fn vkCreateSemaphore(device : Int, pCreateInfo : Int, pAllocator : Int, pSemaphore : Int) -> Int = "vkCreateSemaphore"
pub extern "C" fn vkDestroySemaphore(device : Int, semaphore : Int, pAllocator : Int) -> Unit = "vkDestroySemaphore"
pub extern "C" fn vkCreateFence(device : Int, pCreateInfo : Int, pAllocator : Int, pFence : Int) -> Int = "vkCreateFence"
pub extern "C" fn vkDestroyFence(device : Int, fence : Int, pAllocator : Int) -> Unit = "vkDestroyFence"
pub extern "C" fn vkWaitForFences(device : Int, fenceCount : Int, pFences : Int, waitAll : Int, timeout : Int) -> Int = "vkWaitForFences"
pub extern "C" fn vkResetFences(device : Int, fenceCount : Int, pFences : Int) -> Int = "vkResetFences"
