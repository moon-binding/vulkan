# 基础

## 内置数据结构

### Unit
表示没有有意义的值，只有一个值 `()`。

### 布尔值
`true` 和 `false`，支持 `!` 取反、`&&` 和 `||` 逻辑运算。

### 数字类型

| 类型 | 描述 | 示例 |
|------|------|------|
| Int16 | 16位有符号整数 | `(42 : Int16)` |
| Int | 32位有符号整数 | `42` |
| Int64 | 64位有符号整数 | `1000L` |
| UInt | 32位无符号整数 | `14U` |
| UInt64 | 64位无符号整数 | `14UL` |
| Double | 64位浮点数 | `3.14` |
| Float | 32位浮点数 | `(3.14 : Float)` |
| BigInt | 大整数 | `10000000000000000000000N` |

### 字符串
```moonbit
let a = "兔rabbit"
let b =
  #| Hello
  #| MoonBit
// 字符串插值
let x = 42
println("The answer is \{x}")
```

### 字符
```moonbit
let a : Char = 'A'
let b = '兔'
```

### 元组
```moonbit
let t = (1, 2)
let (x, y) = t
let x2 = t.0
let y2 = t.1
```

### Option 和 Result
```moonbit
let a : Int? = None
let b : Option[Int] = Some(42)
let c : Result[Int, String] = Ok(42)
let d : Result[Int, String] = Err("error")
```

### 数组
```moonbit
let numbers = [1, 2, 3, 4]
numbers[2]  // 访问元素
numbers[3] = 5  // 修改元素

// FixedArray 有固定大小
let fixed : FixedArray[Int] = [1, 2, 3]
```

### Map
```moonbit
let map : Map[String, Int] = { "x": 1, "y": 2, "z": 3 }
```

### Json
```moonbit
let json : Json = {
  "import": ["moonbitlang/core/builtin"],
  "test-import": ["moonbitlang/core/random"],
}
```

## 函数

### 顶层函数
```moonbit
fn add3(x : Int, y : Int, z : Int) -> Int {
  x + y + z
}
```

### 局部函数
```moonbit
fn local_1() -> Int {
  fn inc(x) { x + 1 }  // 命名局部函数
  (fn(x) { x + inc(2) })(6)  // 匿名函数
}

// 箭头函数语法
[1, 2, 3].eachi((i, x) => println("\{i} => \{x}"))
```

### 部分应用
```moonbit
fn add(x : Int, y : Int) -> Int { x + y }
let add10 : (Int) -> Int = add(10, _)
```

### 带标签的参数
```moonbit
fn labelled(arg1~ : Int, arg2~ : Int) -> Int {
  arg1 + arg2
}
let result = labelled(arg2=2, arg1=1)  // 参数顺序可变
```

### 可选参数
```moonbit
fn optional(opt? : Int = 42) -> Int { opt }
optional()           // 使用默认值 42
optional(opt=0)      // 显式传入 0
```

## 控制结构

### 条件表达式
```moonbit
let initial = if size < 1 { 1 } else { size }
```

### 匹配表达式
```moonbit
match weather {
  "sunny" => "tennis"
  "rainy" => "swimming"
  _ => "unknown"
}
```

### while 循环
```moonbit
let mut i = 5
while i > 0 {
  println(i)
  i = i - 1
} else {
  println("done")
}
```

### for 循环
```moonbit
for i = 0; i < 5; i = i + 1 {
  println(i)
}

for x in [1, 2, 3] {
  println(x)
}

for j in 0..<10 { ... }  // 不包含 10
for j in 0..=10 { ... }  // 包含 10
```

### 函数式循环
```moonbit
loop (xs, 0) {
  ([], acc) => acc
  ([x, ..rest], acc) => continue (rest, x + acc)
}
```

### defer 表达式
```moonbit
defer println("释放资源")
println("使用资源")  // 先执行这个，然后执行 defer
```

## 自定义数据类型

### 结构体
```moonbit
struct User {
  id : Int
  name : String
  mut email : String  // 可变字段
}

let u = { id: 0, name: "John", email: "john@doe.com" }
```

### 枚举
```moonbit
enum List[T] {
  Nil
  Cons(T, List[T])
}

let l : List[Int] = Cons(1, Cons(2, Nil))
```

### 类型别名
```moonbit
pub type Index = Int
pub type MyMap = Map[Int, String]
```

## 模式匹配

```moonbit
match x {
  0 => println("zero")
  Some(v) if v > 0 => println("positive")
  Some(_) => println("non-positive")
  None => println("none")
}

// 数组模式
match ary {
  [] => "empty"
  [x] => "single"
  [x, y, ..rest] => "at least two"
}

// 范围模式
match c {
  'a'..='z' => "lowercase"
  'A'..='Z' => "uppercase"
  _ => "other"
}
```

## 泛型

```moonbit
enum List[T] {
  Nil
  Cons(T, List[T])
}

fn[S, T] List::map(self : List[S], f : (S) -> T) -> List[T] {
  match self {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), xs.map(f))
  }
}
```

## 特殊语法

### 管道
```moonbit
5 |> ignore               // ignore(5)
[] |> Array::push(5)      // Array::push([], 5)
x |> f(y, _)              // f(y, x)
```

### 级联运算符
```moonbit
StringBuilder::new()
  ..write_char('a')
  ..write_string("hello")
  .to_string()
```

### is 表达式
```moonbit
if x is Some(v) && v > 0 {
  println(v)
}
```
