@tool
extends Resource
class_name Dialogue

## 源对话文件行号
var source_file_line: int = -1

## 对话类型
enum Type {
	START, ## 开始
	Ordinary_Dialog, ## 普通对话
	Display_Actor, ## 显示演员
	Actor_Change_State, ## 演员切换状态
	Move_Actor, ## 移动角色
	Switch_Background, ## 切换背景
	Exit_Actor, ## 演员退场
	Play_BGM, ## 播放BGM
	Stop_BGM, ## 停止播放BGM
	Play_SoundEffect, ## 播放音效
	Show_Choice, ## 显示选项
	Branch, ## 分支
	JUMP_Tag, ## 跳转到行
	JUMP_Shot, ## 跳转
	THE_END, ## 剧终
	LABEL ## 注释标签
}

@export var dialog_type: Type:
	set(v):
		dialog_type = v
		notify_property_list_changed()

#  用于标记跳转点		
var branch_id: String

# 对话内容
var branch_dialogue: Array[Dialogue] = []

# 是否加载完成
var is_branch_loaded: bool = false

# 对话人物ID
var character_id: String
# 对话内容
var dialog_content: String
# 显示的角色
var show_actor: DialogueActor = DialogueActor.new()
# 隐藏的角色
var exit_actor: String
# 要切换状态的角色
var change_state_actor: String
# 要切换的状态
var change_state: String
# 要移动的角色
var target_move_chara: String
# 角色要移动的位置
var target_move_pos: Vector2
# 选项
var choices: Array[DialogueChoice] = []
# BGM
var bgm_name: String
# 语音名称
var voice_id: String
# 音效名称
var soundeffect_name: String
# 对话背景图片
var background_image_name: String
# 背景切换特效
var background_toggle_effects: ActingInterface.BackgroundTransitionEffectsType

# 目标跳转的镜头
var jump_shot_id: String

## 注释
var label_notes: String

# 保存不同分支故事线的演员字典，默认故事线为"main"
# 角色信息字典结构说明:
# {
#     "id": int,        # 角色唯一标识
#     "x": float,       # X轴坐标
#     "y": float,       # Y轴坐标
#     "state": String,   # 当前状态标识
#     "c_scale": float, # 缩放系数
#     "mirror": bool    # 是否镜像翻转
# }
@export var actor_snapshots: Dictionary = {}

