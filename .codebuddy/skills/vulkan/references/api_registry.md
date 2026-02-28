---
Vulkan Version: 1.3.290
Version Name: Vulkan 1.3.290
Last Updated: 2025-02-27 (Manual)
---

# Vulkan API Registry

## Core Commands

### Instance Commands

- `vkCreateInstance` - 创建 Vulkan 实例
- `vkDestroyInstance` - 销毁 Vulkan 实例
- `vkEnumeratePhysicalDevices` - 枚举物理设备
- `vkGetPhysicalDeviceProperties` - 获取物理设备属性
- `vkGetPhysicalDeviceFeatures` - 获取物理设备特性
- `vkGetPhysicalDeviceQueueFamilyProperties` - 获取队列族属性
- `vkGetPhysicalDeviceMemoryProperties` - 获取内存属性
- `vkGetPhysicalDeviceFormatProperties` - 获取格式属性

### Device Commands

- `vkCreateDevice` - 创建逻辑设备
- `vkDestroyDevice` - 销毁逻辑设备
- `vkDeviceWaitIdle` - 等待设备空闲

### Queue Commands

- `vkGetDeviceQueue` - 获取设备队列
- `vkQueueSubmit` - 提交命令缓冲区到队列
- `vkQueueWaitIdle` - 等待队列空闲
- `vkQueuePresentKHR` - 呈现图像

### Command Pool and Buffer Commands

- `vkCreateCommandPool` - 创建命令池
- `vkDestroyCommandPool` - 销毁命令池
- `vkResetCommandPool` - 重置命令池
- `vkAllocateCommandBuffers` - 分配命令缓冲区
- `vkFreeCommandBuffers` - 释放命令缓冲区
- `vkBeginCommandBuffer` - 开始录制命令缓冲区
- `vkEndCommandBuffer` - 结束录制命令缓冲区
- `vkResetCommandBuffer` - 重置命令缓冲区

### Memory Commands

- `vkAllocateMemory` - 分配内存
- `vkFreeMemory` - 释放内存
- `vkMapMemory` - 映射内存
- `vkUnmapMemory` - 取消映射内存
- `vkFlushMappedMemoryRanges` - 刷新映射内存范围
- `vkInvalidateMappedMemoryRanges` - 使映射内存范围无效

### Buffer Commands

- `vkCreateBuffer` - 创建缓冲
- `vkDestroyBuffer` - 销毁缓冲
- `vkBindBufferMemory` - 绑定缓冲到内存
- `vkGetBufferMemoryRequirements` - 获取缓冲内存需求

### Image Commands

- `vkCreateImage` - 创建图像
- `vkDestroyImage` - 销毁图像
- `vkBindImageMemory` - 绑定图像到内存
- `vkGetImageMemoryRequirements` - 获取图像内存需求

### ImageView Commands

- `vkCreateImageView` - 创建图像视图
- `vkDestroyImageView` - 销毁图像视图

### Shader Module Commands

- `vkCreateShaderModule` - 创建着色器模块
- `vkDestroyShaderModule` - 销毁着色器模块

### Pipeline Commands

- `vkCreatePipelineCache` - 创建管线缓存
- `vkDestroyPipelineCache` - 销毁管线缓存
- `vkCreateGraphicsPipelines` - 创建图形管线
- `vkCreateComputePipelines` - 创建计算管线
- `vkDestroyPipeline` - 销毁管线
- `vkCreatePipelineLayout` - 创建管线布局
- `vkDestroyPipelineLayout` - 销毁管线布局

### Render Pass Commands

- `vkCreateRenderPass` - 创建渲染通道
- `vkDestroyRenderPass` - 销毁渲染通道
- `vkBeginRenderPass` - 开始渲染通道
- `vkNextSubpass` - 进入下一个子通道
- `vkEndRenderPass` - 结束渲染通道

### Framebuffer Commands

- `vkCreateFramebuffer` - 创建帧缓冲
- `vkDestroyFramebuffer` - 销毁帧缓冲

