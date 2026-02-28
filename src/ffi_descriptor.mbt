///|
/// Vulkan Descriptor FFI Function Declarations
/// Direct bindings to Vulkan C API for descriptor management

extern "C" fn vkCreateDescriptorSetLayout(device : Int, pCreateInfo : Int, pAllocator : Int, pSetLayout : Int) -> Int = "vkCreateDescriptorSetLayout"
extern "C" fn vkDestroyDescriptorSetLayout(device : Int, descriptorSetLayout : Int, pAllocator : Int) -> Unit = "vkDestroyDescriptorSetLayout"
extern "C" fn vkCreatePipelineLayout(device : Int, pCreateInfo : Int, pAllocator : Int, pPipelineLayout : Int) -> Int = "vkCreatePipelineLayout"
extern "C" fn vkDestroyPipelineLayout(device : Int, pipelineLayout : Int, pAllocator : Int) -> Unit = "vkDestroyPipelineLayout"
extern "C" fn vkCreateDescriptorPool(device : Int, pCreateInfo : Int, pAllocator : Int, pDescriptorPool : Int) -> Int = "vkCreateDescriptorPool"
extern "C" fn vkDestroyDescriptorPool(device : Int, descriptorPool : Int, pAllocator : Int) -> Unit = "vkDestroyDescriptorPool"
extern "C" fn vkResetDescriptorPool(device : Int, descriptorPool : Int, flags : Int) -> Int = "vkResetDescriptorPool"
extern "C" fn vkAllocateDescriptorSets(device : Int, pAllocateInfo : Int, pDescriptorSets : Int) -> Int = "vkAllocateDescriptorSets"
extern "C" fn vkFreeDescriptorSets(device : Int, descriptorPool : Int, descriptorSetCount : Int, pDescriptorSets : Int) -> Int = "vkFreeDescriptorSets"
extern "C" fn vkUpdateDescriptorSets(device : Int, descriptorWriteCount : Int, pDescriptorWrites : Int, descriptorCopyCount : Int, pDescriptorCopies : Int) -> Unit = "vkUpdateDescriptorSets"
