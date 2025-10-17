@tool
extends CanvasLayer

signal dialogue_star
signal dialogue_end
signal jump_next

@export var character_show :=false

@export var knd_shot:KND_Shot
@export var characters = [2,6,3]

## 角色模板
@export var character_component = preload("uid://dcwk5so2ohcc2")
## 对话场景模板
@export var knd_dialogue_component = preload("uid://0sc04evetbux")
## 对话框模板
@export var knd_dialogue = preload("uid://0sc04evetbux")

func _ready() -> void:
	# 实例对话场景
	knd_dialogue_component.instantiate()
	# 实例 角色
	for i in characters:
		var character = character_component.instantiate()
		#character.id = i
		add_child(character)
	
