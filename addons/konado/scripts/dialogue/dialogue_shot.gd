## 对话镜头

extends Resource
class_name DialogueShot

## shot_id，镜头id，不允许重复
@export var shot_id: String

# 对话列表
@export var dialogs: Array[Dialogue] = []
# tag字典
@export var branchs: Dictionary = {}

## 依赖的角色，整个对话中出现的角色
@export var dep_characters: Array[String] = []

## 以下以备连线时使用

@export var last_shots: Array[String] = []

@export var next_shots: Array[String] = []
