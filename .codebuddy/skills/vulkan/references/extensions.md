---
Vulkan Version: 1.3.290
Last Updated: 2025-02-27 (Manual)
---

# Vulkan Extensions

## KHR 扩展（Khronos 官方扩展）

### 核心 KHR 扩展

#### VK_KHR_swapchain
Swapchain 扩展，用于将渲染结果呈现到窗口表面。

**主要功能：**
- 创建和管理 Swapchain
- 获取 Swapchain 图像
- 呈现图像到表面

**关键函数：**
- `vkCreateSwapchainKHR`
- `vkDestroySwapchainKHR`
- `vkGetSwapchainImagesKHR`
- `vkAcquireNextImageKHR`
- `vkQueuePresentKHR`

**使用场景：** 所有渲染到窗口的应用程序

#### VK_KHR_surface
表面扩展，定义窗口系统与 Vulkan 之间的抽象接口。

**主要功能：**
- 创建和销毁表面
- 查询表面能力

**关键函数：**
- `vkCreateSurfaceKHR`
- `vkDestroySurfaceKHR`
- `vkGetPhysicalDeviceSurfaceSupportKHR`
- `vkGetPhysicalDeviceSurfaceCapabilitiesKHR`
- `vkGetPhysicalDeviceSurfaceFormatsKHR`
- `vkGetPhysicalDeviceSurfacePresentModesKHR`

**使用场景：** 跨平台窗口渲染

#### VK_KHR_surface_protected_capabilities
受保护表面能力扩展，用于 DRM 内容保护。

#### VK_KHR_swapchain_mutable_format
可变格式 Swapchain 扩展，允许 Swapchain 使用多个格式。

### 维护扩展

#### VK_KHR_maintenance1
维护扩展 1，添加了各种改进。

**主要功能：**
- 负视口和裁剪矩形
- 三角形扇、线条带支持
- 交换范围的钳制

#### VK_KHR_maintenance2
维护扩展 2，添加更多改进。

**主要功能：**
- 渲染通道读取输入
- 图像视图 2D/3D
- 采样器 YCbCr 转换

#### VK_KHR_maintenance3
维护扩展 3，改进内存管理。

**主要功能：**
- 描述符集的更精确限制
- 分离深度模板布局

#### VK_KHR_maintenance4
维护扩展 4，进一步改进。

**主要功能：**
- 推送常量支持
- 驱动属性查询

#### VK_KHR_maintenance5
维护扩展 5，最新的改进。

**主要功能：**
- 链接优化
- 分离渲染通道

### 现代渲染扩展

#### VK_KHR_dynamic_rendering
动态渲染扩展，允许在没有传统渲染通道的情况下进行渲染。

**主要功能：**
- 直接渲染到图像附件
- 消除渲染通道预定义
- 简化渲染循环

**关键函数：**
- `vkCmdBeginRenderingKHR`
- `vkCmdEndRenderingKHR`

**优势：**
- 更灵活的渲染流程
- 简化代码
- 更好的性能（某些情况）

**使用场景：** 现代渲染引擎、延迟渲染

#### VK_KHR_fragment_shading_rate
片段着色率扩展，支持可变速率着色。

**主要功能：**
- 动态调整片段着色率
- 节省 GPU 资源
- 提高帧率

**关键函数：**
- `vkCmdSetFragmentShadingRateKHR`

**使用场景：** VR、性能敏感应用

#### VK_KHR_shader_terminate_invocation
着色器终止扩展，允许着色器提前终止。

#### VK_KHR_fragment_shader_barycentric
片段着色器重心坐标扩展。

### 同步扩展

#### VK_KHR_synchronization2
同步 2 扩展，增强的同步原语。

**主要功能：**
- 统一的同步接口
- 更精确的内存屏障
- 改进的子通道依赖

**关键函数：**
- `vkCmdPipelineBarrier2KHR`

**优势：**
- 更简洁的同步代码
- 更好的性能

**使用场景：** 所有需要精细同步的应用

#### VK_KHR_timeline_semaphore
时间线信号量扩展。

**主要功能：**
- 基于 64 位值的信号量
- 异步操作排序

**关键函数：**
- `vkWaitSemaphoresKHR`
- `vkSignalSemaphoreKHR`

### 着色器扩展

#### VK_KHR_shader_subgroup_extended_types
着色器子组扩展类型。

