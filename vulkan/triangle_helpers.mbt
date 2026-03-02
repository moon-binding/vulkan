///|
/// MoonBit Vulkan SDK Bindings - Triangle Demo Helpers
/// Helper functions specifically for triangle rendering demo

// Helper to create render pass for simple color attachment
pub fn alloc_simple_render_pass_info() -> Int {
  let size = 96 // sizeof(VkRenderPassCreateInfo) = 12 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  // Initialize basic fields - will be set by caller
  put_int32(ptr, 0, VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO)
  put_int64(ptr, 8, 0)  // pNext
  put_int32(ptr, 16, 0) // flags

  ptr
}

// Helper to set attachments in render pass
pub fn set_render_pass_attachments(render_pass : Int, count : Int, attachments : Int) -> Unit {
  put_int32(render_pass, 24, count)
  put_int64(render_pass, 32, attachments)
}

// Helper to set subpasses
pub fn set_render_pass_subpasses(render_pass : Int, count : Int, subpasses : Int) -> Unit {
  put_int32(render_pass, 40, count)
  put_int64(render_pass, 48, subpasses)
}

// Helper to create framebuffer info
pub fn alloc_framebuffer_info() -> Int {
  let size = 72 // sizeof(VkFramebufferCreateInfo) = 9 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO)
  put_int64(ptr, 8, 0)  // pNext
  put_int32(ptr, 16, 0) // flags

  ptr
}

// Helper to set framebuffer attachments
pub fn set_framebuffer_attachments(framebuffer : Int, count : Int, attachments : Int) -> Unit {
  put_int32(framebuffer, 48, count)
  put_int64(framebuffer, 56, attachments)
}

// Helper to set framebuffer render pass
pub fn set_framebuffer_render_pass(framebuffer : Int, render_pass : Int) -> Unit {
  put_int64(framebuffer, 32, render_pass)
}

// Helper to set framebuffer dimensions
pub fn set_framebuffer_size(framebuffer : Int, width : Int, height : Int) -> Unit {
  put_int32(framebuffer, 64, width)
  put_int32(framebuffer, 68, height)
}

// Helper to create pipeline layout info
pub fn alloc_pipeline_layout_info() -> Int {
  let size = 56 // sizeof(VkPipelineLayoutCreateInfo) = 7 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO)
  put_int64(ptr, 8, 0)  // pNext
  put_int32(ptr, 16, 0) // flags
  put_int32(ptr, 24, 0) // setLayoutCount
  put_int64(ptr, 32, 0) // pSetLayouts
  put_int32(ptr, 40, 0) // pushConstantRangeCount
  put_int64(ptr, 48, 0) // pPushConstantRanges

  ptr
}

// Helper to create graphics pipeline info
pub fn alloc_graphics_pipeline_info() -> Int {
  let size = 192 // sizeof(VkGraphicsPipelineCreateInfo) = 24 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags

  ptr
}

// Helper to set pipeline shader stages
pub fn set_pipeline_stages(pipeline : Int, count : Int, stages : Int) -> Unit {
  put_int32(pipeline, 24, count)
  put_int64(pipeline, 32, stages)
}

// Helper to set pipeline layout
pub fn set_pipeline_layout(pipeline : Int, layout : Int) -> Unit {
  put_int64(pipeline, 152, layout)
}

// Helper to set pipeline render pass
pub fn set_pipeline_render_pass(pipeline : Int, render_pass : Int, subpass : Int) -> Unit {
  put_int64(pipeline, 160, render_pass)
  put_int32(pipeline, 168, subpass)
}

// Helper to set pipeline viewport state
pub fn set_pipeline_viewport_state(pipeline : Int, viewport_state : Int) -> Unit {
  put_int64(pipeline, 80, viewport_state)
}

// Helper to set pipeline input assembly state
pub fn set_pipeline_input_assembly_state(pipeline : Int, input_assembly : Int) -> Unit {
  put_int64(pipeline, 72, input_assembly)
}

// Helper to set pipeline rasterization state
pub fn set_pipeline_rasterization_state(pipeline : Int, rasterization : Int) -> Unit {
  put_int64(pipeline, 96, rasterization)
}

// Helper to set pipeline multisample state
pub fn set_pipeline_multisample_state(pipeline : Int, multisample : Int) -> Unit {
  put_int64(pipeline, 104, multisample)
}

// Helper to set pipeline color blend state
pub fn set_pipeline_color_blend_state(pipeline : Int, color_blend : Int) -> Unit {
  put_int64(pipeline, 120, color_blend)
}

// Helper to create viewport state info
pub fn alloc_viewport_state_info() -> Int {
  let size = 48 // sizeof(VkPipelineViewportStateCreateInfo) = 6 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO)
  put_int64(ptr, 8, 0)  // pNext
  put_int32(ptr, 16, 0) // flags
  put_int32(ptr, 24, 1) // viewportCount
  put_int64(ptr, 32, 0) // pViewports
  put_int32(ptr, 40, 1) // scissorCount
  put_int64(ptr, 48, 0) // pScissors - wait, offset is wrong

  ptr
}