#region 自定义显示模板
class Label_Template:
	@export var label_notes: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (Label_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos

class Tag_Template:
	@export var branch_id: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (Tag_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos

class TagDialogue_Template:
	@export var branch_dialogue: Array[Dialogue] = []
	static func get_property_infos():
		var infos = {}
		for info in (TagDialogue_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos

class Ordinary_Dialog_Template:
	@export var character_id: String = ""
	@export_multiline var dialog_content: String = ""
	@export var voice_id: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (Ordinary_Dialog_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
	
class Switch_Background_Template:
	@export var background_image_name: String = ""
	@export var background_toggle_effects: ActingInterface.BackgroundTransitionEffectsType
	static func get_property_infos():
		var infos = {}
		for info in (Switch_Background_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
		
class Actor_Template:
	@export var show_actor: DialogueActor
	@export var exit_actor: String = ""
	@export var change_state_actor: String = ""
	@export var change_state: String = ""
	@export var target_move_chara: String = ""
	@export var target_move_pos: Vector2 = Vector2(0, 0)
	static func get_property_infos():
		var infos = {}
		for info in (Actor_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
		
class Play_Audio_Template:
	@export var bgm_name: String = ""
	#@export var voice_name: String = ""
	@export var soundeffect_name: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (Play_Audio_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
class Choice_Template:
	@export var choices: Array[DialogueChoice] = []
	static func get_property_infos():
		var infos = {}
		for info in (Choice_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
	
class Jump_Template:
	@export var jump_shot_id: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (Jump_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
		
class Unlock_Achievements_Template:
	@export var achievement_id: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (Unlock_Achievements_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos

class ITEM_OP_Template:
	@export var item_id: String = ""
	static func get_property_infos():
		var infos = {}
		for info in (ITEM_OP_Template as Script).get_script_property_list():
			infos[info.name] = info
		return infos
#endregion

func _get_property_list():
	var list = []
	if dialog_type == Type.Branch:
		var tag_template = Tag_Template.get_property_infos()
		var tag_dialogue_template = TagDialogue_Template.get_property_infos()
		list.append(tag_template["branch_id"])
		list.append(tag_dialogue_template["branch_dialogue"])
	if dialog_type == Type.Ordinary_Dialog:
		var oridinary_dialog_template = Ordinary_Dialog_Template.get_property_infos()
		list.append(oridinary_dialog_template["character_id"])
		list.append(oridinary_dialog_template["dialog_content"])
		list.append(oridinary_dialog_template["voice_id"])
	if dialog_type == Type.Display_Actor:
		var actor_template = Actor_Template.get_property_infos()
		list.append(actor_template["show_actor"])
	if dialog_type == Type.Actor_Change_State:
		var actor_template = Actor_Template.get_property_infos()
		list.append(actor_template["change_state_actor"])
		list.append(actor_template["change_state"])
	if dialog_type == Type.Move_Actor:
		var actor_template = Actor_Template.get_property_infos()
		list.append(actor_template["target_move_chara"])
		list.append(actor_template["target_move_pos"])
	if dialog_type == Type.Switch_Background:
		var switch_background_template = Switch_Background_Template.get_property_infos()
		list.append(switch_background_template["background_image_name"])
		list.append(switch_background_template["background_toggle_effects"])
	if dialog_type == Type.Exit_Actor:
		var actor_template = Actor_Template.get_property_infos()
		list.append(actor_template["exit_actor"])
	if dialog_type == Type.Play_BGM:
		var play_audio_template = Play_Audio_Template.get_property_infos()
		list.append(play_audio_template["bgm_name"])
	if dialog_type == Type.Stop_BGM:
		pass
	if dialog_type == Type.Play_SoundEffect:
		var play_audio_template = Play_Audio_Template.get_property_infos()
		list.append(play_audio_template["soundeffect_name"])
	if dialog_type == Type.Show_Choice:
		var choice_template = Choice_Template.get_property_infos()
		list.append(choice_template["choices"])
	if dialog_type == Type.JUMP_Shot:
		var jump_template = Jump_Template.get_property_infos()
		list.append(jump_template["jump_shot_id"])
	if dialog_type == Type.LABEL:
		var label_template = Label_Template.get_property_infos()
		list.append(label_template["label_notes"])
	if dialog_type == Type.THE_END:
		pass
	return list

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
		push_error("JSON数据格式错误: 根元素不是字典")
		return false

# 序列化为字典
func serialize_to_dict() -> Dictionary:
	var dict = {}
	
	# 基本属性
	dict["source_file_line"] = source_file_line
	dict["dialog_type"] = Type.keys()[dialog_type]
	
	# 根据对话类型序列化相关属性
	match dialog_type:
		Type.Branch:
			dict["branch_id"] = branch_id
			dict["branch_dialogue"] = serialize_dialogue_array(branch_dialogue)
			dict["is_branch_loaded"] = is_branch_loaded
		
		Type.Ordinary_Dialog:
			dict["character_id"] = character_id
			dict["dialog_content"] = dialog_content
			dict["voice_id"] = voice_id
		
		Type.Display_Actor:
			dict["show_actor"] = show_actor.serialize_to_dict() if show_actor else {}
		
		Type.Actor_Change_State:
			dict["change_state_actor"] = change_state_actor
			dict["change_state"] = change_state
		
		Type.Move_Actor:
			dict["target_move_chara"] = target_move_chara
			dict["target_move_pos"] = {"x": target_move_pos.x, "y": target_move_pos.y}
		
		Type.Switch_Background:
			dict["background_image_name"] = background_image_name
			dict["background_toggle_effects"] = background_toggle_effects
		
		Type.Exit_Actor:
			dict["exit_actor"] = exit_actor
		
		Type.Play_BGM:
			dict["bgm_name"] = bgm_name
		
		Type.Play_SoundEffect:
			dict["soundeffect_name"] = soundeffect_name
		
		Type.Show_Choice:
			dict["choices"] = serialize_choice_array(choices)
		
		Type.JUMP_Shot:
			dict["jump_shot_id"] = jump_shot_id
		
		Type.LABEL:
			dict["label_notes"] = label_notes
	
	# 演员快照
	dict["actor_snapshots"] = actor_snapshots.duplicate(true)
	
	return dict

# 从字典反序列化
func deserialize_from_dict(dict: Dictionary) -> bool:
	# 基本属性
	if "source_file_line" in dict:
		source_file_line = dict["source_file_line"]
	
	if "dialog_type" in dict:
		var type_str = dict["dialog_type"]
		if Type.keys().has(type_str):
			dialog_type = Type.get(type_str)
		else:
			push_error("未知的对话类型: " + str(type_str))
			return false
	
	# 根据对话类型反序列化相关属性
	match dialog_type:
		Type.Branch:
			if "branch_id" in dict:
				branch_id = dict["branch_id"]
			if "branch_dialogue" in dict:
				branch_dialogue = deserialize_dialogue_array(dict["branch_dialogue"])
			if "is_branch_loaded" in dict:
				is_branch_loaded = dict["is_branch_loaded"]
		
		Type.Ordinary_Dialog:
			if "character_id" in dict:
				character_id = dict["character_id"]
			if "dialog_content" in dict:
				dialog_content = dict["dialog_content"]
			if "voice_id" in dict:
				voice_id = dict["voice_id"]
		
		Type.Display_Actor:
			if "show_actor" in dict:
				if show_actor == null:
					show_actor = DialogueActor.new()
				show_actor.deserialize_from_dict(dict["show_actor"])
		
		Type.Actor_Change_State:
			if "change_state_actor" in dict:
				change_state_actor = dict["change_state_actor"]
			if "change_state" in dict:
				change_state = dict["change_state"]
		
		Type.Move_Actor:
			if "target_move_chara" in dict:
				target_move_chara = dict["target_move_chara"]
			if "target_move_pos" in dict:
				var pos_dict = dict["target_move_pos"]
				if pos_dict is Dictionary and "x" in pos_dict and "y" in pos_dict:
					target_move_pos = Vector2(pos_dict["x"], pos_dict["y"])
		
		Type.Switch_Background:
			if "background_image_name" in dict:
				background_image_name = dict["background_image_name"]
			if "background_toggle_effects" in dict:
				background_toggle_effects = dict["background_toggle_effects"]
		
		Type.Exit_Actor:
			if "exit_actor" in dict:
				exit_actor = dict["exit_actor"]
		
		Type.Play_BGM:
			if "bgm_name" in dict:
				bgm_name = dict["bgm_name"]
		
		Type.Play_SoundEffect:
			if "soundeffect_name" in dict:
				soundeffect_name = dict["soundeffect_name"]
		
		Type.Show_Choice:
			if "choices" in dict:
				choices = deserialize_choice_array(dict["choices"])
		
		Type.JUMP_Shot:
			if "jump_shot_id" in dict:
				jump_shot_id = dict["jump_shot_id"]
		
		Type.LABEL:
			if "label_notes" in dict:
				label_notes = dict["label_notes"]
	
	# 演员快照
	if "actor_snapshots" in dict:
		actor_snapshots = dict["actor_snapshots"].duplicate(true)
	
	return true

# 序列化对话数组
func serialize_dialogue_array(dialogues: Array[Dialogue]) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for dialogue in dialogues:
		if dialogue:
			result.append(dialogue.serialize_to_dict())
	return result

# 反序列化对话数组
func deserialize_dialogue_array(data: Array) -> Array[Dialogue]:
	var result: Array[Dialogue] = []
	for item in data:
		if item is Dictionary:
			var dialogue = Dialogue.new()
			if dialogue.deserialize_from_dict(item):
				result.append(dialogue)
	return result

# 序列化选项数组
func serialize_choice_array(choices: Array[DialogueChoice]) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for choice in choices:
		if choice:
			result.append(choice.serialize_to_dict())
	return result

# 反序列化选项数组
func deserialize_choice_array(data: Array) -> Array[DialogueChoice]:
	var result: Array[DialogueChoice] = []
	for item in data:
		if item is Dictionary:
			var choice = DialogueChoice.new()
			if choice.deserialize_from_dict(item):
				result.append(choice)
	return result
