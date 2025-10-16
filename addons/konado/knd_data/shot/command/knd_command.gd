## Konado对话指令
@tool
extends Resource
class_name KND_Command

enum Type {
	DISPLAY_DIALOGUE_BOX,
	HIDE_DIALOGUE_BOX,
	DISPLAY_TEXT,
	DISPLAY_ACTOR,
	CHANGE_ACTOR_STATE,
	MOVE_ACTOR,
	EXIT_ACTOR,
	DISPLAY_BACKGROUND,
	EXIT_BACKGROUND,
	CHANGE_BACKGROUND,
	MOVE_BACKGROUND,
	PLAY_BGM,
	STOP_BGM,
	PLAY_SFX,
	SHOW_CHOICE,
	BRANCH,
	JUMP_TAG,
	JUMP_SHOT,
	THE_END,
}

@export var dialog_type: Type

## 是否等待触发
@export var wait_trigger: bool = true

# 演员快照
@export var actor_snapshots: Dictionary = {}

# 背景快照
@export var background_snapshots: Dictionary = {}

## 执行，执行完毕会调用callback并传入执行结果，true或者是false
func execute(dialogue_manager: KND_DialogueManager, callback: Callable) -> void:
	push_error("子类必须实现 execute()")
	if callback:
		callback.call(false)

func serialize_type_specific_data() -> Dictionary:
	push_error("子类必须实现 serialize_type_specific_data()")
	return {}

func deserialize_type_specific_data(data: Dictionary) -> void:
	push_error("子类必须实现 deserialize_type_specific_data()")

# 转换为JSON字符串
func to_json() -> String:
	var data = serialize_to_dict()
	return JSON.stringify(data, "\t")

# 从JSON字符串解析
func from_json(json_string: String) -> bool:
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("JSON解析错误: " + json.get_error_message() + " at line " + str(json.get_error_line()))
		return false
	
	var data = json.data
	if data is Dictionary:
		return deserialize_from_dict(data)
	else:
		push_error("JSON数据格式错误，无法转换为字典")
		return false

# 序列化为字典
func serialize_to_dict() -> Dictionary:
	var dict = {}
	dict["dialog_type"] = Type.keys()[dialog_type]
	dict["actor_snapshots"] = actor_snapshots.duplicate(true)
	
	# 合并类型特定的数据
	var type_data = serialize_type_specific_data()
	for key in type_data:
		dict[key] = type_data[key]
	
	return dict

# 从字典反序列化
func deserialize_from_dict(dict: Dictionary) -> bool:	
	if "dialog_type" in dict:
		var type_str = dict["dialog_type"]
		if Type.keys().has(type_str):
			dialog_type = Type.get(type_str)
		else:
			push_error("未知的对话类型: " + str(type_str))
			return false
	
	if "actor_snapshots" in dict:
		actor_snapshots = dict["actor_snapshots"].duplicate(true)
	
	# 反序列化类型特定的数据
	deserialize_type_specific_data(dict)
	
	return true
