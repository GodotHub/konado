@tool
extends KND_Data
class_name KND_Shot

## 镜头图标
const icon: Texture2D = preload("uid://b62h640a6knig")

@export var name: String = "新镜头"

## 源剧情文本
@export var source_story: String = ""

## 对话，请调用get_dialogues函数获取
@export var dialogues: Array[Dialogue] = []

## 对话源数据
@export var dialogues_source_data: Array[Dictionary] = []

## 分支
@export var branchs: Dictionary = {}

## 分支源数据
@export var source_branchs: Dictionary[String, Dictionary] = {}

## key是演员名，value是角色数据id
@export var actor_character_map: Dictionary[String, int] = {}

## key是背景名，value是背景数据id
@export var background_map: Dictionary[String, int] = {}

@export var bgm_map: Dictionary[String, int] = {}

@export var sfx_map: Dictionary[String, int] = {}

@export var voice_map: Dictionary[String, int] = {}

## Konado Script 内容
@export var ks_content: String = ""

## 设置ks内容
func set_ks_content(content: String, compile: bool = true) -> void:
	ks_content = content
	if compile:
		var interpreter: KonadoScriptsInterpreter = KonadoScriptsInterpreter.new()
		interpreter.init_insterpreter({
			"allow_custom_suffix": true,
			"allow_skip_error_line": true,
			"enable_actor_validation": true
			})
		var tmp: KND_Shot = interpreter.process_script(ks_content)
		self.dialogues_source_data = tmp.dialogues_source_data
		self.source_branchs = tmp.source_branchs
		self.get_dialogues()
		
## 获取ks内容
func get_ks_content() -> String:
	return ks_content

## 获取对话数据
func get_dialogues() -> Array[Dialogue]:
	dialogues.clear()
	branchs.clear()
	for data in dialogues_source_data:
		var dialogue = Dialogue.new()
		dialogue.from_json(str(data))
		dialogues.append(dialogue)
	for branch in source_branchs.keys():
		var branch_dialogue: Dialogue = Dialogue.new()
		branch_dialogue.deserialize_from_dict(source_branchs[branch])
		branchs.set(branch, branch_dialogue)
	return dialogues
