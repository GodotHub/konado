@tool
extends KND_Data
class_name KND_Shot

@export var name: String = "New Shot"

# 对话列表
@export var dialogs: Array[KND_Dialogue] = []
# tag字典
@export var branchs: Dictionary = {}

## key是演员名，value是角色id
@export var actor_character_map: Dictionary[String, int] = {}

## 依赖的角色，整个对话中出现的角色
##@export var dep_characters: Array[String] = []

## 以下以备连线时使用

@export var last_shots: Array[String] = []

@export var next_shots: Array[String] = []
