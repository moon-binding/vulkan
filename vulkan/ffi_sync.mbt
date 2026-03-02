///|
/// Vulkan Synchronization FFI Function Declarations
/// Direct bindings to Vulkan C API for synchronization objects

pub extern "C" fn vkCreateSemaphore(device : Int64, pCreateInfo : Int, pAllocator : Int, pSemaphore : Int) -> Int = "vkCreateSemaphore"
pub extern "C" fn vkDestroySemaphore(device : Int64, semaphore : Int64, pAllocator : Int) -> Unit = "vkDestroySemaphore"
pub extern "C" fn vkCreateFence(device : Int64, pCreateInfo : Int, pAllocator : Int, pFence : Int) -> Int = "vkCreateFence"
pub extern "C" fn vkDestroyFence(device : Int64, fence : Int64, pAllocator : Int) -> Unit = "vkDestroyFence"
pub extern "C" fn vkWaitForFences(device : Int64, fenceCount : Int, pFences : Int, waitAll : Int, timeout : Int64) -> Int = "vkWaitForFences"
pub extern "C" fn vkResetFences(device : Int64, fenceCount : Int, pFences : Int) -> Int = "vkResetFences"
