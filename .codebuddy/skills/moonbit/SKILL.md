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

## Toolchain Commands Reference

### Project Management

```bash
# Create new module
moon new <path> [--user <username>] [--name <module_name>]

# Install dependencies
moon install

# Display dependency tree
moon tree

# Update package registry index
moon update
```

### Build Commands

```bash
# Build current package
moon build [OPTIONS]
  --target <backend>     # wasm, wasm-gc, js, native, llvm, all
  -g, --debug           # Emit debug information
  --release              # Compile in release mode
  --strip               # Enable stripping debug information
  --enable-coverage     # Enable coverage instrumentation
  -d, --deny-warn       # Treat all warnings as errors
  -j, --jobs <n>        # Set max number of parallel jobs
  -w, --watch           # Monitor file system and auto-build

# Check without building object files
moon check [OPTIONS] [SINGLE_FILE]
  --target <backend>    # wasm, wasm-gc, js, native, llvm, all
  --output-json         # Output in JSON format
  --explain             # Explain error codes with details

# Run a main package
moon run [OPTIONS] [ARGS]...
  --target <backend>    # wasm, wasm-gc, js, native, llvm, all
  --build-only          # Only build, do not run

# Clean build artifacts
moon clean
```

### Testing

```bash
# Run tests
moon test [OPTIONS] [SINGLE_FILE]
  --target <backend>    # wasm, wasm-gc, js, native, llvm, all
  -p <package>          # Run test in specified package
  -f <file>             # Run test in specified file
  -i <index>            # Run only index-th test
  --doc-index <index>   # Run only index-th doc test
  -u, --update          # Update test snapshot
  --enable-coverage     # Enable coverage instrumentation
  --doc                 # Run doc test

# Run benchmarks
moon bench [OPTIONS]
  -p <package>          # Run bench in specified package
  -f <file>             # Run bench in specified file
```

### Code Coverage

```bash
# Analyze coverage (run tests with instrumentation)
moon coverage analyze [-p <package>]

# Generate coverage report
moon coverage report [-f <format>]
  -f summary           # Text summary (default)
  -f bisect            # OCaml Bisect format
  -f coveralls         # Coveralls JSON format
  -f cobertura          # Cobertura XML format
  -f html              # HTML pages (output to _coverage/)

# Clean coverage artifacts
moon coverage clean
```

### Code Formatting

```bash
# Format source code
moon fmt [OPTIONS] [PATH]...
  --check               # Check only, don't change source code
  --sort-input          # Sort input files
  --block-style <bool>  # Add separator between segments

# Convert moon.pkg.json to moon.pkg format
moon fmt -C
```

### Documentation

```bash
# Generate documentation
moon doc [OPTIONS]
  --serve               # Start a web server
  -b, --bind <addr>     # Server address (default: 127.0.0.1)
  -p, --port <port>     # Server port (default: 3000)

# Generate public interface (.mbti) files
moon info [OPTIONS]
  --target <backend>   # wasm, wasm-gc, js, native, llvm, all
  -p <package>          # Emit mbti files for specified package only
```

### Dependency Management

```bash
# Add dependency
moon add <package> [--bin]

# Remove dependency
moon remove <package>

# Manage packages on mooncakes.io
moon login              # Log in to account
moon register           # Register at mooncakes.io
moon publish            # Publish current module
moon package [--list]   # Package current module
```

### Toolchain Management

```bash
# Upgrade toolchains
moon upgrade [OPTIONS]
  -f, --force           # Force upgrade
  --dev                 # Install latest development version

# Generate shell completion
moon shell-completion [--shell <shell>]
  --shell bash|elvish|fish|powershell|zsh

# Display version information
moon version
  --all                 # Print all version information
  --json                # Print in JSON format
```

### Moon IDE Commands (Code Navigation)

```bash
# Peek at symbol definition
moon ide peek-def [-loc filename:line[:col]] <symbol>
  -loc <location>        # Contextual search at location
  <symbol>              # Symbol name: [@pkg.]symbol or [@pkg.]Type::member

# Find all references to a symbol
moon ide find-references <symbol>

# Outline file or package structure
moon ide outline <path>
  <path>                # File or directory path

# Query documentation and APIs
moon ide doc '<query>'
  ''                    # List packages or symbols
  '[@pkg.]symbol'       # Find specific function or value
  '[@pkg.]Type'         # Find type
  '[@pkg.]Type::member' # Find type methods or fields
  '@pkg'                # List all exported symbols in package
  '*pattern*'           # Glob wildcard search
```

## Module Configuration (moon.mod.json)

```json
{
  "name": "username/my_module",
  "version": "0.1.0",
  "deps": {
    "moonbitlang/core": "latest",
    "local_package": {
      "path": "../local_package"
    }
  },
  "source": "src",
  "readme": "README.md",
  "repository": "https://github.com/user/repo",
  "license": "MIT",
  "keywords": ["example", "demo"],
  "description": "Module description",
  "preferred-target": "wasm-gc",
  "warn-list": "-2-4",
  "alert-list": "-alert_1-alert_2",
  "exclude": ["build", "*.tmp"],
  "include": ["build/assets"],
  "scripts": {
    "postadd": "python3 build.py"
  }
}
```

