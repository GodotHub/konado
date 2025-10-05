@tool
extends KND_Data
class_name KND_Shot

## 镜头图标
const icon: Texture2D = preload("uid://b62h640a6knig")

@export var name: String = "新镜头"

@export var shot_id: String = ""

## 源剧情文本
@export var source_story: String = ""

# TODO: 对话列表
@export var dialogues: Array[Dialogue] = []

## 对话源数据
@export var dialogues_source_data: Array[Dictionary] = []
# tag字典
@export var branchs: Dictionary = {}

## key是演员名，value是角色id
@export var actor_character_map: Dictionary[String, int] = {}

## 获取对话数据
func get_dialogues() -> Array[Dialogue]:
	dialogues.clear()
	for data in dialogues_source_data:
		var dialogue = Dialogue.new()
		dialogue.from_json(str(data))
		dialogues.append(dialogue)
	return dialogues
