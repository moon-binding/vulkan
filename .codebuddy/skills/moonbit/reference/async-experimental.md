# 异步编程支持（实验性）

异步编程支持目前是实验性的。

## async 函数

```moonbit
async fn fetch_data(url : String) -> String raise Error {
  ...
}
```

## async 块

```moonbit
let result = async {
  let a = fetch_data("url1")
  let b = fetch_data("url2")
  (a, b)
}
```

## await

```moonbit
async fn process() -> Unit {
  let data = await fetch_data("url")
  println(data)
}
```

## 异步错误处理

```moonbit
async fn safe_fetch(url : String) -> Result[String, Error] {
  try? fetch_data(url)
}
```

## 异步测试

```moonbit
test "async test" async {
  let result = await fetch_data("test_url")
  assert_true(result.length() > 0)
}
```

## 使用 moonbitlang/async

```bash
moon add moonbitlang/async
```

```json
{
  "import": ["moonbitlang/async"]
}
```

## TCP 客户端

```moonbit
async fn connect(host : String, port : Int) -> Connection {
  ...
}
```

## HTTP 客户端

```moonbit
async fn http_get(url : String) -> Response {
  ...
}
```

## 异步主函数

```moonbit
async fn main {
  let data = await fetch_data("url")
  println(data)
}
```

## 注意事项

- 异步支持是实验性的，API 可能会变化
- 需要安装 `moonbitlang/async` 包
- 目前主要用于网络 I/O 操作