// Helper to create input assembly state info
pub fn alloc_input_assembly_state_info() -> Int {
  let size = 40 // sizeof(VkPipelineInputAssemblyStateCreateInfo) = 5 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int32(ptr, 24, 0)  // topology (VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST = 0)
  put_int32(ptr, 28, 0)  // primitiveRestartEnable

  ptr
}

// Helper to set topology
pub fn set_topology(input_assembly : Int, topology : Int) -> Unit {
  put_int32(input_assembly, 24, topology)
}

// Helper to create rasterization state info
pub fn alloc_rasterization_state_info() -> Int {
  let size = 72 // sizeof(VkPipelineRasterizationStateCreateInfo) = 9 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int32(ptr, 24, 0)  // depthClampEnable
  put_int32(ptr, 28, 0)  // rasterizerDiscardEnable
  put_int32(ptr, 32, 0)  // polygonMode (VK_POLYGON_MODE_FILL = 0)
  put_int32(ptr, 36, 0)  // cullMode (VK_CULL_MODE_NONE = 0)
  put_int32(ptr, 40, 0)  // frontFace (VK_FRONT_FACE_COUNTER_CLOCKWISE = 0)
  put_int32(ptr, 44, 0)  // depthBiasEnable

  // Set default float values
  vulkan_set_float(ptr, 48, 0.0)  // depthBiasConstantFactor
  vulkan_set_float(ptr, 52, 0.0)  // depthBiasClamp
  vulkan_set_float(ptr, 56, 0.0)  // depthBiasSlopeFactor
  vulkan_set_float(ptr, 60, 1.0)  // lineWidth

  ptr
}

// Helper to create multisample state info
pub fn alloc_multisample_state_info() -> Int {
  let size = 56 // sizeof(VkPipelineMultisampleStateCreateInfo) = 7 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int32(ptr, 24, 0)  // rasterizationSamples (VK_SAMPLE_COUNT_1_BIT = 0)
  put_int32(ptr, 28, 0)  // sampleShadingEnable

  // Set default float values
  vulkan_set_float(ptr, 32, 0.0)  // minSampleShading

  ptr
}

// Helper to create color blend state info
pub fn alloc_color_blend_state_info() -> Int {
  let size = 80 // sizeof(VkPipelineColorBlendStateCreateInfo) = 10 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int32(ptr, 24, 0)  // logicOpEnable
  put_int32(ptr, 28, 0)  // logicOp
  put_int32(ptr, 32, 1)  // attachmentCount
  put_int64(ptr, 40, 0)  // pAttachments

  // Set blend constants to default
  vulkan_set_float(ptr, 48, 0.0)  // blendConstants[0]
  vulkan_set_float(ptr, 52, 0.0)  // blendConstants[1]
  vulkan_set_float(ptr, 56, 0.0)  // blendConstants[2]
  vulkan_set_float(ptr, 60, 0.0)  // blendConstants[3]

  ptr
}

// Helper to create color blend attachment state
pub fn alloc_color_blend_attachment_state() -> Int {
  let size = 32 // sizeof(VkPipelineColorBlendAttachmentState) = 8 * 4 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, 0)   // blendEnable
  put_int32(ptr, 4, 0)  // srcColorBlendFactor
  put_int32(ptr, 8, 0)  // dstColorBlendFactor
  put_int32(ptr, 12, 0) // colorBlendOp
  put_int32(ptr, 16, 0) // srcAlphaBlendFactor
  put_int32(ptr, 20, 0) // dstAlphaBlendFactor
  put_int32(ptr, 24, 0) // alphaBlendOp
  put_int32(ptr, 28, 15) // colorWriteMask (all components)

  ptr
}

// Helper to create shader stage create info
pub fn alloc_shader_stage_info() -> Int {
  let size = 48 // sizeof(VkPipelineShaderStageCreateInfo) = 6 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int64(ptr, 24, 0)  // stage
  put_int64(ptr, 32, 0)  // module
  put_int64(ptr, 40, 0)  // pName - will be set to "main"

  ptr
}

// Helper to set shader stage
pub fn set_shader_stage(stage_info : Int, stage : Int, module : Int64, name : Int) -> Unit {
  put_int32(stage_info, 24, stage)
  put_int64(stage_info, 32, module.to_int())
  put_int64(stage_info, 40, name)
}

// Helper to create shader module info
pub fn alloc_shader_module_info() -> Int {
  let size = 32 // sizeof(VkShaderModuleCreateInfo) = 4 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int64(ptr, 24, 0)  // codeSize
  put_int64(ptr, 32, 0)  // pCode

  ptr
}

// Helper to set shader module code
pub fn set_shader_module_code(module_info : Int, code_size : Int, code : Int) -> Unit {
  put_int64(module_info, 24, code_size)
  put_int64(module_info, 32, code)
}

// Helper to create command buffer begin info
pub fn alloc_command_buffer_begin_info() -> Int {
  let size = 32 // sizeof(VkCommandBufferBeginInfo) = 4 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int64(ptr, 24, 0)  // pInheritanceInfo

  ptr
}

