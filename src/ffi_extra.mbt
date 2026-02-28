///|
/// Vulkan Extra FFI Function Declarations
/// Direct bindings to additional Vulkan C API functions

extern "C" fn vkCreateSampler(device : Int, pCreateInfo : Int, pAllocator : Int, pSampler : Int) -> Int = "vkCreateSampler"
extern "C" fn vkDestroySampler(device : Int, sampler : Int, pAllocator : Int) -> Unit = "vkDestroySampler"
extern "C" fn vkCreateSamplerYcbcrConversion(device : Int, pCreateInfo : Int, pAllocator : Int, pYcbcrConversion : Int) -> Int = "vkCreateSamplerYcbcrConversion"
extern "C" fn vkDestroySamplerYcbcrConversion(device : Int, ycbcrConversion : Int, pAllocator : Int) -> Unit = "vkDestroySamplerYcbcrConversion"
extern "C" fn vkCreateImageViewCreateInfo(device : Int, pCreateInfo : Int, pAllocator : Int, pView : Int) -> Int = "vkCreateImageView"
extern "C" fn vkCreateEvent(device : Int, pCreateInfo : Int, pAllocator : Int, pEvent : Int) -> Int = "vkCreateEvent"
extern "C" fn vkDestroyEvent(device : Int, event : Int, pAllocator : Int) -> Unit = "vkDestroyEvent"
extern "C" fn vkSetEvent(device : Int, event : Int) -> Int = "vkSetEvent"
extern "C" fn vkResetEvent(device : Int, event : Int) -> Int = "vkResetEvent"
extern "C" fn vkGetEventStatus(device : Int, event : Int) -> Int = "vkGetEventStatus"
