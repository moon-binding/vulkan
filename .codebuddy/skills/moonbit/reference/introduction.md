---
MoonBit Documentation: Introduction
Source URL: https://docs.moonbitlang.cn/language/introduction.html
Last Updated: 2026-02-28 09:08:52
---


介绍 &#8212; MoonBit 月兔 v0.7.1 文档

-

[Skip to main content](#main-content)

Back to top

Ctrl+K

[

MoonBit 月兔

](../index.html)

[

Show source
](https://github.com/moonbitlang/moonbit-docs/blob/main/next/language/introduction.md?plain=1)

- [

Suggest edit
](https://github.com/moonbitlang/moonbit-docs/edit/main/next/language/introduction.md)

- [

Open issue
](https://github.com/moonbitlang/moonbit-docs/issues/new?title=Issue%20on%20page%20%2Flanguage/introduction.html&body=Your%20issue%20content%20here.)

- [

.md
](../_sources/language/introduction.md)

-

.pdf

# 介绍

##  目录

# 介绍[#](#introduction)

一个 MoonBit 程序由顶层定义组成，包括：

- 类型定义

- 函数定义

- 常数定义和变量绑定

- `init` 函数，`main` 函数和/或 `test` 块。

## 表达式和语句[#](#expressions-and-statements)

MoonBit 区分语句和表达式。在函数体中，只有最后一个子句应该是一个表达式，它作为返回值。例如：

fn foo() -> Int {
let x = 1
x + 1
}

fn bar() -> Int {
let x = 1
//! x + 1
x + 2
}

表达式包括：

- 值字面量（例如布尔值、数字、字符、字符串、数组、元组、结构体）

- 算术、逻辑或比较操作

- 访问数组元素（例如 `a[0]`），结构体字段（例如 `r.x`），元组组件（例如 `t.0`）等

- 变量和枚举构造器

- 匿名本地函数定义

- `match`，`if`，`loop` 表达式等。

语句包括：

- 命名本地函数定义

- 本地变量绑定

- 赋值

- `return` 语句

- 任何返回类型为 `Unit` 的表达式（例如 `ignore`）

代码块可以包含多个语句和一个表达式，表达式的值是代码块的值。

## 变量绑定[#](#variable-binding)

变量可以使用 `let mut` 或 `let` 声明为可变或不可变。可变变量可以重新赋值为新值，而不可变变量则不能。

常量只能在顶层声明，不能更改。

let zero = 0

const ZERO = 0

fn main {
//! const ZERO = 0
let mut i = 10
i = 20
println(i + zero + ZERO)
}

备注

顶层变量绑定

- 需要 **显式** 类型注释（除非使用字符串、字节或数字等字面量定义）

- 不能是可变的（使用 `Ref` 代替）

## 命名约定[#](#naming-conventions)

变量、函数应以小写字母 `a-z` 开头，可以包含字母、数字、下划线和其他非 ASCII 的 Unicode 字符。建议使用 snake_case 命名。

常量、类型应以大写字母 `A-Z` 开头，可以包含字母、数字、下划线和其他非 ASCII 的 Unicode 字符。建议使用 PascalCase 或 SCREAMING_SNAKE_CASE 命名。

### 关键字[#](#keywords)

以下是关键字，不应使用：

[
"as", "else", "extern", "fn", "fnalias", "if", "let", "const", "match", "using",
"mut", "type", "typealias", "struct", "enum", "trait", "traitalias", "derive",
"while", "break", "continue", "import", "return", "throw", "raise", "try", "catch",
"pub", "priv", "readonly", "true", "false", "_", "test", "loop", "for", "in", "impl",
"with", "guard", "async", "is", "suberror", "and", "letrec", "enumview", "noraise",
"defer",
]

### 保留关键字[#](#reserved-keywords)

以下是保留关键字。使用它们会引入警告。它们可能在将来变成关键字。

[
"module", "move", "ref", "static", "super", "unsafe", "use", "where", "await",
"dyn", "abstract", "do", "final", "macro", "override", "typeof", "virtual", "yield",
"local", "method", "alias", "assert", "package", "recur", "using", "enumview",
"isnot", "define", "downcast", "inherit", "member", "namespace", "static", "upcast",
"use", "void", "lazy", "include", "mixin", "protected", "sealed", "constructor",
"atomic", "volatile", "anyframe", "anytype", "asm", "await", "comptime", "errdefer",
"export", "opaque", "orelse", "resume", "threadlocal", "unreachable", "dynclass",
"dynobj", "dynrec", "var", "finally", "noasync",
]

## 程序入口[#](#program-entrance)

### `init` 和 `main`[#](#init-and-main)

有一个专门的函数称为 `init` 函数。`init` 函数是特殊的：

- 它没有参数列表也没有返回类型。

- 同一个包中可以有多个 `init` 函数。

- `init` 函数不能被显式调用或被其他函数引用。相反，所有 `init` 函数将在初始化包时隐式调用。因此，`init` 函数应该只包含语句。

fn init {
let x = 1
println(x)
}

还有另一个专门的函数称为 `main` 函数。`main` 函数是程序的主入口，它将在初始化阶段之后执行。

与 `init` 函数相同，它没有参数列表也没有返回类型。

fn main {
let x = 2
println(x)
}

前两个代码片段将在运行时打印以下内容：

1
2

只有 `main` 包的包才能定义这样的 `main` 函数。查看 [构建系统教程](../toolchain/moon/tutorial.html) 了解详情。

moon.pkg.json[#](#id1)
{
"is-main": true
}

### `test`[#](#test)

还有一个称为 `test` 块的顶级结构。`test` 块定义内联测试，例如：

test "test_name" {
assert_eq(1 + 1, 2)
assert_eq(2 + 2, 4)
inspect([1, 2, 3], content="[1, 2, 3]")
}

以下内容将使用 `test` 块和 `main` 函数来演示执行结果。我们假设所有 `test` 块都通过测试，除非另有说明。

目录