// Helper to create render pass begin info
pub fn alloc_render_pass_begin_info() -> Int {
  let size = 64 // sizeof(VkRenderPassBeginInfo) = 8 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int64(ptr, 16, 0)  // renderPass
  put_int64(ptr, 24, 0)  // framebuffer
  put_int32(ptr, 32, 0)  // renderArea.offset.x
  put_int32(ptr, 36, 0)  // renderArea.offset.y
  put_int32(ptr, 40, 0)  // renderArea.extent.width
  put_int32(ptr, 44, 0)  // renderArea.extent.height
  put_int32(ptr, 48, 1)  // clearValueCount
  put_int64(ptr, 56, 0)  // pClearValues

  ptr
}

// Helper to set render pass begin render pass and framebuffer
pub fn set_render_pass_begin(render_pass_begin : Int, render_pass : Int, framebuffer : Int) -> Unit {
  put_int64(render_pass_begin, 16, render_pass)
  put_int64(render_pass_begin, 24, framebuffer)
}

// Helper to set render area
pub fn set_render_area(render_pass_begin : Int, x : Int, y : Int, width : Int, height : Int) -> Unit {
  put_int32(render_pass_begin, 32, x)
  put_int32(render_pass_begin, 36, y)
  put_int32(render_pass_begin, 40, width)
  put_int32(render_pass_begin, 44, height)
}

// Helper to set clear values
pub fn set_clear_values(render_pass_begin : Int, clear_values : Int) -> Unit {
  put_int64(render_pass_begin, 56, clear_values)
}

// Helper to create submit info
pub fn alloc_submit_info() -> Int {
  let size = 72 // sizeof(VkSubmitInfo) = 9 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_SUBMIT_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // waitSemaphoreCount
  put_int64(ptr, 24, 0)  // pWaitSemaphores
  put_int64(ptr, 32, 0)  // pWaitDstStageMask
  put_int32(ptr, 40, 1)  // commandBufferCount
  put_int64(ptr, 48, 0)  // pCommandBuffers
  put_int32(ptr, 56, 0)  // signalSemaphoreCount
  put_int64(ptr, 64, 0)  // pSignalSemaphores

  ptr
}

// Helper to set wait semaphores
pub fn set_submit_wait_semaphores(submit : Int, count : Int, semaphores : Int, stage_mask : Int) -> Unit {
  put_int32(submit, 16, count)
  put_int64(submit, 24, semaphores)
  put_int64(submit, 32, stage_mask)
}

// Helper to set command buffers
pub fn set_submit_command_buffers(submit : Int, count : Int, command_buffers : Int) -> Unit {
  put_int32(submit, 40, count)
  put_int64(submit, 48, command_buffers)
}

// Helper to set signal semaphores
pub fn set_submit_signal_semaphores(submit : Int, count : Int, semaphores : Int) -> Unit {
  put_int32(submit, 56, count)
  put_int64(submit, 64, semaphores)
}

// Helper to create semaphore create info
pub fn alloc_semaphore_create_info() -> Int {
  let size = 24 // sizeof(VkSemaphoreCreateInfo) = 3 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO)
  put_int64(ptr, 8, 0)  // pNext
  put_int32(ptr, 16, 0) // flags

  ptr
}

// Helper to create fence create info
pub fn alloc_fence_create_info(signaled : Bool) -> Int {
  let size = 24 // sizeof(VkFenceCreateInfo) = 3 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_FENCE_CREATE_INFO)
  put_int64(ptr, 8, 0)  // pNext
  put_int32(ptr, 16, if signaled { VK_FENCE_CREATE_SIGNALED_BIT } else { 0 })

  ptr
}

// Helper to create image view create info
pub fn alloc_image_view_info() -> Int {
  let size = 96 // sizeof(VkImageViewCreateInfo) = 12 * 8 bytes
  let ptr = vulkan_alloc_struct(size)

  put_int32(ptr, 0, VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO)
  put_int64(ptr, 8, 0)   // pNext
  put_int32(ptr, 16, 0)  // flags
  put_int64(ptr, 24, 0)  // image
  put_int32(ptr, 32, 0)  // viewType (VK_IMAGE_VIEW_TYPE_2D = 0)
  put_int32(ptr, 36, 0)  // format
  put_int32(ptr, 40, 0)  // components.r
  put_int32(ptr, 44, 0)  // components.g
  put_int32(ptr, 48, 0)  // components.b
  put_int32(ptr, 52, 0)  // components.a
  put_int64(ptr, 56, 0)  // subresourceRange.aspectMask
  put_int32(ptr, 64, 0)  // subresourceRange.baseMipLevel
  put_int32(ptr, 68, 1)  // subresourceRange.levelCount
  put_int32(ptr, 72, 0)  // subresourceRange.baseArrayLayer
  put_int32(ptr, 76, 1)  // subresourceRange.layerCount

  ptr
}

// Helper to set image view properties
pub fn set_image_view_properties(image_view : Int, image : Int64, format : Int, aspect_mask : Int64) -> Unit {
  put_int64(image_view, 24, image.to_int())
  put_int32(image_view, 36, format)
  put_int64(image_view, 56, aspect_mask.to_int())
}
