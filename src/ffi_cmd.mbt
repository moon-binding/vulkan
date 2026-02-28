///|
/// Vulkan Command Recording FFI Function Declarations
/// Direct bindings to Vulkan C API for command buffer recording

extern "C" fn vkCmdBeginRenderPass(commandBuffer : Int, pRenderPassBegin : Int, contents : Int) -> Unit = "vkCmdBeginRenderPass"
extern "C" fn vkCmdEndRenderPass(commandBuffer : Int) -> Unit = "vkCmdEndRenderPass"
extern "C" fn vkCmdBindPipeline(commandBuffer : Int, pipelineBindPoint : Int, pipeline : Int) -> Unit = "vkCmdBindPipeline"
extern "C" fn vkCmdBindVertexBuffers(commandBuffer : Int, firstBinding : Int, bindingCount : Int, pBuffers : Int, pOffsets : Int) -> Unit = "vkCmdBindVertexBuffers"
extern "C" fn vkCmdDraw(commandBuffer : Int, vertexCount : Int, instanceCount : Int, firstVertex : Int, firstInstance : Int) -> Unit = "vkCmdDraw"
extern "C" fn vkCmdDrawIndexed(commandBuffer : Int, indexCount : Int, instanceCount : Int, firstIndex : Int, vertexOffset : Int, firstInstance : Int) -> Unit = "vkCmdDrawIndexed"
extern "C" fn vkCmdSetViewport(commandBuffer : Int, firstViewport : Int, viewportCount : Int, pViewports : Int) -> Unit = "vkCmdSetViewport"
extern "C" fn vkCmdSetScissor(commandBuffer : Int, firstScissor : Int, scissorCount : Int, pScissors : Int) -> Unit = "vkCmdSetScissor"
extern "C" fn vkCmdCopyBuffer(commandBuffer : Int, srcBuffer : Int, dstBuffer : Int, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyBuffer"
extern "C" fn vkCmdCopyImage(commandBuffer : Int, srcImage : Int, srcImageLayout : Int, dstImage : Int, dstImageLayout : Int, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyImage"
extern "C" fn vkCmdCopyBufferToImage(commandBuffer : Int, srcBuffer : Int, dstImage : Int, dstImageLayout : Int, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyBufferToImage"
extern "C" fn vkCmdCopyImageToBuffer(commandBuffer : Int, srcImage : Int, srcImageLayout : Int, dstBuffer : Int, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyImageToBuffer"
extern "C" fn vkCmdPipelineBarrier(commandBuffer : Int, srcStageMask : Int, dstStageMask : Int, dependencyFlags : Int, memoryBarrierCount : Int, pMemoryBarriers : Int, bufferMemoryBarrierCount : Int, pBufferMemoryBarriers : Int, imageMemoryBarrierCount : Int, pImageMemoryBarriers : Int) -> Unit = "vkCmdPipelineBarrier"
extern "C" fn vkCmdBindDescriptorSets(commandBuffer : Int, pipelineBindPoint : Int, layout : Int, firstSet : Int, descriptorSetCount : Int, pDescriptorSets : Int, dynamicOffsetCount : Int, pDynamicOffsets : Int) -> Unit = "vkCmdBindDescriptorSets"
extern "C" fn vkCmdPushConstants(commandBuffer : Int, layout : Int, stageFlags : Int, offset : Int, size : Int, pValues : Int) -> Unit = "vkCmdPushConstants"