### Descriptor Set Commands

- `vkCreateDescriptorSetLayout` - 创建描述符集布局
- `vkDestroyDescriptorSetLayout` - 销毁描述符集布局
- `vkCreateDescriptorPool` - 创建描述符池
- `vkDestroyDescriptorPool` - 销毁描述符池
- `vkAllocateDescriptorSets` - 分配描述符集
- `vkFreeDescriptorSets` - 释放描述符集
- `vkUpdateDescriptorSets` - 更新描述符集

### Sampler Commands

- `vkCreateSampler` - 创建采样器
- `vkDestroySampler` - 销毁采样器

### Query Pool Commands

- `vkCreateQueryPool` - 创建查询池
- `vkDestroyQueryPool` - 销毁查询池
- `vkGetQueryPoolResults` - 获取查询池结果

### Semaphore Commands

- `vkCreateSemaphore` - 创建信号量
- `vkDestroySemaphore` - 销毁信号量

### Fence Commands

- `vkCreateFence` - 创建栅栏
- `vkDestroyFence` - 销毁栅栏
- `vkWaitForFences` - 等待栅栏
- `vkResetFences` - 重置栅栏

### Event Commands

- `vkCreateEvent` - 创建事件
- `vkDestroyEvent` - 销毁事件
- `vkSetEvent` - 设置事件
- `vkResetEvent` - 重置事件

### Swapchain Commands

- `vkCreateSwapchainKHR` - 创建 Swapchain
- `vkDestroySwapchainKHR` - 销毁 Swapchain
- `vkGetSwapchainImagesKHR` - 获取 Swapchain 图像
- `vkAcquireNextImageKHR` - 获取下一个图像

### Surface Commands

- `vkCreateSurfaceKHR` - 创建表面
- `vkDestroySurfaceKHR` - 销毁表面
- `vkGetPhysicalDeviceSurfaceSupportKHR` - 获取物理设备表面支持

## Structures

### Core Structures

- `VkApplicationInfo` - 应用程序信息
- `VkInstanceCreateInfo` - 实例创建信息
- `VkPhysicalDeviceProperties` - 物理设备属性
- `VkPhysicalDeviceFeatures` - 物理设备特性
- `VkPhysicalDeviceLimits` - 物理设备限制
- `VkPhysicalDeviceMemoryProperties` - 物理设备内存属性
- `VkMemoryHeap` - 内存堆
- `VkMemoryType` - 内存类型
- `VkDeviceQueueCreateInfo` - 设备队列创建信息
- `VkDeviceCreateInfo` - 设备创建信息
- `VkQueueFamilyProperties` - 队列族属性

### Memory Structures

- `VkMemoryAllocateInfo` - 内存分配信息
- `VkMemoryRequirements` - 内存需求
- `VkMappedMemoryRange` - 映射内存范围

### Buffer Structures

- `VkBufferCreateInfo` - 缓冲创建信息
- `VkBufferCopy` - 缓冲复制

### Image Structures

- `VkImageCreateInfo` - 图像创建信息
- `VkImageSubresource` - 图像子资源
- `VkImageSubresourceLayers` - 图像子资源层
- `VkImageSubresourceRange` - 图像子资源范围
- `VkImageCopy` - 图像复制
- `VkImageBlit` - 图像位传输

### ImageView Structures

- `VkImageViewCreateInfo` - 图像视图创建信息
- `VkImageSubresourceRange` - 图像子资源范围

### Shader Structures

- `VkShaderModuleCreateInfo` - 着色器模块创建信息
- `VkPipelineShaderStageCreateInfo` - 管线着色器阶段创建信息

### Pipeline Structures

