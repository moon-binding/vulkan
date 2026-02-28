---
name: vulkan
description: 这个技能应该在用户询问 Vulkan 图形 API、Vulkan 开发、Vulkan 编程或图形渲染相关问题时使用。包括创建 Vulkan 应用程序、理解 Vulkan API、调试 Vulkan 程序、以及 Vulkan 扩展和新特性的使用等场景。
---

# Vulkan 图形 API 技能

## 概述

Vulkan 是一个低开销、跨平台的 3D 图形和计算 API。本技能提供完整的 Vulkan 开发支持，包括最新 API 文档、代码模板和最佳实践指南。Vulkan 规范和 API 更新频繁，本技能支持自动获取最新文档。

## 何时使用此技能

当用户提出以下类型的问题时，使用此技能：
- "如何使用 Vulkan 创建..."
- "Vulkan 中的 XXX API 怎么用"
- "Vulkan 实例/设备/Swapchain 的创建流程"
- "帮我写一个 Vulkan 渲染程序..."
- "Vulkan 最新的扩展有哪些"
- "Vulkan 错误调试/性能优化"
- "Vulkan 着色器编程"
- "Vulkan 同步和内存管理"

## 快速开始

### 更新 Vulkan 文档

Vulkan 定期发布新版本和扩展，建议在开始新项目前更新文档：

```bash
python3 .codebuddy/skills/vulkan/scripts/update_specs.py
```

这将从 Vulkan 官方 GitHub 仓库下载最新的规范和 API 文档。

仅检查最新版本：

```bash
python3 .codebuddy/skills/vulkan/scripts/update_specs.py --version-only
```

### 使用代码模板

查看可用的代码模板：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py list
```

显示特定模板：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py show --name instance_creation
```

保存模板到文件：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name graphics_pipeline --output graphics_pipeline.cpp
```

## 文档结构

本技能包含以下资源：

### scripts/

#### update_specs.py

自动从 Vulkan 官方 GitHub 仓库下载最新文档：
- API 注册表 (`api_registry.md`) - 包含所有 Vulkan API、常量和类型
- 规范文档 (`specification.md`) - Vulkan 规范的 Markdown 版本
- 扩展列表 (`extensions.md`) - 常用的 Vulkan 扩展说明

#### code_templates.py

提供常见 Vulkan 编程模式的代码模板：
- `instance_creation` - Vulkan 实例创建
- `physical_device_selection` - 物理设备选择
- `swapchain_creation` - Swapchain 创建
- `render_pass` - 渲染通道创建
- `graphics_pipeline` - 图形管线创建
- `command_buffer` - 命令缓冲区录制
- `shader_vertex` - 顶点着色器模板
- `shader_fragment` - 片段着色器模板

### references/

存储从官方源获取的最新参考文档：
- `api_registry.md` - 从 vk.xml 解析的 API 注册表
- `specification.md` - Vulkan 规范文档
- `extensions.md` - 常用的 Vulkan 扩展列表和说明

**注意**：这些文档需要使用 `update_specs.py` 脚本首次生成和定期更新。

## Vulkan 开发工作流程

### 步骤 1: 初始化 Vulkan

创建 Vulkan 应用程序的基本步骤：

1. 创建 VkInstance
2. 选择物理设备
3. 创建逻辑设备和队列
4. 创建表面（如果是渲染到窗口）

使用模板：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name instance_creation
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name physical_device_selection
```

### 步骤 2: 设置 Swapchain

创建用于呈现的 Swapchain：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name swapchain_creation
```

### 步骤 3: 创建图形管线

设置渲染通道和图形管线：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name render_pass
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name graphics_pipeline
```

### 步骤 4: 编写着色器

