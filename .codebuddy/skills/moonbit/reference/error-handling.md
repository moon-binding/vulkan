# 错误处理

## 错误类型

使用 `suberror` 定义错误类型：

```moonbit
suberror E1 { E1(Int) }           // 带负载的错误
suberror E2                        // 简单错误
suberror E3 {                      // 类似枚举的错误
  A
  B(Int, x~ : String)
  C(mut x~ : String, Char, y~ : Bool)
}
```

错误类型可以自动提升为 `Error` 类型：

```moonbit
suberror CustomError { CustomError(UInt) }

test {
  let e : Error = CustomError(42)
  guard e is CustomError(m)
  assert_eq(m, 42)
}
```

### Failure

内置错误类型：

```moonbit
// fail 函数
fn[T] fail(msg : String) -> T raise Failure {
  raise Failure("FAILED: \{msg}")
}
```

## 抛出错误

使用 `raise` 关键字：

```moonbit
suberror DivError { DivError(String) }

fn div(x : Int, y : Int) -> Int raise DivError {
  if y == 0 {
    raise DivError("division by zero")
  }
  x / y
}
```

### 错误多态

使用 `raise?` 表示可能抛出错误：

```moonbit
fn[T] map_with_polymorphism(
  array : Array[T],
  f : (T) -> T raise?
) -> Array[T] raise? {
  let mut res = []
  for x in array {
    res.push(f(x))
  }
  res
}
```

## 处理错误

### try ... catch

```moonbit
fn main {
  try div(42, 0) catch {
    DivError(s) => println(s)
  } noraise {
    v => println(v)
  }
}
```

简化语法：

```moonbit
try { println(div(42, 0)) } catch {
  _ => println("Error")
}

let a = div(42, 0) catch { _ => 0 }
```

### 转换为 Result

使用 `try?`：

```moonbit
test {
  let res : Result[Int, DivError] = try? div(6, 2)
  inspect(res, content="Ok(3)")
}
```

### 出错时崩溃

使用 `try!`：

```moonbit
fn remainder(a : Int, b : Int) -> Int raise DivError {
  if b == 0 { raise DivError("division by zero") }
  let div = try! div(a, b)  // 如果出错则崩溃
  a - b * div
}
```

### 忽略错误

```moonbit
try! func() |> ignore
```

## 常用模式

### 错误类型定义

```moonbit
// 简单错误
suberror NotFound

// 带消息的错误
suberror InvalidInput { InvalidInput(String) }

// 多种情况
suberror ParseError {
  UnexpectedToken(Char)
  UnexpectedEnd
  InvalidEscape(String)
}
```

### 错误处理示例

```moonbit
fn safe_div(x : Int, y : Int) -> Result[Int, String] {
  try? div(x, y) |> Result::map_err(fn(e) {
    match e {
      DivError(msg) => msg
    }
  })
}
```
