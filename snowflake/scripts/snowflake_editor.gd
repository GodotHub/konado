################################################################################
# Project: Konado
# File: snowflake_editor.gd
# Author: DSOE1024
# Created: 2027-07-24
# Last Modified: 2027-07-24
# Description:
#   雪花编辑器主界面
################################################################################

@tool
extends Control
class_name SnowflakeEditor

@export var dialogue_ks_load_btn: Button

@export var character_table_btn: Button

@export var background_table_btn: Button

@export var bgm_table_btn: Button

@export var dialogue_manager: DialogueManager

@export var file_dialogue: FileDialog

@export var playnext: Button

@export var autoplay_btn: Button

@export var dialogue_debug_box_container: VBoxContainer

@export var dialogue_box_scene: PackedScene

var tmp_ks_file_path: String = ""



func _ready() -> void:
	# 订阅大小变化事件
	self.resized.connect(func(): 
		print("SnowflakeEditor resized" + str(self.get_size()))
	)
	init_editor()
	pass


func init_editor() -> void:
	if dialogue_manager.print_hello() == true:
		dialogue_manager.debug_mode = true
		print("Hello from SnowflakeEditor!")

	dialogue_ks_load_btn.pressed.connect(on_dialogue_ks_load_btn_pressed)
	character_table_btn.pressed.connect(on_character_table_btn_pressed)
	background_table_btn.pressed.connect(on_background_table_btn_pressed)
	bgm_table_btn.pressed.connect(on_bgm_table_btn_pressed)
	playnext.pressed.connect(dialogue_manager._continue)
	autoplay_btn.pressed.connect(dialogue_manager._toggle_auto_play)
	pass


	

func on_dialogue_ks_load_btn_pressed() -> void:
	file_dialogue.file_selected.connect(load_ks_file)
	file_dialogue.filters = ["*.ks"]
	file_dialogue.popup()
	pass

func load_ks_file(path: String) -> void:
	tmp_ks_file_path = path
	file_dialogue.file_selected.disconnect(load_ks_file)
	file_dialogue.filters = []
	var interpreter = KonadoScriptsInterpreter.new()
	var diadata: DialogueData = interpreter.process_scripts_to_data(path)

	_clean_dialogue_box_container()
	var index = 0
	for dia in diadata.dialogs:
		_gen_dialogue_box(index, dia)
		index += 1
	#dialogue_manager.set_chara_list()
	dialogue_manager.set_dialogue_data(diadata)
	dialogue_manager._init_dialogue()
	dialogue_manager._start_dialogue()


## 清空对话盒
func _clean_dialogue_box_container() -> void:
	for child in dialogue_debug_box_container.get_children():
		child.queue_free()


## 生成对话盒
func _gen_dialogue_box(index: int, dialogue: Dialogue) -> void:
	var debug_box = dialogue_box_scene.instantiate() as DialogueDebugBox
	var line_des = "在对话第：" + str(index) +  "句" + " - " + "在源文件第" + str(dialogue.source_file_line) + "行"
	debug_box.init_box(index, dialogue.source_file_line, "描述", line_des)
	debug_box.on_edit_btn_pressed.connect(func(line: int):
		edit_with_vscode(ProjectSettings.globalize_path(tmp_ks_file_path), line, 1)
		)
	debug_box.on_play_btn_pressed.connect(func(index: int):
		dialogue_manager._jump_curline(index)
		)
	# 添加到场景
	dialogue_debug_box_container.add_child(debug_box)

	
	pass
	

func on_character_table_btn_pressed() -> void:
	file_dialogue.popup()
	pass

func on_background_table_btn_pressed() -> void:
	file_dialogue.popup()
	pass

func on_bgm_table_btn_pressed() -> void:
	file_dialogue.popup()
	pass



func edit_with_vscode(path: String, line: int, col: int) -> void:
	if OS.get_name() == "Android":
		print("Android not supported")
		return
	if OS.get_name() == "Web":
		print("Web not supported")
		return
	if OS.get_name() == "iOS":
		print("iOS not supported")
		return
	# 打开vscode编辑器
	# 请将vscode添加到系统环境变量中
	var full_cmd = "code" + " -g \"" + path + "\":" + str(line) + ":" + str(col)
	var error = OS.execute("cmd", ["/C", full_cmd])
	if error != 0:
		print("Error: " + str(error))
