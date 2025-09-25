@tool
extends Resource
class_name KND_Dialogue

## 源对话文件行号
var source_file_line: int = -1

## 对话类型
#enum Type {
	#START, ## 开始
	#Ordinary_Dialog, ## 普通对话
	#Display_Actor, ## 显示演员
	#Actor_Change_State, ## 演员切换状态
	#Move_Actor, ## 移动角色
	#Switch_Background, ## 切换背景
	#Exit_Actor, ## 演员退场
	#Play_BGM, ## 播放BGM
	#Stop_BGM, ## 停止播放BGM
	#Play_SoundEffect, ## 播放音效
	#Show_Choice, ## 显示选项
	#Branch, ## 分支
	#JUMP_Tag, ## 跳转到行
	#JUMP_Shot, ## 跳转
	#THE_END, ## 剧终
	#LABEL ## 注释标签
#}
#
#@export var dialog_type: Type
#
##  用于标记跳转点		
#@export var branch_id: String
#
## 对话内容
#@export var branch_dialogue: Array[Dialogue] = []
#
## 是否加载完成
#@export var is_branch_loaded: bool = false

## 对话人物ID
#@export var character_id: String
## 对话内容
#@export var dialog_content: String
# 显示的角色
#@export var show_actor: DialogueActor = DialogueActor.new()
## 隐藏的角色
#@export var exit_actor: String
## 要切换状态的角色
#@export var change_state_actor: String
## 要切换的状态
#@export var change_state: String
## 要移动的角色
#@export var target_move_chara: String
## 角色要移动的位置
#var target_move_pos: Vector2
## 选项
#var choices: Array[DialogueChoice] = []
## BGM
#var bgm_name: String
## 语音名称
#var voice_id: String
## 音效名称
#var soundeffect_name: String
## 对话背景图片
#var background_image_name: String
## 背景切换特效
#var background_toggle_effects: ActingInterface.EffectsType
#
## 目标跳转的镜头
#var jump_shot_id: String
#
### 注释
#var label_notes: String
