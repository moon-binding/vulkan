# 编写测试

## test 块

内联测试：

```moonbit
test "test_name" {
  assert_eq(1 + 1, 2)
  assert_true(true)
  assert_false(false)
  inspect([1, 2, 3], content="[1, 2, 3]")
}
```

## 断言函数

```moonbit
// 相等性
assert_eq(actual, expected)
assert_not_eq(a, b)

// 布尔值
assert_true(condition)
assert_false(condition)

// 快照测试
inspect(value, content="expected string representation")
```

## inspect 函数

`inspect` 用于快照测试，要求值实现 `Show` 特征：

```moonbit
test "inspect examples" {
  inspect(42, content="42")
  inspect([1, 2, 3], content="[1, 2, 3]")
  inspect({ x: 1, y: 2 }, content="{x: 1, y: 2}")
}
```

**重要**：不要单独声明 `expected` 变量，直接在 `content=` 参数中写期望字符串：

```moonbit
// 正确
inspect(value, content="[1, 2, 3]")

// 错误（会产生 unused variable 警告）
let expected = "[1, 2, 3]"
inspect(value, content=expected)
```

## 测试文件

测试文件以 `_test.mbt` 结尾：

```
src/
├── lib.mbt
├── lib_test.mbt      # moon test 运行
└── lib_wbtest.mbt    # moon test --wasm-gc 运行（白盒测试）
```

## 运行测试

```bash
# 运行所有测试
moon test

# 指定后端
moon test --target native
moon test --target js
moon test --target wasm-gc

# 更新快照
moon test --update

# 运行白盒测试
moon test --wasm-gc
```

## 测试错误处理

```moonbit
test "error handling" {
  suberror MyError { MyError }

  fn may_fail() -> Int raise MyError {
    raise MyError
  }

  try {
    may_fail()
    assert_true(false)  // 不应该执行到这里
  } catch {
    MyError => assert_true(true)
  }
}
```

## 测试泛型

```moonbit
test "generic function" {
  fn[T : Eq + Show] first_two(arr : Array[T]) -> Array[T] {
    arr[0:2]
  }

  inspect(first_two([1, 2, 3, 4]), content="[1, 2]")
  inspect(first_two(["a", "b", "c"]), content="[\"a\", \"b\"]")
}
```

## 使用 guard 在测试中

```moonbit
test "guard in test" {
  let maybe_value : Int? = Some(42)
  guard maybe_value is Some(v) else {
    fail("Expected Some value")
  }
  assert_eq(v, 42)
}
```

## 测试覆盖率

```bash
moon test -c  # 生成覆盖率报告
```

在 `moon.pkg.json` 中配置：

```json
{
  "test-import": ["moonbitlang/core/coverage"]
}
```
