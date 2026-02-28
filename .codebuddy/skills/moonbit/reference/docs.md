# 文档

## 文档注释

使用 `///` 编写文档注释：

```moonbit
/// 计算两个整数的和
/// 参数:
///   x - 第一个整数
///   y - 第二个整数
/// 返回: 两数之和
pub fn add(x : Int, y : Int) -> Int {
  x + y
}

/// 表示二维平面上的点
pub struct Point {
  /// X 坐标
  x : Int
  /// Y 坐标
  y : Int
}

/// 列表数据结构
pub enum List[T] {
  /// 空列表
  Nil
  /// 包含头部元素和剩余列表
  Cons(T, List[T])
}
```

## 生成文档

```bash
moon doc
```

生成的文档将输出到 `_build/doc/` 目录。

## 文档格式

### 函数文档

```moonbit
/// 函数简短描述
///
/// 更详细的描述...
///
/// # 示例
/// ```moonbit
/// let result = my_function(42)
/// ```
///
/// # 参数
/// - `x`: 参数描述
///
/// # 返回值
/// 返回值描述
///
/// # 错误
/// 可能抛出的错误描述
pub fn my_function(x : Int) -> Int { ... }
```

### 类型文档

```moonbit
/// 类型简短描述
///
/// 更详细的描述...
pub struct MyType {
  /// 字段描述
  field1 : Int
  field2 : String
}
```

### 特征文档

```moonbit
/// 特征描述
pub(open) trait MyTrait {
  /// 方法描述
  my_method(Self, Int) -> String
}
```
