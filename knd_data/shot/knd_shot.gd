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
## 分支
@export var branches: Dictionary = {}

## 分支源数据
@export var source_branches: Dictionary[String, Dictionary] = {}

## key是演员名，value是角色id
@export var actor_character_map: Dictionary[String, int] = {}

## 获取对话数据
func get_dialogues() -> Array[Dialogue]:
	dialogues.clear()
	branches.clear()
	for data in dialogues_source_data:
		var dialogue = Dialogue.new()
		dialogue.from_json(str(data))
		dialogues.append(dialogue)
	for branch in source_branches.keys():
		var branch_dialogue: Dialogue = Dialogue.new()
		branch_dialogue.deserialize_from_dict(source_branches[branch])
		branches.set(branch, branch_dialogue)
	return dialogues
