///|
/// Vulkan Command Recording FFI Function Declarations
/// Direct bindings to Vulkan C API for command buffer recording

pub extern "C" fn vkCmdBeginRenderPass(commandBuffer : Int64, pRenderPassBegin : Int, contents : Int) -> Unit = "vkCmdBeginRenderPass"
pub extern "C" fn vkCmdEndRenderPass(commandBuffer : Int64) -> Unit = "vkCmdEndRenderPass"
pub extern "C" fn vkCmdBindPipeline(commandBuffer : Int64, pipelineBindPoint : Int, pipeline : Int64) -> Unit = "vkCmdBindPipeline"
pub extern "C" fn vkCmdBindVertexBuffers(commandBuffer : Int64, firstBinding : Int, bindingCount : Int, pBuffers : Int, pOffsets : Int) -> Unit = "vkCmdBindVertexBuffers"
pub extern "C" fn vkCmdDraw(commandBuffer : Int64, vertexCount : Int, instanceCount : Int, firstVertex : Int, firstInstance : Int) -> Unit = "vkCmdDraw"
pub extern "C" fn vkCmdDrawIndexed(commandBuffer : Int64, indexCount : Int, instanceCount : Int, firstIndex : Int, vertexOffset : Int, firstInstance : Int) -> Unit = "vkCmdDrawIndexed"
pub extern "C" fn vkCmdSetViewport(commandBuffer : Int64, firstViewport : Int, viewportCount : Int, pViewports : Int) -> Unit = "vkCmdSetViewport"
pub extern "C" fn vkCmdSetScissor(commandBuffer : Int64, firstScissor : Int, scissorCount : Int, pScissors : Int) -> Unit = "vkCmdSetScissor"
pub extern "C" fn vkCmdCopyBuffer(commandBuffer : Int64, srcBuffer : Int64, dstBuffer : Int64, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyBuffer"
pub extern "C" fn vkCmdCopyImage(commandBuffer : Int64, srcImage : Int64, srcImageLayout : Int, dstImage : Int64, dstImageLayout : Int, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyImage"
pub extern "C" fn vkCmdCopyBufferToImage(commandBuffer : Int64, srcBuffer : Int64, dstImage : Int64, dstImageLayout : Int, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyBufferToImage"
pub extern "C" fn vkCmdCopyImageToBuffer(commandBuffer : Int64, srcImage : Int64, srcImageLayout : Int, dstBuffer : Int64, regionCount : Int, pRegions : Int) -> Unit = "vkCmdCopyImageToBuffer"
pub extern "C" fn vkCmdPipelineBarrier(commandBuffer : Int64, srcStageMask : Int, dstStageMask : Int, dependencyFlags : Int, memoryBarrierCount : Int, pMemoryBarriers : Int, bufferMemoryBarrierCount : Int, pBufferMemoryBarriers : Int, imageMemoryBarrierCount : Int, pImageMemoryBarriers : Int) -> Unit = "vkCmdPipelineBarrier"
pub extern "C" fn vkCmdBindDescriptorSets(commandBuffer : Int64, pipelineBindPoint : Int, layout : Int64, firstSet : Int, descriptorSetCount : Int, pDescriptorSets : Int, dynamicOffsetCount : Int, pDynamicOffsets : Int) -> Unit = "vkCmdBindDescriptorSets"
pub extern "C" fn vkCmdPushConstants(commandBuffer : Int64, layout : Int64, stageFlags : Int, offset : Int, size : Int, pValues : Int) -> Unit = "vkCmdPushConstants"