使用 GLSL 编写着色器：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name shader_vertex --output vert.vert
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name shader_fragment --output frag.frag
```

### 步骤 5: 录制命令和渲染

使用命令缓冲区记录渲染命令：

```bash
python3 .codebuddy/skills/vulkan/scripts/code_templates.py save --name command_buffer
```

## API 查询

### 查询特定 API

在 API 注册表中搜索：

```bash
grep -r "vkCreateInstance" .codebuddy/skills/vulkan/references/api_registry.md
grep -r "VkImage" .codebuddy/skills/vulkan/references/api_registry.md
```

### 查询常量和枚举

```bash
grep -r "VK_FORMAT_" .codebuddy/skills/vulkan/references/api_registry.md
grep -r "VK_PIPELINE_" .codebuddy/skills/vulkan/references/api_registry.md
```

### 查询扩展信息

```bash
grep "ray_tracing" .codebuddy/skills/vulkan/references/extensions.md
grep "VK_KHR_" .codebuddy/skills/vulkan/references/extensions.md
```

## 常见使用场景

### 场景 1: 创建基础 Vulkan 应用

**用户问题**："如何创建一个基础的 Vulkan 应用程序？"

**处理流程**：
1. 使用 `instance_creation` 模板创建实例
2. 使用 `physical_device_selection` 模板选择设备
3. 使用 `swapchain_creation` 模板创建 Swapchain
4. 使用 `render_pass` 和 `graphics_pipeline` 模板设置管线
5. 提供 `command_buffer` 模板用于渲染

### 场景 2: 查询新 API

**用户问题**："Vulkan 最新的光线追踪 API 是什么？"

**处理流程**：
1. 运行 `update_specs.py` 确保文档最新
2. 在 `extensions.md` 中搜索 "ray_tracing"
3. 在 `api_registry.md` 中搜索相关的函数和结构体
4. 提供用法说明和示例

### 场景 3: 调试 Vulkan 错误

**用户问题**："如何调试 Vulkan 应用程序？"

**处理流程**：
1. 查找 `extensions.md` 中的调试相关扩展
2. 解释 VK_LAYER_KHRONOS_validation 验证层的使用
3. 说明如何设置调试回调和消息输出

### 场景 4: 性能优化

**用户问题**："如何优化 Vulkan 应用的性能？"

**处理流程**：
1. 查询相关的同步和内存管理 API
2. 说明最佳实践（如使用持久映射、减少同步点等）
3. 提供性能分析工具建议（如 NVIDIA Nsight、RenderDoc）

## 最佳实践

### 保持文档最新

Vulkan 定期发布新版本（每 6 个月），建议：
- 在处理新的 Vulkan 版本前必须运行 `update_specs.py`
- 检查版本信息：`grep "Vulkan Version" .codebuddy/skills/vulkan/references/api_registry.md`
- 关注新扩展和废弃 API

### 使用代码模板

- 始终从模板开始，减少重复代码
- 根据项目需求修改模板
- 参考模板中的注释理解每个步骤

### 验证层和调试

- 开发时始终启用 VK_LAYER_KHRONOS_validation
- 使用 VK_EXT_debug_utils 设置对象名称和调试标记
- 集成 RenderDoc 进行图形调试

### 内存管理

- 显式管理 Vulkan 内存（使用 VMA 等库可简化）
- 理解内存类型和属性
- 避免频繁分配和释放

## 代码编译

### Vulkan SDK

安装 Vulkan SDK：
- Windows/Linux: 从 LunarG 下载 https://vulkan.lunarg.com/
- Linux: 通过包管理器安装（如 `apt install vulkan-sdk`）

### 编译示例

使用 CMake 构建：

```cmake
cmake_minimum_required(VERSION 3.10)
project(VulkanApp)

find_package(Vulkan REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} Vulkan::Vulkan)
```

## 相关资源

- Vulkan 官方网站: https://www.vulkan.org/
- Vulkan 规范: https://registry.khronos.org/vulkan/specs/1.3/html/
- Vulkan GitHub: https://github.com/KhronosGroup/Vulkan-Docs
- Vulkan Guide: https://github.com/KhronosGroup/Vulkan-Guide
- Vulkan Tutorial: https://vulkan-tutorial.com/

## 扩展阅读

### 同步原语

Vulkan 提供多种同步原语：
- VkFence - CPU-GPU 同步
- VkSemaphore - GPU-GPU 跨队列同步
- VkEvent - GPU 内部精细同步
- VkPipelineStageFlags - 管线阶段同步

### 内存布局

理解 Vulkan 内存布局对性能至关重要：
- 标准布局与优化布局
- 缓冲图像粒度
- 显存与共享内存

### 描述符

描述符系统管理着色器资源：
- VkDescriptorSetLayout - 描述符集布局
- VkDescriptorPool - 描述符池
- VkDescriptorSet - 描述符集
- VkDescriptorUpdateTemplate - 描述符更新模板
