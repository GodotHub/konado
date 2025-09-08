@tool
extends BoxContainer
## 角色 演员 对照组件

signal delete_request(arctor)
signal actor_renamed()
signal character_selected()

## TODO 
## 角色标签
@onready var delect         : Button   = $delect         ## 删除按钮
@onready var actor_name     : LineEdit = %actor_name
@onready var character_label: Label    = %CharacterLabel ## 角色标签

## 导出数据
@export var actor:="":              ## 演员名称
	set(value):
		if actor != value:
			actor = value
			if actor_name:
				actor_name.text = value

@export var charactor:Character ## 角色数据


var charactor_name :="":            ## 角色标签 
	get:
		if character_label and charactor:
			character_label.text = charactor.chara_name
			return charactor.chara_name
		else :
			return "未选择角色"

func _on_delect_pressed() -> void:
	delete_request.emit(self)
	Character