- `VkGraphicsPipelineCreateInfo` - 图形管线创建信息
- `VkComputePipelineCreateInfo` - 计算管线创建信息
- `VkPipelineLayoutCreateInfo` - 管线布局创建信息
- `VkPipelineVertexInputStateCreateInfo` - 管线顶点输入状态创建信息
- `VkPipelineInputAssemblyStateCreateInfo` - 管线输入装配状态创建信息
- `VkPipelineRasterizationStateCreateInfo` - 管线光栅化状态创建信息
- `VkPipelineMultisampleStateCreateInfo` - 管线多重采样状态创建信息
- `VkPipelineDepthStencilStateCreateInfo` - 管线深度模板状态创建信息
- `VkPipelineColorBlendStateCreateInfo` - 管线颜色混合状态创建信息
- `VkPipelineDynamicStateCreateInfo` - 管线动态状态创建信息
- `VkVertexInputBindingDescription` - 顶点输入绑定描述
- `VkVertexInputAttributeDescription` - 顶点输入属性描述

### Render Pass Structures

- `VkRenderPassCreateInfo` - 渲染通道创建信息
- `VkSubpassDescription` - 子通道描述
- `VkAttachmentDescription` - 附件描述
- `VkAttachmentReference` - 附件引用
- `VkSubpassDependency` - 子通道依赖
- `VkRenderPassBeginInfo` - 渲染通道开始信息

### Framebuffer Structures

- `VkFramebufferCreateInfo` - 帧缓冲创建信息

### Descriptor Structures

- `VkDescriptorSetLayoutCreateInfo` - 描述符集布局创建信息
- `VkDescriptorSetLayoutBinding` - 描述符集布局绑定
- `VkDescriptorPoolCreateInfo` - 描述符池创建信息
- `VkDescriptorSetAllocateInfo` - 描述符集分配信息
- `VkWriteDescriptorSet` - 写入描述符集
- `VkDescriptorBufferInfo` - 描述符缓冲信息
- `VkDescriptorImageInfo` - 描述符图像信息

### Swapchain Structures

- `VkSwapchainCreateInfoKHR` - Swapchain 创建信息
- `VkPresentInfoKHR` - 呈现信息

### Synchronization Structures

- `VkFenceCreateInfo` - 栅栏创建信息
- `VkSemaphoreCreateInfo` - 信号量创建信息
- `VkEventCreateInfo` - 事件创建信息
- `VkMemoryBarrier` - 内存屏障
- `VkBufferMemoryBarrier` - 缓冲内存屏障
- `VkImageMemoryBarrier` - 图像内存屏障

## Enums

### Result Codes

- `VK_SUCCESS` - 操作成功
- `VK_NOT_READY` - 操作未完成
- `VK_TIMEOUT` - 操作超时
- `VK_EVENT_SET` - 事件已设置
- `VK_EVENT_RESET` - 事件已重置
- `VK_INCOMPLETE` - 操作不完整
- `VK_ERROR_OUT_OF_HOST_MEMORY` - 主机内存不足
- `VK_ERROR_OUT_OF_DEVICE_MEMORY` - 设备内存不足
- `VK_ERROR_INITIALIZATION_FAILED` - 初始化失败
- `VK_ERROR_DEVICE_LOST` - 设备丢失
- `VK_ERROR_MEMORY_MAP_FAILED` - 内存映射失败
- `VK_ERROR_LAYER_NOT_PRESENT` - 层不存在
- `VK_ERROR_EXTENSION_NOT_PRESENT` - 扩展不存在
- `VK_ERROR_FEATURE_NOT_PRESENT` - 特性不存在
- `VK_ERROR_INCOMPATIBLE_DRIVER` - 驱动不兼容
- `VK_ERROR_TOO_MANY_OBJECTS` - 对象太多
- `VK_ERROR_FORMAT_NOT_SUPPORTED` - 格式不支持
- `VK_ERROR_FRAGMENTED_POOL` - 池碎片化

### Image Formats

