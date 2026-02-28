# 外部函数接口 (FFI)

MoonBit 支持与 C、JavaScript 和 WebAssembly 交互的 FFI。

## 后端

- Wasm / Wasm GC
- JavaScript
- C / Native
- LLVM（实验性，不支持 FFI）

## 声明外部类型

```moonbit
#external type ExternalRef
```

- Wasm: 解释为 `externref`
- JavaScript: 解释为 JavaScript 值
- C: 解释为 `void*`

## 声明外部函数

### C 后端

```moonbit
extern "C" fn put_char(ch : UInt) = "function_name"

// 带返回值
extern "C" fn get_value() -> Int = "get_value"
```

链接外部库（moon.pkg.json）：

```json
{
  "link": {
    "native": {
      "cc-link-flags": "-lmylib"
    }
  },
  "native-stub": ["bridge.c"]
}
```

### JavaScript 后端

```moonbit
// 导入函数
fn cos(d : Double) -> Double = "Math" "cos"

// 内联函数
extern "js" fn cos(d : Double) -> Double =
  #|(d) => Math.cos(d)
```

### Wasm 后端

```moonbit
// 导入函数
fn cos(d : Double) -> Double = "math" "cos"

// 内联 Wasm
extern "wasm" fn identity(d : Double) -> Double =
  #|(func (param f64) (result f64))
```

## 类型映射

### C 后端

| MoonBit 类型 | C 类型 |
|-------------|--------|
| Bool | int32_t |
| Int | int32_t |
| UInt | uint32_t |
| Int64 | int64_t |
| UInt64 | uint64_t |
| Float | float |
| Double | double |
| String | moonbit_string_t |
| Bytes | uint8_t* |
| FixedArray[T] | T* |
| FuncRef[T] | 函数指针 |
| #external type T | void* |

## 回调

传递 MoonBit 函数给 C：

```moonbit
extern "C" fn register_callback_ffi(
  call_closure : FuncRef[(() -> Unit) -> Unit],
  closure : () -> Unit
) = "register_callback"

fn register_callback(callback : () -> Unit) -> Unit {
  register_callback_ffi(
    fn (f) { f() },
    callback
  )
}
```

## 生命周期管理

### 外部对象

使用 `moonbit_make_external_object`：

```c
#include "moonbit.h"

void* create_external(void (*finalize)(void*), uint32_t size);
```

### 引用计数

在 C 中管理 MoonBit 对象：

```c
// 增加引用计数
moonbit_incref(obj);

// 减少引用计数
moonbit_decref(obj);
```

### borrow 和 owned 标记

```moonbit
// borrow: 不获取所有权，不需要 decref
#borrow(filename)
extern "C" fn open(filename : Bytes, flags : Int) -> Int = "open"

// owned: 获取所有权，需要手动管理
extern "C" fn store(data : Bytes) -> Unit = "store_data"
```

## C 胶水文件

```c
// bridge.c
#include "moonbit.h"

// 创建外部对象示例
typedef struct {
  int value;
} MyExternal;

void my_external_finalize(void* self) {
  // 清理资源，不要 free(self)
}

moonbit_external_t my_external_new(int value) {
  MyExternal* obj = moonbit_make_external_object(
    my_external_finalize,
    sizeof(MyExternal)
  );
  obj->value = value;
  return obj;
}
```

## moonbit.h 头文件

位置：`~/.moon/include/moonbit.h`

包含：
- MoonBit 类型定义
- 引用计数函数
- `moonbit_make_external_object` 辅助函数

## Native 后端构建

```bash
# 生成 C 代码
moon build --target native

# 手动链接
cd _build/native/debug/build
gcc -o myprogram main.c runtime.o \
  -I~/.moon/include \
  ~/.moon/lib/libmoonbitrun.o \
  ~/.moon/lib/libbacktrace.a \
  -lm -lpthread
```

## 完整示例

```moonbit
// ffi_example.mbt
#external type FileHandle

#borrow(filename)
extern "C" fn file_open(filename : Bytes, mode : Bytes) -> FileHandle = "fopen"

extern "C" fn file_close(handle : FileHandle) -> Unit = "fclose"

extern "C" fn file_read(handle : FileHandle, buffer : Bytes, size : Int) -> Int = "fread"

fn read_file_content(path : String) -> String {
  let handle = file_open(path.to_bytes(), b"r")
  let buffer = Bytes::make(1024, b'\0')
  let len = file_read(handle, buffer, 1024)
  file_close(handle)
  buffer[:len].to_string()
}
```
