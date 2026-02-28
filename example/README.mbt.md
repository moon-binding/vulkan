# MoonBit Native Vulkan Triangle

这是一个使用 MoonBit 语言编写的原生 Vulkan 三角形渲染演示程序。

## 项目概述

本项目演示了如何：

1. 使用 MoonBit 的 native 后端编译为原生可执行文件
2. 通过 C FFI 绑定 Vulkan 图形 API
3. 使用 GLFW 创建窗口并管理输入
4. 渲染一个彩色渐变三角形

## 系统要求

### 必需的依赖

1. **MoonBit 工具链** - 从 [moonbitlang.com](https://www.moonbitlang.com) 安装
2. **Vulkan SDK 或开发包** - 图形渲染 API
3. **GLFW 3** - 窗口管理和输入处理
4. **GCC 或 Clang** - C 编译器

### 安装依赖

#### Ubuntu/Debian

```bash
# 安装 Vulkan 开发包和工具
sudo apt update
sudo apt install libvulkan-dev vulkan-tools

# 安装 GLFW
sudo apt install libglfw3-dev

# 验证 Vulkan 安装
vulkaninfo | head -20
```

#### Fedora

```bash
sudo dnf install vulkan-loader-devel vulkan-tools glfw-devel
```

#### Arch Linux

```bash
sudo pacman -S vulkan-headers vulkan-tools glfw
```

#### 其他 Linux 发行版

从 [Vulkan SDK 官网](https://vulkan.lunarg.com/) 下载并安装完整的 Vulkan SDK。

## 项目结构

```
moonbit-native-vulkan/
├── main.mbt                 # 主程序入口
├── vulkan_demo.mbt          # MoonBit FFI 绑定声明
├── vulkan_bridge.c          # C Vulkan 桥接代码
├── shaders_spv.h            # 嵌入的 SPIR-V 着色器
├── moon.mod.json            # MoonBit 模块配置
└── moon.pkg.json            # 包配置
```

## 构建

```bash
cd moonbit-native-vulkan
moon build --target native
```

构建成功后，可执行文件将生成在 `_build/native/debug/bin/triangle`。

## 运行

```bash
./_build/native/debug/bin/triangle
```

## 技术细节

### MoonBit C FFI 语法

```moonbit
// 声明外部 C 函数
pub extern "C" fn function_name(param : Type) -> ReturnType = "c_function_name"
```

### 渲染的三角形

- 顶点 1: (0.0, -0.5) - 红色（底部）
- 顶点 2: (0.5, 0.5) - 绿色（右上）
- 顶点 3: (-0.5, 0.5) - 蓝色（左上）

三角形将显示从底部红色到右上绿色再到左上蓝色的渐变效果。

## Vulkan 渲染流程

1. 创建 Vulkan 实例
2. 选择物理设备（GPU）
3. 创建逻辑设备和队列
4. 创建窗口表面
5. 创建交换链
6. 创建图像视图
7. 创建渲染通道
8. 创建图形管线
9. 创建帧缓冲
10. 创建命令缓冲池和缓冲区
11. 创建同步对象
12. 渲染循环
13. 清理资源

## 故障排除

### "Vulkan headers not found"

确保已安装 Vulkan 开发包。运行 `vulkaninfo` 验证 Vulkan 是否正确安装。

### "GLFW not found"

安装 GLFW 开发包：
- Ubuntu: `sudo apt install libglfw3-dev`
- Fedora: `sudo dnf install glfw-devel`
- Arch: `sudo pacman -S glfw`

### "Failed to find GPUs with Vulkan support"

确保您的 GPU 支持 Vulkan，并且已安装正确的图形驱动程序。

### 编译错误

1. 确保 MoonBit 工具链已正确安装：`moon version`
2. 清理并重新构建：`rm -rf _build && moon build --target native`

## 许可证

Apache-2.0
