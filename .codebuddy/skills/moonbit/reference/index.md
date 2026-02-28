# MoonBit 语言文档索引

MoonBit 是一个用于云和边缘计算的 AI 原生编程语言工具链。它可以编译为 WebAssembly、JavaScript 和 C 代码。

## 状态

MoonBit 目前处于 beta-preview 阶段。我们预计在 2025 年达到 1.0 版本。

## 主要优势

- 生成比现有解决方案明显更小的 Wasm 文件
- 更高的运行时性能
- 先进的编译时性能
- 简单且实用的数据导向语言设计

## 后端

MoonBit 目前有五个后端：

- Wasm
- Wasm GC
- JavaScript
- C
- LLVM（实验性）

## 文档目录

- [介绍](introduction.md) - 程序结构、变量绑定、入口点
- [基础](fundamentals.md) - 数据结构、函数、控制流、模式匹配
- [方法和特征](methods.md) - 方法系统、特征、运算符重载
- [派生](derive.md) - 自动派生内建特征
- [错误处理](error-handling.md) - 错误类型、抛出和处理错误
- [包管理](packages.md) - 模块和包系统
- [测试](tests.md) - 编写测试
- [基准测试](benchmarks.md) - 编写基准测试
- [文档](docs.md) - 编写文档注释
- [属性](attributes.md) - 函数和类型属性
- [FFI](ffi.md) - 外部函数接口
- [异步编程](async-experimental.md) - 异步支持（实验性）

## 快速开始

无需安装即可在 https://try.moonbitlang.cn 上使用 IDE 环境。