- `VK_FORMAT_UNDEFINED` - 未定义格式
- `VK_FORMAT_R8G8B8A8_UNORM` - 8 位 RGBA 无符号归一化
- `VK_FORMAT_R8G8B8A8_SRGB` - 8 位 RGBA sRGB
- `VK_FORMAT_B8G8R8A8_UNORM` - 8 位 BGRA 无符号归一化
- `VK_FORMAT_R32_SFLOAT` - 32 位浮点红色
- `VK_FORMAT_R32G32_SFLOAT` - 32 位浮点 RG
- `VK_FORMAT_R32G32B32_SFLOAT` - 32 位浮点 RGB
- `VK_FORMAT_R32G32B32A32_SFLOAT` - 32 位浮点 RGBA
- `VK_FORMAT_D32_SFLOAT` - 32 位浮点深度
- `VK_FORMAT_D24_UNORM_S8_UINT` - 24 位深度 8 位模板

### Image Types

- `VK_IMAGE_TYPE_1D` - 一维图像
- `VK_IMAGE_TYPE_2D` - 二维图像
- `VK_IMAGE_TYPE_3D` - 三维图像

### Image Tiling

- `VK_IMAGE_TILING_OPTIMAL` - 优化的平铺
- `VK_IMAGE_TILING_LINEAR` - 线性平铺

### Image Usage Flags

- `VK_IMAGE_USAGE_TRANSFER_SRC_BIT` - 传输源
- `VK_IMAGE_USAGE_TRANSFER_DST_BIT` - 传输目标
- `VK_IMAGE_USAGE_SAMPLED_BIT` - 采样
- `VK_IMAGE_USAGE_STORAGE_BIT` - 存储
- `VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT` - 颜色附件
- `VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT` - 深度模板附件
- `VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT` - 临时附件
- `VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT` - 输入附件

### Pipeline Stages

- `VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT` - 管线顶部
- `VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT` - 绘制间接
- `VK_PIPELINE_STAGE_VERTEX_INPUT_BIT` - 顶点输入
- `VK_PIPELINE_STAGE_VERTEX_SHADER_BIT` - 顶点着色器
- `VK_PIPELINE_STAGE_TESSELLATION_CONTROL_SHADER_BIT` - 曲面细分控制着色器
- `VK_PIPELINE_STAGE_TESSELLATION_EVALUATION_SHADER_BIT` - 曲面细分求值着色器
- `VK_PIPELINE_STAGE_GEOMETRY_SHADER_BIT` - 几何着色器
- `VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT` - 片段着色器
- `VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT` - 早期片段测试
- `VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT` - 晚期片段测试
- `VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT` - 颜色附件输出
- `VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT` - 计算着色器
- `VK_PIPELINE_STAGE_TRANSFER_BIT` - 传输
- `VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT` - 管线底部

## Flags

### Buffer Usage Flags

- `VK_BUFFER_USAGE_TRANSFER_SRC_BIT` - 传输源
- `VK_BUFFER_USAGE_TRANSFER_DST_BIT` - 传输目标
- `VK_BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT` - 纹理元素缓冲
- `VK_BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT` - 存储纹理元素缓冲
- `VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT` - 统一缓冲
- `VK_BUFFER_USAGE_STORAGE_BUFFER_BIT` - 存储缓冲
- `VK_BUFFER_USAGE_INDEX_BUFFER_BIT` - 索引缓冲
- `VK_BUFFER_USAGE_VERTEX_BUFFER_BIT` - 顶点缓冲
- `VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT` - 间接缓冲

### Memory Property Flags

- `VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT` - 设备本地
- `VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT` - 主机可见
- `VK_MEMORY_PROPERTY_HOST_COHERENT_BIT` - 主机一致
- `VK_MEMORY_PROPERTY_HOST_CACHED_BIT` - 主机缓存
- `VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT` - 延迟分配

### Queue Flags

- `VK_QUEUE_GRAPHICS_BIT` - 图形队列
- `VK_QUEUE_COMPUTE_BIT` - 计算队列
- `VK_QUEUE_TRANSFER_BIT` - 传输队列
- `VK_QUEUE_SPARSE_BINDING_BIT` - 稀疏绑定队列
