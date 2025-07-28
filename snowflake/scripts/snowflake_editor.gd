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
		# print("SnowflakeEditor resized" + str(self.get_size()))
		# 根据窗口大小调整DialogueManager的大小（Control）
		# 计算当前窗口的宽高比
		var aspect_ratio = self.get_size().x / self.get_size().y
		# 保持DialogueManager的宽高比，计算可调整的宽高
		var x_adjust = self.get_size().x / 1280
		var y_adjust = self.get_size().y / 720
		
		var target_adjust = max(x_adjust, y_adjust)

		# 根据调整后的宽高比，计算目标宽高
		var target_scale = target_adjust * 0.65

		dialogue_manager.set_scale(Vector2(target_scale, target_scale))

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
	autoplay_btn.pressed.connect(func(): 
		if autoplay_btn.text == "自动播放":
			autoplay_btn.text = "停止播放"
			dialogue_manager.start_autoplay(true)
		else:
			autoplay_btn.text = "自动播放"
			dialogue_manager.start_autoplay(false)
		)
	pass


func on_dialogue_ks_load_btn_pressed() -> void:
	file_dialogue.title = "选择对话脚本"
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

	var main_label = Label.new()
	main_label.text = "主对话"
	dialogue_debug_box_container.add_child(main_label)
	var index = 0
	for dia in diadata.dialogs:
		_gen_dialogue_box(index, dia)
		index += 1

	for tagdia in diadata.tag_dialogues:
		var tag_label = Label.new()
		tag_label.text = "标签对话：" + tagdia
		dialogue_debug_box_container.add_child(tag_label)
		var tag_dialogue: Dialogue = diadata.tag_dialogues[tagdia]
		for dia in tag_dialogue.tag_dialogue:
			_gen_dialogue_box(0, dia, true)
	
	#dialogue_manager.set_chara_list()
	dialogue_manager.set_dialogue_data(diadata)
	dialogue_manager._init_dialogue()
	dialogue_manager._start_dialogue()


## 清空对话盒
func _clean_dialogue_box_container() -> void:
	for child in dialogue_debug_box_container.get_children():
		child.queue_free()


## 生成对话盒
func _gen_dialogue_box(index: int, dialogue: Dialogue, subdia: bool = false) -> void:
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
	if subdia == true:
		debug_box.set_sub_box()
	pass
	

func on_character_table_btn_pressed() -> void:
	file_dialogue.title = "选择角色表"
	file_dialogue.file_selected.connect(load_character_table)
	file_dialogue.filters = ["*.res", "*.tres"]
	file_dialogue.popup()
	pass

func load_character_table(path: String) -> void:
	file_dialogue.file_selected.disconnect(load_character_table)
	var chara_table = ResourceLoader.load(path) as CharacterList
	dialogue_manager.set_chara_list(chara_table)
	pass

func on_background_table_btn_pressed() -> void:
	file_dialogue.title = "选择背景表"
	file_dialogue.file_selected.connect(load_background_table)
	file_dialogue.filters = ["*.res", "*.tres"]
	file_dialogue.popup()
	pass

func load_background_table(path: String) -> void:
	file_dialogue.file_selected.disconnect(load_background_table)
	var bg_table = ResourceLoader.load(path) as BackgroundList
	dialogue_manager.set_background_list(bg_table)
	pass 

func on_bgm_table_btn_pressed() -> void:
	file_dialogue.title = "选择BGM表"
	file_dialogue.file_selected.connect(load_bgm_table)
	file_dialogue.filters = ["*.res", "*.tres"]
	file_dialogue.popup()
	pass

func load_bgm_table(path: String) -> void:
	file_dialogue.file_selected.disconnect(load_bgm_table)
	var bgm_table = ResourceLoader.load(path) as DialogBGMList
	dialogue_manager.set_bgm_list(bgm_table)
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
