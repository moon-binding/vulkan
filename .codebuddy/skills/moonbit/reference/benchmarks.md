# 编写基准测试

## 基准测试文件

基准测试文件以 `_bench.mbt` 结尾：

```
src/
├── lib.mbt
└── lib_bench.mbt
```

## 定义基准测试

使用 `bench` 块：

```moonbit
bench "array_append" {
  let mut arr = []
  for i in 0..=1000 {
    arr.push(i)
  }
}
```

## 运行基准测试

```bash
moon bench --target native
```

## 基准测试配置

在 `moon.pkg.json` 中：

```json
{
  "bench-import": ["moonbitlang/core/bench"]
}
```

## 示例

```moonbit
// lib_bench.mbt

bench "fibonacci_recursive" {
  fn fib(n : Int) -> Int {
    if n <= 1 { n } else { fib(n - 1) + fib(n - 2) }
  }
  let _ = fib(30)
}

bench "fibonacci_iterative" {
  fn fib_iter(n : Int) -> Int {
    let mut a = 0
    let mut b = 1
    for _ = 0; _ < n; _ = _ + 1 {
      let temp = a + b
      a = b
      b = temp
    }
    a
  }
  let _ = fib_iter(30)
}
```
