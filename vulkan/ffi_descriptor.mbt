///|
/// Vulkan Descriptor FFI Function Declarations
/// Direct bindings to Vulkan C API for descriptor management

pub extern "C" fn vkCreateDescriptorSetLayout(device : Int64, pCreateInfo : Int, pAllocator : Int, pSetLayout : Int) -> Int = "vkCreateDescriptorSetLayout"
pub extern "C" fn vkDestroyDescriptorSetLayout(device : Int64, descriptorSetLayout : Int64, pAllocator : Int) -> Unit = "vkDestroyDescriptorSetLayout"
pub extern "C" fn vkCreatePipelineLayout(device : Int64, pCreateInfo : Int, pAllocator : Int, pPipelineLayout : Int) -> Int = "vkCreatePipelineLayout"
pub extern "C" fn vkDestroyPipelineLayout(device : Int64, pipelineLayout : Int64, pAllocator : Int) -> Unit = "vkDestroyPipelineLayout"
pub extern "C" fn vkCreateDescriptorPool(device : Int64, pCreateInfo : Int, pAllocator : Int, pDescriptorPool : Int) -> Int = "vkCreateDescriptorPool"
pub extern "C" fn vkDestroyDescriptorPool(device : Int64, descriptorPool : Int64, pAllocator : Int) -> Unit = "vkDestroyDescriptorPool"
pub extern "C" fn vkResetDescriptorPool(device : Int64, descriptorPool : Int64, flags : Int) -> Int = "vkResetDescriptorPool"
pub extern "C" fn vkAllocateDescriptorSets(device : Int64, pAllocateInfo : Int, pDescriptorSets : Int) -> Int = "vkAllocateDescriptorSets"
pub extern "C" fn vkFreeDescriptorSets(device : Int64, descriptorPool : Int64, descriptorSetCount : Int, pDescriptorSets : Int) -> Int = "vkFreeDescriptorSets"
pub extern "C" fn vkUpdateDescriptorSets(device : Int64, descriptorWriteCount : Int, pDescriptorWrites : Int, descriptorCopyCount : Int, pDescriptorCopies : Int) -> Unit = "vkUpdateDescriptorSets"
