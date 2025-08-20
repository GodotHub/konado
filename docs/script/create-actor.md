# 创建演员

## 功能描述

在对话场景中创建一个演员

## 语法结构

```text
actor show [角色ID] [状态] at [x] [y] scale [比例] <mirror>
```

## 参数详解
| 参数 | 必需 | 示例 | 说明 |
|------|------|------|------|
| 角色ID | 是 | `alice` | 角色资源标识符 |
| 状态 | 是 | `angry` | 立绘状态 |
| x坐标 | 是 | `300` | 水平位置 |
| y坐标 | 是 | `450` | 垂直位置|
| 比例 | 是 | `0.85` | 缩放比例 |
| mirror | 否 | - | 水平镜像翻转 |

关于坐标和缩放，请参考[演员坐标和缩放](/tutorial/actor-coordinate-and-scaling)


## 示例
```text
# 显示角色（左侧，正常状态）
actor show alice normal at 350 500 scale 0.9
```

