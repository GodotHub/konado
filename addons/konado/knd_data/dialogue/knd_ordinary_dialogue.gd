@tool
extends KND_Dialogue
class_name KND_Ordinary_Dialogue

## 对话人物ID
@export var character_id: String:
	set(value):
		if character_id != value:
			character_id = value
			emit_changed()
			gen_source_data()
			# notify_property_list_changed()
## 对话内容
@export var dialog_content: String:
	set(value):
		if dialog_content != value:
			dialog_content = value
			emit_changed()
			gen_source_data()

## 打字机速度（暂时未使用）
@export var typing_speed: float = 0.05:
	set(value):
		if typing_speed != value:
			typing_speed = value
			emit_changed()
			gen_source_data()
