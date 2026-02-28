# 属性

MoonBit 支持多种属性来修改函数、类型和字段的行为。

## 函数属性

### #external

声明外部类型：

```moonbit
#external type ExternalHandle
```

### #callsite

自动填充参数：

```moonbit
#callsite(autofill(loc, args_loc))
fn f(_x : Int, loc~ : SourceLoc, args_loc~ : ArgsLoc) -> String {
  "loc: \{loc}, args: \{args_loc}"
}
```

### #alias

创建函数别名：

```moonbit
#alias(g)
#alias(h, visibility="pub")
fn k() -> Bool { true }
```

### #borrow / #owned

FFI 参数所有权标记：

```moonbit
#borrow(filename)
extern "C" fn open(filename : Bytes, flags : Int) -> Int = "open"
```

### #deprecated

标记已弃用：

```moonbit
#deprecated("Use new_function instead")
fn old_function() -> Unit { ... }
```

## 类型属性

### derive

派生内建特征：

```moonbit
struct Point {
  x : Int
  y : Int
} derive(Eq, Compare, Show, Default)
```

## 字段属性

### mut

可变字段：

```moonbit
struct Counter {
  mut count : Int
}
```

## 枚举构造器属性

### 整数表示

```moonbit
enum SpecialNumbers {
  Zero = 0
  One
  Two
  Three
  Ten = 10
  FourtyTwo = 42
}
```

## 特征属性

### pub(open)

可扩展的公开特征：

```moonbit
pub(open) trait MyTrait {
  my_method(Self) -> Int
}
```

## 后端特定属性

### extern "C"

C FFI：

```moonbit
extern "C" fn my_c_function(x : Int) -> Int = "c_func_name"
```

### extern "js"

JavaScript FFI：

```moonbit
extern "js" fn cos(d : Double) -> Double =
  #|(d) => Math.cos(d)
```

### extern "wasm"

WebAssembly 内联：

```moonbit
extern "wasm" fn identity(d : Double) -> Double =
  #|(func (param f64) (result f64))
```

## 示例

```moonbit
/// 带完整属性的函数示例
#deprecated("Use process_v2 instead")
#callsite(autofill(loc))
pub fn process(
  data : String,
  timeout? : Int = 30,
  loc~ : SourceLoc
) -> Result[String, Error] {
  ...
}
```
