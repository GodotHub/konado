extends Resource
class_name DialogueChoice

## 选项文本内容
@export var choice_text: String
## 选项跳转剧情名称
@export var jump_tag: String

func serialize_to_dict() -> Dictionary:
	return {
		"choice_text": choice_text,
		"jump_tag": jump_tag
	}

func deserialize_from_dict(dict: Dictionary) -> bool:
	if "choice_text" in dict:
		choice_text = dict["choice_text"]
	if "jump_tag" in dict:
		jump_tag = dict["jump_tag"]
	return true