#### VK_KHR_shader_float16_int8
半精度浮点和 8 位整数支持。

#### VK_KHR_shader_float_controls
着色器浮点控制。

#### VK_KHR_shader_clock
着色器时钟读取。

#### VK_KHR_workgroup_memory_explicit_layout
工作组内存显式布局。

### 管线扩展

#### VK_KHR_pipeline_library
管线库扩展，支持管线链接。

#### VK_KHR_pipeline_executable_properties
管线可执行属性扩展，用于性能分析。

#### VK_KHR_shader_subgroup_uniform_control_flow
子组统一控制流扩展。

### 内存扩展

#### VK_KHR_maintenance5
维护扩展 5，包含内存改进。

#### VK_KHR_get_memory_requirements2
获取内存需求 2，改进的内存查询。

**关键函数：**
- `vkGetImageMemoryRequirements2KHR`
- `vkGetBufferMemoryRequirements2KHR`

#### VK_KHR_dedicated_allocation
专用分配扩展，优化内存分配。

### 设备扩展

#### VK_KHR_device_group
设备组扩展，支持多 GPU。

**主要功能：**
- 跨 GPU 渲染
- 显存池化
- 负载均衡

**关键函数：**
- `vkGetDeviceGroupPeerMemoryFeaturesKHR`

**使用场景：** 高性能工作站、专业渲染

#### VK_KHR_external_memory
外部内存扩展，与其他 API 共享内存。

#### VK_KHR_external_semaphore
外部信号量扩展，跨进程共享信号量。

#### VK_KHR_external_fence
外部栅栏扩展，跨进程共享栅栏。

### 调试扩展

#### VK_KHR_shader_debugger
着色器调试器扩展（计划中）。

### 格式扩展

#### VK_KHR_format_feature_flags2
格式特性标志 2 扩展。

#### VK_KHR_fragment_shader_barycentric
片段着色器重心坐标扩展。

## EXT 扩展（厂商扩展）

### 调试扩展

#### VK_EXT_debug_utils
调试工具扩展，提供强大的调试功能。

**主要功能：**
- 设置对象名称和标签
- 调试回调消息
- 命令缓冲区标签

**关键函数：**
- `vkSetDebugUtilsObjectNameEXT`
- `vkCmdBeginDebugUtilsLabelEXT`
- `vkCmdInsertDebugUtilsLabelEXT`
- `vkCmdEndDebugUtilsLabelEXT`
- `vkSetDebugUtilsObjectTagEXT`

**使用场景：** 开发和调试阶段

#### VK_EXT_debug_report
调试报告扩展（已被 debug_utils 部分取代）。

#### VK_EXT_validation_features
验证特性扩展，控制验证层行为。

#### VK_EXT_validation_cache
验证缓存扩展，加速验证层。

### 光线追踪扩展

#### VK_KHR_ray_tracing_pipeline
光线追踪管线扩展，完整的硬件加速光线追踪。

**主要功能：**
- 加速结构
- 光线追踪管线
- 着色器绑定表

**关键函数：**
- `vkCreateRayTracingPipelinesKHR`
- `vkCmdTraceRaysKHR`

**使用场景：** 实时光线追踪、高端图形

#### VK_KHR_ray_query
光线查询扩展，在图形/计算管线中进行光线追踪。

**主要功能：**
- 在任意着色器中进行光线追踪
- 更灵活的光线追踪使用

**使用场景：** 混合渲染技术

#### VK_KHR_acceleration_structure
加速结构扩展，用于光线追踪。

**主要功能：**
- 创建和管理加速结构
- 构建底部和顶层加速结构

**关键函数：**
- `vkCreateAccelerationStructureKHR`
- `vkBuildAccelerationStructuresKHR`

#### VK_KHR_ray_tracing_maintenance1
光线追踪维护扩展。

### 网格着色器扩展

#### VK_KHR_mesh_shader
网格着色器扩展，替代传统顶点/几何着色器。

**主要功能：**
- 网格着色器阶段
- 任务着色器阶段
- 灵活的几何处理

**使用场景：** 程序化几何、LOD、粒子系统

#### VK_EXT_mesh_shader
网格着色器扩展（AMD 版本）。

### 图像扩展

#### VK_EXT_descriptor_indexing
描述符索引扩展，无绑定的描述符访问。

**主要功能：**
- 非统一的描述符访问
- 描述符更新模板

