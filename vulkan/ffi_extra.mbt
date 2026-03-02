///|
/// Vulkan Extra FFI Function Declarations
/// Direct bindings to additional Vulkan C API functions

pub extern "C" fn vkCreateSampler(device : Int, pCreateInfo : Int, pAllocator : Int, pSampler : Int) -> Int = "vkCreateSampler"
pub extern "C" fn vkDestroySampler(device : Int, sampler : Int, pAllocator : Int) -> Unit = "vkDestroySampler"
pub extern "C" fn vkCreateSamplerYcbcrConversion(device : Int, pCreateInfo : Int, pAllocator : Int, pYcbcrConversion : Int) -> Int = "vkCreateSamplerYcbcrConversion"
pub extern "C" fn vkDestroySamplerYcbcrConversion(device : Int, ycbcrConversion : Int, pAllocator : Int) -> Unit = "vkDestroySamplerYcbcrConversion"
pub extern "C" fn vkCreateEvent(device : Int, pCreateInfo : Int, pAllocator : Int, pEvent : Int) -> Int = "vkCreateEvent"
pub extern "C" fn vkDestroyEvent(device : Int, event : Int, pAllocator : Int) -> Unit = "vkDestroyEvent"
pub extern "C" fn vkSetEvent(device : Int, event : Int) -> Int = "vkSetEvent"
pub extern "C" fn vkResetEvent(device : Int, event : Int) -> Int = "vkResetEvent"
pub extern "C" fn vkGetEventStatus(device : Int, event : Int) -> Int = "vkGetEventStatus"
