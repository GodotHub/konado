@tool
extends Node

@export var knd_shot_map: Dictionary[String, int]

@export var label: CodeEdit

func _ready() -> void:
	label.text_changed.connect(func():
		var lc: int = label.get_line_count()
		var content: Array[String] = []
		for i in lc:
			content.append(label.get_line(i))
		update_shot_ks_content(0, content)
		var dialogues: Array[Dialogue] = get_shot_dialogues(0)
		print(dialogues)
		)
	

func get_knd_shot_map() -> Dictionary[String, int]:
	knd_shot_map.clear()
	var knd_shot_ids = KND_Database.get_data_ids_by_type("KND_Shot")
	for id in knd_shot_ids:
		knd_shot_map[KND_Database.get_data_property(id, "name")] = id
	return knd_shot_map

## 创建KND_Shot数据并返回ID
func create_shot() -> int:
	return KND_Database.create_data("KND_Shot")

## 更新KND_Shot的KS脚本内容
func update_shot_ks_content(id: int, content: Array[String]) -> void:
	KND_Database.set_data(id, "ks_content", content)
	
## 获取该镜头的对话列表
func get_shot_dialogues(id: int) -> Array[Dialogue]:
	var dialogues: Array[Dialogue] = []
	if KND_Database.is_valid_id(id):
		var tmp_dialogues = KND_Database.get_data_property(id, "dialogues")
		for tmp in tmp_dialogues:
			var dialogue = tmp as Dialogue
			dialogues.append(dialogue)
	return dialogues
	
func set_actor_character_map(id: int, map: Dictionary[String, int]) -> void:
	if KND_Database.is_valid_id(id):
		KND_Database.set_data(id, "actor_character_map", map)
		
func set_background_map(id: int, map: Dictionary[String, int]) -> void:
	if KND_Database.is_valid_id(id):
		KND_Database.set_data(id, "background_map", map)

func set_bgm_map(id: int, map: Dictionary[String, int]) -> void:
	if KND_Database.is_valid_id(id):
		KND_Database.set_data(id, "bgm_map", map)
		
func set_sfx_map(id: int, map: Dictionary[String, int]) -> void:
	if KND_Database.is_valid_id(id):
		KND_Database.set_data(id, "sfx_map", map)
		
func set_voice_map(id: int, map: Dictionary[String, int]) -> void:
	if KND_Database.is_valid_id(id):
		KND_Database.set_data(id, "voice_map", map)
