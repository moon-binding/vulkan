# 派生内建特征

MoonBit 可以自动为内建特征派生实现：

```moonbit
struct T {
  a : Int
  b : Int
} derive(Eq, Compare, Show, Default)
```

## 可派生的特征

### Eq

比较相等性：

```moonbit
struct Point {
  x : Int
  y : Int
} derive(Eq)

test {
  let p1 = { x: 1, y: 2 }
  let p2 = { x: 1, y: 2 }
  assert_eq(p1, p2)
}
```

### Compare

比较大小，用于排序：

```moonbit
struct Point {
  x : Int
  y : Int
} derive(Compare)

test {
  let p1 = { x: 1, y: 2 }
  let p2 = { x: 1, y: 3 }
  assert_true(p1 < p2)
}
```

### Show

转换为字符串：

```moonbit
struct Point {
  x : Int
  y : Int
} derive(Show)

test {
  let p = { x: 1, y: 2 }
  inspect(p, content="{x: 1, y: 2}")
}
```

### Default

生成默认值：

```moonbit
struct Point {
  x : Int
  y : Int
} derive(Default)

test {
  let p = Point::default()
  inspect(p, content="{x: 0, y: 0}")
}
```

## 枚举的派生

```moonbit
enum Color {
  Red
  Green
  Blue
} derive(Eq, Compare, Show, Default)

test {
  let c = Color::default()  // Red (第一个构造器)
  println(c)  // "Red"
}
```

## 泛型类型的派生

```moonbit
struct Box[T] {
  value : T
} derive(Eq, Show)

test {
  let b1 = { value: 42 }
  let b2 = { value: 42 }
  assert_eq(b1, b2)
}
```

## 多个派生

```moonbit
struct User {
  id : Int
  name : String
  email : String
} derive(Eq, Compare, Show, Default, Hash)
```

## 派生条件

要派生某个特征，类型的所有字段必须已经实现了该特征。

例如，要派生 `Show`，所有字段类型必须实现 `Show`：

```moonbit
// 可以：Int 和 String 都实现了 Show
struct Pair derive(Show) {
  first : Int
  second : String
}

// 不可以：假设 MyType 没有实现 Show
// struct Bad derive(Show) { x : MyType }
```
