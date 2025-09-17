@tool
extends KND_Act
class_name KND_Character

## 角色姓名
@export var name: String = "新角色"

## 角色状态图集
@export var character_status: Dictionary[String, String]

## 数据图标
const icon =preload("uid://q2w6piu3t1md")
