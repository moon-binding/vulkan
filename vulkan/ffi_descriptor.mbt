///|
/// Vulkan Descriptor FFI Function Declarations
/// Direct bindings to Vulkan C API for descriptor management

pub extern "C" fn vkCreateDescriptorSetLayout(device : Int, pCreateInfo : Int, pAllocator : Int, pSetLayout : Int) -> Int = "vkCreateDescriptorSetLayout"
pub extern "C" fn vkDestroyDescriptorSetLayout(device : Int, descriptorSetLayout : Int, pAllocator : Int) -> Unit = "vkDestroyDescriptorSetLayout"
pub extern "C" fn vkCreatePipelineLayout(device : Int, pCreateInfo : Int, pAllocator : Int, pPipelineLayout : Int) -> Int = "vkCreatePipelineLayout"
pub extern "C" fn vkDestroyPipelineLayout(device : Int, pipelineLayout : Int, pAllocator : Int) -> Unit = "vkDestroyPipelineLayout"
pub extern "C" fn vkCreateDescriptorPool(device : Int, pCreateInfo : Int, pAllocator : Int, pDescriptorPool : Int) -> Int = "vkCreateDescriptorPool"
pub extern "C" fn vkDestroyDescriptorPool(device : Int, descriptorPool : Int, pAllocator : Int) -> Unit = "vkDestroyDescriptorPool"
pub extern "C" fn vkResetDescriptorPool(device : Int, descriptorPool : Int, flags : Int) -> Int = "vkResetDescriptorPool"
pub extern "C" fn vkAllocateDescriptorSets(device : Int, pAllocateInfo : Int, pDescriptorSets : Int) -> Int = "vkAllocateDescriptorSets"
pub extern "C" fn vkFreeDescriptorSets(device : Int, descriptorPool : Int, descriptorSetCount : Int, pDescriptorSets : Int) -> Int = "vkFreeDescriptorSets"
pub extern "C" fn vkUpdateDescriptorSets(device : Int, descriptorWriteCount : Int, pDescriptorWrites : Int, descriptorCopyCount : Int, pDescriptorCopies : Int) -> Unit = "vkUpdateDescriptorSets"
