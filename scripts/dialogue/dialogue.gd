@tool
extends Resource
class_name Dialogue
## 对话类型
enum Type{
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
	JUMP, ## 跳转
	UNLOCK_ACHIEVEMENTS, ## 解锁成就
	THE_END ## 剧终
}
@export var dialog_type: Type:
	set(v):
		dialog_type = v
		notify_property_list_changed()
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
var background_toggle_effects: ActingInterface.EffectsType
# 跳转的剧情名称
var jump_data_name: String
# 成就ID
var achievement_id: String

# 自定义显示模板
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
	@export var background_toggle_effects: ActingInterface.EffectsType
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
	@export var jump_data_name: String = ""
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

func _get_property_list():
	var list = []
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
	if dialog_type == Type.JUMP:
		var jump_template = Jump_Template.get_property_infos()
		list.append(jump_template["jump_data_name"])
	if dialog_type == Type.UNLOCK_ACHIEVEMENTS:
		var unlock_achievements_template = Unlock_Achievements_Template.get_property_infos()
		list.append(unlock_achievements_template["achievement_id"])
	if dialog_type == Type.THE_END:
		pass
	return list
