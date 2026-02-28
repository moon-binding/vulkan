---
Vulkan Version: 1.3.290
Version Name: Vulkan 1.3.290
Last Updated: 2025-02-27 (Manual)
---

# Vulkan Specification

## Vulkan 简介

Vulkan 是一个低开销、跨平台的 3D 图形和计算 API。它提供了对现代 GPU 的底层访问，使得开发者能够实现高性能的图形渲染和计算任务。

## 核心概念

### 实例 (Instance)

Vulkan 实例是应用程序与 Vulkan 库之间的主要连接。每个应用程序通常只有一个实例。

创建实例时需要指定：
- 应用程序信息 (`VkApplicationInfo`)
- 启用的层（Layer）
- 启用的扩展（Extension）

### 物理设备 (Physical Device)

物理设备代表系统中的 GPU 或其他图形设备。一个系统可能有多个物理设备（如集成显卡和独立显卡）。

选择物理设备时需要考虑：
- 设备类型（独立 GPU、集成 GPU、CPU）
- 支持的队列族
- 内存属性
- 支持的特性（如几何着色器、曲面细分）
- 支持的扩展

### 逻辑设备 (Logical Device)

逻辑设备是物理设备的逻辑表示，用于执行 Vulkan 命令。创建逻辑设备时：
- 指定要使用的队列族
- 指定要启用的设备特性
- 指定要启用的设备扩展

### 队列 (Queue)

队列是执行命令的通道。每种队列类型（图形、计算、传输）都有不同的能力：
- 图形队列：可以执行所有图形操作
- 计算队列：可以执行计算着色器
- 传输队列：用于内存拷贝等传输操作

## 渲染流程

### 1. 初始化

```
创建实例 → 选择物理设备 → 创建逻辑设备 → 获取队列
```

### 2. 创建表面（Surface）

如果渲染到窗口，需要创建表面来表示输出目标。

### 3. 创建 Swapchain

Swapchain 是一系列用于呈现的图像。创建 Swapchain 需要：
- 获取支持的表面格式
- 选择呈现模式
- 确定交换范围和图像数量

### 4. 创建图像视图

图像视图描述如何访问图像的子资源。

### 5. 创建渲染通道 (Render Pass)

渲染通道定义渲染子通道和附件的描述：
- 颜色附件
- 深度模板附件
- 附件间的依赖关系

### 6. 创建帧缓冲 (Framebuffer)

帧缓冲绑定渲染通道的附件到具体的图像。

### 7. 创建图形管线

图形管线包含渲染管线的所有配置：
- 着色器阶段
- 顶点输入状态
- 输入装配状态
- 视口和裁剪状态
- 光栅化状态
- 多重采样状态
- 深度模板状态
- 颜色混合状态
- 动态状态

### 8. 创建命令池和命令缓冲区

命令池管理命令缓冲区的内存。命令缓冲区记录要执行的命令。

### 9. 创建同步对象

- 栅栏 (Fence)：CPU-GPU 同步
- 信号量 (Semaphore)：GPU-GPU 同步
- 事件 (Event)：GPU 内部同步

### 10. 渲染循环

```
获取图像 → 等待上一帧 → 录制命令 → 提交命令 → 呈现图像
```

## 内存管理

### 内存类型

Vulkan 将内存分为多个堆和类型：
- 堆：内存的物理表示（显存、系统内存）
- 类型：访问属性（设备本地、主机可见、主机一致）

### 内存分配

应用程序必须显式管理内存：
1. 查询内存需求（`vkGetBufferMemoryRequirements`）
2. 选择合适的内存类型
3. 分配内存（`vkAllocateMemory`）
4. 绑定到资源（`vkBindBufferMemory` / `vkBindImageMemory`）

### 内存映射

将设备内存映射到主机地址空间：
- 映射（`vkMapMemory`）
- 写入数据
- 刷新或使无效（`vkFlushMappedMemoryRanges` / `vkInvalidateMappedMemoryRanges`）
- 取消映射（`vkUnmapMemory`）

## 描述符系统

描述符允许着色器访问资源：
- 统一缓冲
- 存储缓冲
- 采样图像
- 存储图像
- 采样器

### 描述符集布局

定义描述符集的结构，包括：
- 绑定（Binding）
- 描述符类型
- 着色器阶段
- 描述符数量

### 描述符池

管理描述符集的内存分配。

### 描述符集更新

使用 `vkUpdateDescriptorSets` 更新描述符集。

## 同步

### 同步原语

- **Fence**: 用于 CPU 等待 GPU 操作完成
- **Semaphore**: 用于 GPU 队列间的同步
- **Event**: 用于 GPU 命令缓冲区内的精细同步

### 内存屏障

确保内存操作的可见性：
- `vkCmdPipelineBarrier`: 设置管线阶段的内存屏障
- 内存屏障类型：全局内存屏障、缓冲内存屏障、图像内存屏障

### 执行屏障

确保命令的执行顺序：
- 使用子通道依赖
- 使用管线屏障

