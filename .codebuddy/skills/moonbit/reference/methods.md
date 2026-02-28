# 方法和特征

## 方法系统

MoonBit 中的方法是类型构造器关联的顶层函数。

```moonbit
enum List[X] {
  Nil
  Cons(X, List[X])
}

fn[X] List::length(xs : List[X]) -> Int {
  match xs {
    Nil => 0
    Cons(_, rest) => 1 + rest.length()
  }
}

// 调用方法
let l : List[Int] = Nil
println(l.length())       // 点语法
println(List::length(l))  // 完整语法
```

### 本地方法

可以为外部类型定义私有方法：

```moonbit
fn Int::my_int_method(self : Int) -> Int {
  self * self + self
}

test {
  assert_eq((6).my_int_method(), 42)
}
```

## 运算符重载

通过内建特征重载运算符：

```moonbit
struct T {
  x : Int
}

impl Add for T with add(self : T, other : T) -> T {
  { x: self.x + other.x }
}

// 可重载的运算符
// + : Add, - : Sub, * : Mul, / : Div, % : Mod
// == : Eq, << : Shl, >> : Shr
// -（一元）: Neg, & : BitAnd, | : BitOr, ^ : BitXOr
// _[_] : 索引访问
// _[_]=_ : 索引赋值
// _[_:_] : 切片
```

## Trait（特征）系统

### 声明特征

```moonbit
pub(open) trait I {
  method_(Int) -> Int
  method_with_label(Int, label~ : Int) -> Int
}
```

### 扩展特征（子特征）

```moonbit
pub(open) trait Position {
  pos(Self) -> (Int, Int)
}

pub(open) trait Draw {
  draw(Self, Int, Int) -> Unit
}

pub(open) trait Object: Position + Draw {}
```

### 实现特征

```moonbit
pub(open) trait MyShow {
  to_string(Self) -> String
}

struct MyType {}

pub impl MyShow for MyType with to_string(self) {
  "MyType"
}

// 泛型类型实现
pub impl[X : MyShow] MyShow for MyContainer[X] with to_string(self) {
  ...
}

// 默认实现
pub(open) trait J {
  f(Self) -> Unit
  f_twice(Self) -> Unit = _  // = _ 标记有默认实现
}

impl J with f_twice(self) {
  self.f()
  self.f()
}
```

### 使用特征约束

```moonbit
fn[X : Eq] contains(xs : Array[X], elem : X) -> Bool {
  for x in xs {
    if x == elem {
      return true
    }
  } else {
    false
  }
}
```

### 直接调用特征方法

```moonbit
assert_eq(Show::to_string(42), "42")
assert_eq(Compare::compare(1.0, 2.5), -1)
```

## 特征对象

运行时多态：

```moonbit
pub(open) trait Animal {
  speak(Self) -> String
}

struct Duck(String)
impl Animal for Duck with speak(self) { "\{self.0}: quack!" }

struct Fox(String)
impl Animal for Fox with speak(_self) { "What does the fox say?" }

test {
  let duck1 = Duck::make("duck1")
  let fox1 = Fox::make("fox1")
  let animals : Array[&Animal] = [duck1, fox1]  // 特征对象
  for animal in animals {
    println(animal.speak())
  }
}
```

对象安全要求：
- Self 必须是方法的第一个参数
- 方法的类型中只能出现一个 Self

## 内建特征

```moonbit
trait Eq {
  op_equal(Self, Self) -> Bool
}

trait Compare : Eq {
  compare(Self, Self) -> Int  // 0=相等, -1=小于, 1=大于
}

trait Hash {
  hash_combine(Self, Hasher) -> Unit
  hash(Self) -> Int
}

trait Show {
  output(Self, Logger) -> Unit
  to_string(Self) -> String
}

trait Default {
  default() -> Self
}
```

## 派生内建特征

```moonbit
struct T {
  a : Int
  b : Int
} derive(Eq, Compare, Show, Default)

test {
  let t1 = T::default()
  let t2 = T::{ a: 1, b: 1 }
  assert_true(t1 < t2)
}
```