## Package Configuration (moon.pkg / moon.pkg.json)

### Legacy Format (moon.pkg.json)

```json
{
  "is-main": true,
  "import": [
    {
      "path": "username/package",
      "alias": "pkg"
    }
  ],
  "test-import": [
    {"path": "test_package"}
  ],
  "wbtest-import": [
    {"path": "test_package"}
  ],
  "link": {
    "wasm": {
      "exports": ["function_name", "exported_name:local_name"],
      "import-memory": {"module": "env", "name": "memory"},
      "export-memory-name": "memory",
      "heap-start-address": 1024
    },
    "wasm-gc": {
      "exports": ["function_name"],
      "use-js-builtin-string": true,
      "imported-string-constants": "_"
    },
    "js": {
      "exports": ["function_name"],
      "format": "esm"  // esm, cjs, iife
    },
    "native": {
      "cc": "/usr/bin/gcc13",
      "cc-flags": "-DMOONBIT",
      "cc-link-flags": "-s"
    }
  },
  "targets": {
    "only_js.mbt": ["js"],
    "only_wasm_gc.mbt": ["wasm-gc"],
    "only_debug.mbt": ["debug"],
    "js_and_release.mbt": ["and", ["js"], ["release"]],
    "not_js.mbt": ["not", ["js"]]
  },
  "pre-build": [
    {
      "input": "a.txt",
      "output": "a.mbt",
      "command": ":embed -i $input -o $output"
    }
  ],
  "warn-list": "-unused_value-unreachable_code"
}
```

### New Format (moon.pkg)

```moonbit
import {
  "username/package",
  "other/package" @alias,
}

for "test" {
  "test_package"
}

for "wbtest" {
  "wbtest_package"
}

options(
  "is-main": true,
  link: {
    "js": {
      exports: ["function_name"],
      format: "esm"
    }
  },
  targets: {
    "only_js.mbt": ["js"],
    "only_wasm_gc.mbt": ["wasm-gc"]
  }
)

warnings = "-unused_value"
```

Convert between formats:
```bash
# Convert moon.pkg.json to moon.pkg
moon fmt -C

# Convert moon.pkg to moon.pkg.json
moon fmt
```

## Virtual Packages

Virtual packages serve as interfaces that can be replaced by actual implementations.

### Declare Virtual Package (moon.pkg.json)

```json
{
  "virtual": {
    "has-default": true
  }
}
```

### Implement Virtual Package

```json
{
  "implement": "moonbitlang/core/abort"
}
```

### Override Implementations

```json
{
  "overrides": [
    "moonbitlang/dummy_abort/abort_show_msg"
  ]
}
```

## Warning Numbers Reference

Common warnings to control:
- `1`: Unused function
- `2`: Unused variable
- `3`: Unused type declaration
- `4`: Unused abstract type
- `5`: Unused type variable
- `6`: Unused constructor
- `7`: Unused field or constructor argument
- `8`: Redundant modifier
- `11`: Partial pattern matching
- `12`: Unreachable code
- `15`: Unused mutability
- `20`: Deprecated API usage
- `31`: Optional argument never supplied
- `32`: Default value of optional argument never used
- `38`: Missing guard in loop

View all warnings: `moonc build-package -warn-help`

## WebAssembly Integration

### Component Model Tutorial

MoonBit provides first-class support for WebAssembly and the Component Model.

#### Prerequisites

```bash
# Install MoonBit (see https://www.moonbitlang.com/download)

# Install Wasm toolchain
cargo install wit-bindgen-cli
cargo install wasm-tools
```

#### Steps

1. Define interface using WIT:
```wit
package docs:adder@0.1.0;

interface add {
  add: func(x: u32, y: u32) -> u32;
}

world adder {
  export add;
}
```

2. Generate MoonBit bindings:
```bash
wit-bindgen moonbit wit/world.wit --out-dir . \
  --derive-eq --derive-show --derive-error
```

3. Implement the component logic in `gen/interface/docs/adder/add/stub.mbt`

4. Build WebAssembly component:
```bash
moon build --target wasm
wasm-tools component embed wit _build/wasm/release/build/gen/gen.wasm \
  --encoding utf16 --output adder.wasm
wasm-tools component new adder.wasm --output adder.component.wasm
```

5. Test component:
```bash
wasmtime run --invoke 'add(10, 20)' adder.component.wasm
```

## VSCode Plugin

The MoonBit VSCode plugin provides:

### Commands (via Command Palette)
- **Select backend**: Switch between backends
- **Restart MoonBit language server**: Restart LSP
- **Install MoonBit toolchain**: Trigger installation
- **Get lsp's compiler version**: Display compiler version
- **Toggle multiline string**: Switch plain text to multiline string syntax

### Actions (Quick Fix)
- **Add missing arms**: Fill branches of `match` expression (Error 0011)

### Code Lens (per test block)
- **Format**: Format the code block
- **Test / Bench**: Run test or benchmark
- **Debug** (JavaScript only): Debug with debugger
- **Update**: Update snapshot tests
- **Trace**: Toggle tracing (render values next to assignments)
