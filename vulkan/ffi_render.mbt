///|
/// Vulkan Rendering FFI Function Declarations
/// Direct bindings to Vulkan C API for rendering pipeline

pub extern "C" fn vkCreateShaderModule(device : Int64, pCreateInfo : Int, pAllocator : Int, pShaderModule : Int) -> Int = "vulkan_vkCreateShaderModule"
pub extern "C" fn vkDestroyShaderModule(device : Int64, shaderModule : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyShaderModule"

pub extern "C" fn vkCreatePipelineLayout(device : Int64, pCreateInfo : Int, pAllocator : Int, pPipelineLayout : Int) -> Int = "vulkan_vkCreatePipelineLayout"
pub extern "C" fn vkDestroyPipelineLayout(device : Int64, pipelineLayout : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyPipelineLayout"

pub extern "C" fn vkCreateRenderPass(device : Int64, pCreateInfo : Int, pAllocator : Int, pRenderPass : Int) -> Int = "vulkan_vkCreateRenderPass"
pub extern "C" fn vkDestroyRenderPass(device : Int64, renderPass : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyRenderPass"

pub extern "C" fn vkCreateGraphicsPipelines(device : Int64, pipelineCache : Int64, createInfoCount : Int, pCreateInfos : Int, pAllocator : Int, pPipelines : Int) -> Int = "vulkan_vkCreateGraphicsPipelines"
pub extern "C" fn vkDestroyPipeline(device : Int64, pipeline : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyPipeline"

pub extern "C" fn vkCreateFramebuffer(device : Int64, pCreateInfo : Int, pAllocator : Int, pFramebuffer : Int) -> Int = "vulkan_vkCreateFramebuffer"
pub extern "C" fn vkDestroyFramebuffer(device : Int64, framebuffer : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyFramebuffer"

pub extern "C" fn vkCreateCommandPool(device : Int64, pCreateInfo : Int, pAllocator : Int, pCommandPool : Int) -> Int = "vulkan_vkCreateCommandPool"
pub extern "C" fn vkDestroyCommandPool(device : Int64, commandPool : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyCommandPool"

pub extern "C" fn vkAllocateCommandBuffers(device : Int64, pAllocateInfo : Int, pCommandBuffers : Int) -> Int = "vulkan_vkAllocateCommandBuffers"
pub extern "C" fn vkFreeCommandBuffers(device : Int64, commandPool : Int64, commandBufferCount : Int, pCommandBuffers : Int) -> Unit = "vulkan_vkFreeCommandBuffers"

pub extern "C" fn vkBeginCommandBuffer(commandBuffer : Int64, pBeginInfo : Int) -> Int = "vulkan_vkBeginCommandBuffer"
pub extern "C" fn vkEndCommandBuffer(commandBuffer : Int64) -> Int = "vulkan_vkEndCommandBuffer"
pub extern "C" fn vkCmdBeginRenderPass(commandBuffer : Int64, pRenderPassBegin : Int, contents : Int) -> Unit = "vulkan_vkCmdBeginRenderPass"
pub extern "C" fn vkCmdEndRenderPass(commandBuffer : Int64) -> Unit = "vulkan_vkCmdEndRenderPass"
pub extern "C" fn vkCmdBindPipeline(commandBuffer : Int64, pipelineBindPoint : Int, pipeline : Int64) -> Unit = "vulkan_vkCmdBindPipeline"
pub extern "C" fn vkCmdDraw(commandBuffer : Int64, vertexCount : Int, instanceCount : Int, firstVertex : Int, firstInstance : Int) -> Unit = "vulkan_vkCmdDraw"

pub extern "C" fn vkCreateSemaphore(device : Int64, pCreateInfo : Int, pAllocator : Int, pSemaphore : Int) -> Int = "vulkan_vkCreateSemaphore"
pub extern "C" fn vkDestroySemaphore(device : Int64, semaphore : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroySemaphore"

pub extern "C" fn vkCreateFence(device : Int64, pCreateInfo : Int, pAllocator : Int, pFence : Int) -> Int = "vulkan_vkCreateFence"
pub extern "C" fn vkDestroyFence(device : Int64, fence : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyFence"
pub extern "C" fn vkWaitForFences(device : Int64, fenceCount : Int, pFences : Int, waitAll : Int, timeout : Int64) -> Int = "vulkan_vkWaitForFences"
pub extern "C" fn vkResetFences(device : Int64, fenceCount : Int, pFences : Int) -> Int = "vulkan_vkResetFences"

pub extern "C" fn vkQueueSubmit(queue : Int64, submitCount : Int, pSubmits : Int, fence : Int64) -> Int = "vulkan_vkQueueSubmit"

pub extern "C" fn vkCreateImageView(device : Int64, pCreateInfo : Int, pAllocator : Int, pImageView : Int) -> Int = "vulkan_vkCreateImageView"
pub extern "C" fn vkDestroyImageView(device : Int64, imageView : Int64, pAllocator : Int) -> Unit = "vulkan_vkDestroyImageView"
