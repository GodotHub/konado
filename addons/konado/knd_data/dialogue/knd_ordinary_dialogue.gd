@tool
extends KND_Dialogue
class_name KND_Ordinary_Dialogue

# 对话人物ID
@export var character_id: String:
	set(value):
		if character_id != value:
			character_id = value
			emit_changed()
			gen_source_data()
			# notify_property_list_changed()
# 对话内容
@export var dialog_content: String
