# 使用包管理项目

## 模块配置 (moon.mod.json)

```json
{
  "name": "username/package_name",
  "version": "0.1.0",
  "deps": {
    "moonbitlang/x": "0.4.0"
  },
  "source": "src"
}
```

## 包配置 (moon.pkg.json)

```json
{
  "import": [
    "moonbitlang/core/builtin",
    "moonbitlang/core/coverage"
  ],
  "test-import": [
    "moonbitlang/core/random"
  ],
  "wbtest-import": [
    "moonbitlang/core/quickcheck"
  ],
  "is-main": true,
  "link": {
    "native": {
      "cc-link-flags": "-lmylib"
    },
    "wasm-gc": {
      "exports": ["my_function"]
    }
  },
  "native-stub": [
    "my_bridge.c"
  ]
}
```

## 包可见性

- `priv`: 完全隐藏
- 无修饰符/`abstract`: 类型可见，内部隐藏
- `pub`: 只读访问
- `pub(all)`: 完全可访问

```moonbit
priv struct Internal { ... }      // 仅包内可见
struct SemiPrivate { ... }        // 类型可见，字段隐藏
pub struct Public { ... }         // 字段只读
pub(all) struct Open { ... }      // 完全开放

pub(all) enum MyEnum { A, B(Int) }  // 枚举通常用 pub(all)
```

## 使用外部包

1. 添加依赖：

```bash
moon add moonbitlang/x
```

2. 在 `moon.pkg.json` 中导入：

```json
{
  "import": ["moonbitlang/x/fs"]
}
```

3. 在代码中使用别名：

```moonbit
// 使用默认别名
fn read_file() -> Unit {
  let content = @fs.read_file_sync("test.txt")
  ...
}

// 指定别名
{
  "import": [
    { "path": "moonbitlang/x/fs", "alias": "filesystem" }
  ]
}

fn read_file() -> Unit {
  let content = @filesystem.read_file_sync("test.txt")
  ...
}
```

## 项目结构

```
my_project/
├── moon.mod.json       # 模块配置
├── moon.pkg.json       # 根包配置
├── src/
│   ├── main.mbt        # 主程序
│   ├── lib.mbt         # 库代码
│   ├── lib_test.mbt    # 测试（moon test）
│   ├── lib_wbtest.mbt  # 白盒测试（moon test --wasm-gc）
│   └── subpackage/
│       ├── moon.pkg.json
│       └── code.mbt
└── cmd/
    └── main/
        ├── moon.pkg.json  # { "is-main": true }
        └── main.mbt
```

## 构建命令

```bash
# 创建新项目
moon new my_project --user myuser --name mylib

# 构建
moon build                     # 默认 wasm-gc 后端
moon build --target native     # native 后端
moon build --target js         # JavaScript 后端
moon build --target wasm       # WebAssembly MVP

# 测试
moon test
moon test --target native
moon test --update             # 更新测试快照

# 检查
moon check --target native

# 运行
moon run --target native
```

## 导出函数

在 `moon.pkg.json` 中配置：

```json
{
  "link": {
    "wasm-gc": {
      "exports": ["add", "fib:test"]
    },
    "js": {
      "exports": ["add"],
      "format": "esm"
    }
  }
}
```

`"fib:test"` 表示导出函数 `fib`，外部名称为 `test`。
