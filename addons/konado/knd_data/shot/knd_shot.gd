@tool
extends KND_Data
class_name KND_Shot

## 镜头图标
const icon = preload("uid://b62h640a6knig")

@export var name: String = "新镜头"

# 对话列表
@export var dialogs: Array[int] = []
# tag字典
@export var branchs: Dictionary = {}

## key是演员名，value是角色id
@export var actor_character_map: Dictionary[String, int] = {}

## 描述
@export var tip: String = "描述"

## 收藏
@export var love: bool = false