## 着色器

### 着色器阶段

- 顶点着色器 (`VK_SHADER_STAGE_VERTEX_BIT`)
- 曲面细分控制着色器 (`VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT`)
- 曲面细分求值着色器 (`VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT`)
- 几何着色器 (`VK_SHADER_STAGE_GEOMETRY_BIT`)
- 片段着色器 (`VK_SHADER_STAGE_FRAGMENT_BIT`)
- 计算着色器 (`VK_SHADER_STAGE_COMPUTE_BIT`)

### 着色器语言

使用 GLSL 编写着色器，然后编译为 SPIR-V：
- `glslc` (Vulkan SDK)
- `glslangValidator`

### 推送常量

一种高效的向所有着色器阶段传递少量数据的方式。

## 扩展

### 核心扩展

- **VK_KHR_swapchain**: Swapchain 扩展
- **VK_KHR_surface**: 表面扩展
- **VK_KHR_maintenance1**: 维护扩展
- **VK_KHR_maintenance2**: 维护扩展 2
- **VK_KHR_maintenance3**: 维护扩展 3
- **VK_KHR_maintenance4**: 维护扩展 4

### 调试扩展

- **VK_EXT_debug_utils**: 调试工具扩展
- **VK_EXT_debug_report**: 调试报告扩展

### 光线追踪扩展

- **VK_KHR_ray_tracing_pipeline**: 光线追踪管线
- **VK_KHR_ray_query**: 光线查询
- **VK_KHR_acceleration_structure**: 加速结构

### 现代渲染扩展

- **VK_KHR_dynamic_rendering**: 动态渲染
- **VK_KHR_fragment_shading_rate**: 片段着色率
- **VK_KHR_mesh_shader**: 网格着色器

### 同步扩展

- **VK_KHR_synchronization2**: 增强的同步

## 最佳实践

### 性能优化

1. **批处理**: 将多个绘制调用合并
2. **减少状态变化**: 最小化管线切换
3. **使用持久映射**: 避免频繁映射/取消映射
4. **使用间接绘制**: 减少CPU-GPU通信
5. **优化内存使用**: 使用设备本地内存存储GPU专用数据

### 调试

1. **启用验证层**: 在开发时使用 `VK_LAYER_KHRONOS_validation`
2. **设置对象名称**: 使用 `VK_EXT_debug_utils` 设置对象标签
3. **使用调试工具**: RenderDoc、NVIDIA Nsight、GPUView
4. **检查返回值**: 始终检查 Vulkan 函数的返回值

### 资源管理

1. **使用内存分配库**: VMA (Vulkan Memory Allocator)
2. **重用资源**: 对象池、描述符池
3. **延迟销毁**: 使用栅栏确保资源不再使用后再销毁

### 跨平台

1. **检查特性**: 使用 `vkGetPhysicalDeviceFeatures` 检查设备特性
2. **检查扩展**: 使用 `vkEnumerateDeviceExtensionProperties` 检查扩展支持
3. **回退路径**: 为不支持某些特性/扩展的设备提供替代实现

## 错误处理

### 返回码检查

每个 Vulkan 函数都返回 `VkResult`，必须检查：
```cpp
VkResult result = vkCreateDevice(...);
if (result != VK_SUCCESS) {
    // 处理错误
}
```

### 常见错误

- `VK_ERROR_OUT_OF_HOST_MEMORY`: 主机内存不足
- `VK_ERROR_OUT_OF_DEVICE_MEMORY`: 设备内存不足
- `VK_ERROR_INITIALIZATION_FAILED`: 初始化失败
- `VK_ERROR_DEVICE_LOST`: 设备丢失
- `VK_ERROR_LAYER_NOT_PRESENT`: 层不存在
- `VK_ERROR_EXTENSION_NOT_PRESENT`: 扩展不存在
- `VK_ERROR_FEATURE_NOT_PRESENT`: 特性不存在
- `VK_ERROR_INCOMPATIBLE_DRIVER`: 驱动不兼容

## 调试工具

### Vulkan SDK 工具

- **Vulkan Configurator**: 配置 Vulkan 环境变量
- **Vulkan Layer**: 各种验证和分析层
- **VKtrace**: 捕获和重放 Vulkan 调用

### 第三方工具

- **RenderDoc**: 图形调试器
- **NVIDIA Nsight**: NVIDIA 调试工具
- **AMD Radeon GPU Profiler**: AMD 性能分析器
- **Intel VTune Profiler**: Intel 性能分析器

## 版本历史

### Vulkan 1.3 (2022)

- 动态渲染
- 同步 2
- 增强的调试工具
- 改进的队列族

### Vulkan 1.2 (2020)

- 光线追踪基础
- 着色器子组操作
- 改进的内存模型
- 更好的多线程支持

### Vulkan 1.1 (2018)

- 子组操作
- 多视图
- 保护内存
- YCbCr 支持

### Vulkan 1.0 (2016)

- 初始发布
- 基础图形和计算 API
