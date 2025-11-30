## KND_Data是所有数据类的基类，所有数据类都应该继承自这个类，比如KND_Shot就是继承该类
@tool
extends Resource
class_name KND_Data

## 数据类型
@export var type: String = ""

## 收藏
@export var love: bool = false

## tip
@export var tip: String = ""
