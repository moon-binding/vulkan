# MoonBit Vulkan 绑定生成器

通过解析 C/C++ 头文件自动生成 MoonBit Vulkan 绑定库的项目。

## 背景

Vulkan API 非常庞大（包含数百个函数、结构体、枚举和常量），手动编写和维护绑定既耗时又容易出错。本项目旨在通过解析 Vulkan 官方头文件，自动化生成 MoonBit 绑定。

## 技术方案

### 方案选择

经过评估，**不使用 fastcc** 进行头文件解析，原因：
1. **fastcc 是 C 编译器**：主要功能是编译 C 代码，虽然有解析能力，但不是专门为生成绑定设计的
2. **Vulkan 使用 XML 注册表**：Khronos 官方使用 XML 文件（vk.xml）作为 API 的权威来源，C 头文件也是从 XML 生成的
3. **XML 更结构化**：直接解析 XML 比解析预处理后的 C 代码更准确、更容易

### 最终方案：解析 XML 注册表

使用 Vulkan 官方的 XML 注册表（`vk.xml`）作为数据源：

```
vk.xml (API 权限源)
    ↓
解析器 (MoonBit)
    ↓
生成 MoonBit 绑定代码
    ↓
输出：类型定义、枚举、结构体、函数声明
```

**优势**：
- XML 结构清晰，包含完整的 API 元数据
- 包含版本信息、扩展信息、平台标记
- 避免 C 预处理器宏展开的复杂性
- 可以精确控制生成哪些 API

## 实现计划

### 阶段 0：最小可行性验证（当前阶段）

**目标**：验证整个流程可行，先绑定少量 API 并通过测试

**范围**：仅绑定最基本的 Vulkan API
- 1-2 个最常用的函数（如 `vkCreateInstance`、`vkEnumeratePhysicalDevices`）
- 最少必要的数据类型（`VkInstance`、`VkPhysicalDevice`、`VkResult`）
- 1-2 个简单的结构体（如 `VkInstanceCreateInfo`）

**步骤**：
1. 解析 `vk.xml` 中定义的最小 API 集合
2. 生成对应的 MoonBit 绑定代码
3. 编写测试程序验证绑定正确性
4. 调试并修复问题

**成功标准**：
- 测试程序能成功调用绑定的 Vulkan API
- 生成的代码能正常编译和运行

### 阶段 1：XML 解析器实现

- 解析 `vk.xml` 结构
- 提取类型定义、枚举、结构体、函数声明
- 处理版本和扩展标记
- 平台特定代码的条件编译

### 阶段 2：代码生成器

- 类型映射（C 类型 → MoonBit 类型）
- 函数签名生成（包含参数类型、返回值）
- 结构体定义生成（包含字段布局）
- 常量和枚举生成

### 阶段 3：扩展和优化

- 支持按模块/功能生成（如只生成图形相关 API）
- 添加文档注释
- 生成单元测试模板
- 性能优化

## 项目结构

```
vulkan/
├── parser/                 # XML 解析器
│   ├── xml_parser.mbt      # XML 解析逻辑
│   └── vk_model.mbt        # Vulkan API 数据模型
├── generator/              # 代码生成器
│   ├── type_mapper.mbt    # 类型映射
│   ├── moonbit_gen.mbt    # MoonBit 代码生成
│   └── templates/         # 代码模板
├── target/                 # 生成的绑定代码
│   ├── vulkan.mbt         # 主包
│   ├── types.mbt          # 类型定义
│   ├── enums.mbt          # 枚举
│   ├── structs.mbt        # 结构体
│   └── commands.mbt       # 函数声明
├── tests/                  # 测试
│   └── basic_test.mbt     # 基础测试
└── xml/                    # Vulkan XML
    └── vk.xml             # Vulkan API 注册表
```

## 开发环境

- MoonBit: latest
- Vulkan SDK: 1.4.321.1
- 测试环境: Linux x86_64

## 参考资料

- [Vulkan Registry](https://github.com/KhronosGroup/Vulkan-Docs)
- [Vulkan XML Schema](https://github.com/KhronosGroup/Vulkan-Docs/blob/main/xml/vk.xml)
- [MoonBit FFI 文档](https://moonbitlang.com/docs/ffi)

## 状态

**当前阶段**：最小可行性验证

✅ 创建分支和项目结构
✅ 创建 XML 解析器框架
✅ 创建 Vulkan 数据模型
✅ 创建代码生成器框架
✅ 实现最小 API 绑定示例
✅ 创建 C 桥接层示例
✅ 创建基础测试程序
🔄 测试和验证整个流程
⏳ 完整解析器实现
⏳ 代码生成器完善
⏳ 完整 API 绑定生成

### 已创建的文件

#### 解析器 (parser/)
- `xml_parser.mbt` - 简单的 XML 解析器
- `vk_model.mbt` - Vulkan API 数据模型定义
- `vk_parser.mbt` - XML 到模型的转换器
- `moon.mod.json` - MoonBit 模块配置

#### 生成器 (generator/)
- `moonbit_gen.mbt` - MoonBit 代码生成器
- `main.mbt` - 生成器主程序
- `moon.mod.json` - MoonBit 模块配置

#### 目标绑定 (target/)
- `vulkan.mbt` - 生成的 Vulkan 绑定（最小子集）
- `vulkan_bridge.c` - C 桥接层（简化接口）
- `moon.mod.json` - MoonBit 模块配置

#### 测试 (tests/)
- `basic_test.mbt` - 基础测试程序
- `moon.mod.json` - MoonBit 模块配置

### 下一步

1. 编译并运行测试程序
2. 调试并修复任何编译错误
3. 验证结构体创建和枚举值
4. 完善解析器以处理更复杂的 XML 结构
5. 扩展绑定的 API 范围

## License

MIT