**优势：**
- 更灵活的资源管理
- 更好的性能

#### VK_EXT_scalar_block_layout
标量块布局扩展，改进内存布局。

#### VK_EXT_memory_priority
内存优先级扩展，设置内存使用优先级。

#### VK_EXT_pageable_device_local_memory
可分页设备本地内存扩展，支持内存换页。

### 计算扩展

#### VK_KHR_shader_integer_dot_product
着色器整数点积扩展。

#### VK_KHR_shader_subgroup_extended_types
着色器子组扩展类型。

### 同步扩展

#### VK_EXT_memory_barrier
内存屏障扩展。

#### VK_EXT_memory_priority
内存优先级扩展。

### 工具扩展

#### VK_EXT_tooling_info
工具信息扩展，查询启用的工具和层。

**关键函数：**
- `vkGetPhysicalDeviceToolPropertiesEXT`

### 表面扩展

#### VK_EXT_display_swapchain
显示 Swapchain 扩展，直接输出到显示器。

#### VK_EXT_full_screen_exclusive
全屏独占扩展，用于 Windows 全屏优化。

### 其他扩展

#### VK_EXT_robustness2
健壮性 2 扩展，改进的边界检查。

#### VK_EXT_custom_border_color
自定义边框颜色扩展。

#### VK_EXT_extended_dynamic_state
扩展动态状态扩展。

**主要功能：**
- 动态设置更多管线状态
- 减少管线对象数量

#### VK_EXT_extended_dynamic_state2
扩展动态状态 2 扩展。

#### VK_EXT_extended_dynamic_state3
扩展动态状态 3 扩展。

## 验证层

### VK_LAYER_KHRONOS_validation
Khronos 验证层，官方的 Vulkan 验证层。

**功能：**
- 检测常见的 Vulkan 错误
- 性能警告
- 最佳实践建议

**环境变量：**
```
VK_LAYER_PATH=/path/to/layers
VK_INSTANCE_LAYERS=VK_LAYER_KHRONOS_validation
```

### 其他验证层

- `VK_LAYER_LUNARG_standard_validation`（已废弃）
- `VK_LAYER_LUNARG_core_validation`（已废弃）
- `VK_LAYER_GOOGLE_threading`（已废弃）

## 启用扩展

### 启用实例扩展

```cpp
const char* extensions[] = {
    VK_KHR_SURFACE_EXTENSION_NAME,
    "VK_KHR_win32_surface",  // 或其他平台特定的表面扩展
    VK_EXT_DEBUG_UTILS_EXTENSION_NAME
};

VkInstanceCreateInfo createInfo = {};
createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
createInfo.enabledExtensionCount = sizeof(extensions) / sizeof(extensions[0]);
createInfo.ppEnabledExtensionNames = extensions;
```

### 启用设备扩展

```cpp
const char* deviceExtensions[] = {
    VK_KHR_SWAPCHAIN_EXTENSION_NAME,
    VK_KHR_DYNAMIC_RENDERING_EXTENSION_NAME
};

VkDeviceCreateInfo deviceCreateInfo = {};
deviceCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
deviceCreateInfo.enabledExtensionCount = sizeof(deviceExtensions) / sizeof(deviceExtensions[0]);
deviceCreateInfo.ppEnabledExtensionNames = deviceExtensions;
```

### 检查扩展支持

```cpp
uint32_t extensionCount = 0;
vkEnumerateInstanceExtensionProperties(nullptr, &extensionCount, nullptr);

std::vector<VkExtensionProperties> extensions(extensionCount);
vkEnumerateInstanceExtensionProperties(nullptr, &extensionCount, extensions.data());

for (const auto& extension : extensions) {
    std::cout << extension.extensionName << std::endl;
}
```

## 注意事项

1. **扩展版本**：不同扩展可能属于不同的 Vulkan 版本
2. **平台差异**：某些扩展仅支持特定平台
3. **厂商支持**：部分 EXT 扩展仅特定厂商支持
4. **性能影响**：某些扩展可能有性能开销
5. **兼容性**：始终检查扩展支持后再使用
6. **废弃扩展**：某些扩展可能被新扩展取代

## 参考资料

- Vulkan 扩展规范：https://registry.khronos.org/vulkan/specs/1.3/extensions/
- 扩展状态：https://github.com/KhronosGroup/Vulkan-ValidationLayers
