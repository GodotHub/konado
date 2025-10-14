@tool
extends KND_Command
class_name KND_DisplayTextCommand

## 角色姓名
@export var character_name: String = ""

## 对话文本内容
@export var dialogue_text: String = ""

func _init() -> void:
	type = Type.DISPLAY_TEXT

func execute(dialogue_manager: KND_DialogueManager, callback: Callable) -> void:
	var dialogue_box = dialogue_manager.dialogue_box
	dialogue_box.character_name = character_name
	dialogue_box.typing_completed.connect(func(): 
		if callback:
			callback.call(true)
			)
	dialogue_box.dialogue_text = dialogue_text

func deserialize_type_specific_data(data: Dictionary) -> void:
	if "character_name" in data:
		character_name = data["character_name"]
	if "dialogue_text" in data:
		dialogue_text = data["dialogue_text"]
	return
	
func serialize_to_dict() -> Dictionary:
	var data = {}
	data["character_name"] = character_name
	data["dialogue_text"] = dialogue_text
	return data
