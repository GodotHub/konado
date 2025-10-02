@tool
extends KND_Data
class_name KND_Character

## 数据图标
const icon =preload("uid://q2w6piu3t1md")

## 角色姓名
@export var name: String = "新角色"

## 出演过的演员-镜头表 演员名：id
@export var actor_id_map: Dictionary[String, Array] = {}

## 角色状态
@export var character_status: Dictionary = {}
