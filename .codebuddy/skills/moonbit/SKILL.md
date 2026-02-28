---
name: moonbit
description: 这个技能应该在用户询问 MoonBit 编程语言、MoonBit API、MoonBit 语法或 MoonBit 项目开发时使用。包括编写 MoonBit 代码、调试 MoonBit 程序、解释 MoonBit 语法特性、以及 MoonBit 标准库的使用等场景。
---

# MoonBit Language Reference

@reference/index.md
@reference/introduction.md
@reference/fundamentals.md
@reference/methods.md
@reference/derive.md
@reference/error-handling.md
@reference/packages.md
@reference/tests.md
@reference/benchmarks.md
@reference/docs.md
@reference/attributes.md
@reference/ffi.md
@reference/async-experimental.md

## Official Packages

MoonBit has official packages maintained by the team:

- **moonbitlang/x**: Utilities including file I/O (`moonbitlang/x/fs`)
- **moonbitlang/async**: Asynchronous runtime with TCP, HTTP, async queues, async test, and async main

To use these packages:
1. Add the dependency: `moon add moonbitlang/x` or `moon add moonbitlang/async`
2. Import the specific subpackage in `moon.pkg.json`:
```json
{"import": ["moonbitlang/x/fs"]}
```

## Common Pitfalls

- Use `suberror` for error types, `raise` to throw, `try! func() |> ignore` to ignore errors
- Use `func() |> ignore` not `let _ = func()`
- When using `inspect(value, content=expected_string)`, don't declare a separate `let expected = ...` variable - it causes unused variable warnings. Put the expected string directly in the `content=` parameter
- Use `!condition` not `not(condition)`
- Use `f(value)` not `f!(value)` (deprecated)
- Use `for i in 0..<10 { ... }` for loops, not `for i in 0..10` when you want exclusive upper bound
- Use `while i > 0 { arr.pop() }` not `while i > 0 { arr.pop() }`
- Use `s.code_unit_at(i)` or `for c in s` not `s[i]` (deprecated)
- Struct/enum visibility: `priv` (hidden) < (none)/abstract (type only) < `pub` (readonly) < `pub(all)` (full)
- Default to abstract (no modifier) for internal types; use `pub struct` when external code reads fields
- Use `pub(all) enum` for enums that external code pattern-matches on
- Use `let mut` only for reassignment, not for mutable containers like Array
- Use `reinterpret_as_uint()` for unsigned ops, `to_int()` for numeric conversion
- Use `Array::length()` not `Array::size()`
- In moon.pkg.json, use "import", "test-import" and "wbtest-import" to manage package importing for ".mbt", "_test.mbt" and "_wbtest.mbt"
- Use `Option::unwrap_or` not `Option::or`

## FFI Quick Reference

### Native/C Backend FFI

```moonbit
// Declare external function with C linkage
extern "C" fn function_name(param : Type) -> ReturnType = "c_function_name"

// With borrow annotation (no ownership transfer)
#borrow(param1, param2)
extern "C" fn read_data(param1 : Bytes, param2 : Int) -> Int = "c_read_data"

// Declare external type
#external type ExternalHandle

// Create external object with finalizer (C side)
// void *moonbit_make_external_object(void (*finalize)(void*), uint32_t size);
```

### Native Backend Build

```bash
# Build for native target
moon build --target native

# The output C code will be in _build/native/debug/build/
# Link manually with C libraries
```

### moon.pkg.json for Native FFI

```json
{
  "import": ["moonbitlang/core/builtin"],
  "link": {
    "native": {
      "cc-link-flags": "-lmylib"
    }
  },
  "native-stub": [
    "my_bridge.c"
  ]
}
```

## Build System Quick Reference

```bash
# Create new project
moon new <project_name> --user <username> --name <package_name>

# Build project
moon build                    # default target (wasm-gc)
moon build --target native    # native backend
moon build --target js        # JavaScript backend
moon build --target wasm      # WebAssembly MVP

# Run tests
moon test
moon test --target native

# Check without building
moon check --target native

# Add dependencies
moon add <package>
```

## Standard Library APIs

- String: https://mooncakes.io/docs/moonbitlang/core/string
- Array: https://mooncakes.io/docs/moonbitlang/core/array
- Map: https://mooncakes.io/docs/moonbitlang/core/builtin#Map
- Option: https://mooncakes.io/docs/moonbitlang/core/option
- Result: https://mooncakes.io/docs/moonbitlang/core/result
- JSON: https://mooncakes.io/docs/moonbitlang/core/json
- Bytes: https://mooncakes.io/docs/moonbitlang/core/bytes
- Char: https://mooncakes.io/docs/moonbitlang/core/char
- Buffer: https://mooncakes.io/docs/moonbitlang/core/buffer
