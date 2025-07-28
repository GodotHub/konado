################################################################################
# Project: Konado
# File: konadoscripts_Interpreter.gd
# Author: DSOE1024
# Created: 2025-07-12
# Last Modified: 2025-07-14
# Description:
#    Konado脚本解释器
################################################################################

@tool
extends Node
class_name KonadoScriptsInterpreter

# Konado脚本解释器

var tmp_path = ""
# 源脚本行，显示在VSCode中
var tmp_original_line_number = 0
# 当前脚本行，经过处理后的行
var tmp_line_number = 0
var tmp_content_lines = []

## 对话内容正则表达式
var dialogue_content_regex: RegEx
## 元数据正则表达式
var dialogue_metadata_regex: RegEx

## 演员验证表
var cur_tmp_actors = []

## 选项行记录表 key: 行号 value: 行内容
var cur_tmp_option_lines = {}
var tmp_tags = []

# 全文解析模式
func process_scripts_to_data(path: String) -> DialogueData:
	if not path:
		_scripts_debug(path, 0, "路径为空，无法打开脚本文件")
		return null

	if not FileAccess.file_exists(path):
		_scripts_debug(path, 0, "文件不存在，无法打开脚本文件")
		return null

	if not path.ends_with(".ks"):
		_scripts_debug(path, 0, "文件后缀不正确，无法打开脚本文件")
		return null

	tmp_path = path

	# 读取文件内容
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		_scripts_debug(path, 0, "无法打开脚本文件")
		return null
	var lines = file.get_as_text().split("\n")
	file.close()

	
	# 提前初始化正则表达式，避免重复编译
	dialogue_content_regex = RegEx.new()
	dialogue_content_regex.compile("^\"(.*?)\"\\s+\"(.*?)\"(?:\\s+(\\S+))?$")

	dialogue_metadata_regex = RegEx.new()
	dialogue_metadata_regex.compile("^(chapter_id|chapter_name|chapter_lang|chapter_author|chapter_desc)\\s+(\\S+)")
	
	_scripts_info(path, 0, "开始解析脚本文件")

	var diadata: DialogueData = DialogueData.new()

	# 解析元数据
	var metadata_result = _parse_metadata(lines, path)
	dialogue_metadata_regex = null
	if not metadata_result:
		_scripts_debug(path, 0, "元数据解析失败")
		return diadata
	
	diadata.chapter_id = metadata_result[0]
	diadata.chapter_name = metadata_result[1]
	diadata.chapter_lang = metadata_result[2]
	diadata.chapter_author = metadata_result[3]
	diadata.chapter_desc = metadata_result[4]


	_scripts_info(path, 1, "章节ID：%s" % [diadata.chapter_id])
	_scripts_info(path, 2, "章节名称：%s" % [diadata.chapter_name])
	_scripts_info(path, 3, "章节语言：%s" % [diadata.chapter_lang])
	_scripts_info(path, 4, "章节作者：%s" % [diadata.chapter_author])
	_scripts_info(path, 5, "章节描述：%s" % [diadata.chapter_desc])

	# 清空演员验证表
	cur_tmp_actors = []

	# 只保留内容行
	var content_lines = lines.slice(5)

	tmp_content_lines = content_lines

	# 解析内容行
	for i in content_lines.size():
		tmp_line_number = i
		var line = content_lines[i]
		var original_line_number = 6 + i
		print("解析第%d行" % original_line_number)
		print("第%d行内容：" % original_line_number, line)
		tmp_original_line_number = original_line_number
		var dialog: Dialogue = parse_line(line, original_line_number, path)
		if dialog:
			# 如果是标签对话，则添加到标签对话字典中
			if dialog.dialog_type == Dialogue.Type.Tag:
				diadata.tag_dialogues.set(dialog.tag_id, dialog)
			else:
				diadata.dialogs.append(dialog)

	_scripts_info(path, 0, "文件：%s 剧情生成完毕 章节名称：%s 章节ID：%s 对话数量：%d" % 
		[path, diadata.chapter_name, diadata.chapter_id, diadata.dialogs.size()])

	tmp_path = ""

	if not _check_tag_and_choice():
		_scripts_debug(path, 0, "标签和选项解析失败")


	return diadata



# 单行解析模式
func parse_single_line(line: String, line_number: int, path: String) -> Dialogue:
	return parse_line(line.strip_edges(), line_number, path)

# 内部解析实现
func parse_line(line: String, line_number: int, path: String) -> Dialogue:
	# 不处理缩进的行
	if line.begins_with("    ") or line.begins_with("\t"):
		print("解析成功：忽略标签内缩进行\n")
		return null

	line = line.strip_edges()
	# 空行或注释行，必须提前处理strip_edges
	if line.is_empty() or line.begins_with("#"):
		print("解析成功：忽略空行或注释行\n")
		return null

	var dialog := Dialogue.new()
	dialog.source_file_line = line_number
	
	if _parse_background(line, dialog):
		print("解析成功：背景切换\n")
		return dialog
	if _parse_actor(line, dialog):
		print("解析成功：角色相关\n")
		return dialog
	if _parse_audio(line, dialog):
		print("解析成功：音频相关\n")
		return dialog
	if _parse_choice(line, dialog): 
		print("解析成功：选择相关\n")
		return dialog
	if _parse_jump(line, dialog):
		print("解析成功：跳转相关\n")
		return dialog
	if _parse_dialog(line, dialog):
		print("解析成功：对话相关\n")
		return dialog
	if _parse_end(line, dialog): 
		print("解析成功：结束相关\n")
		return dialog
	if _parse_start(line, dialog):
		print("解析成功：开始相关\n")
		return dialog
	if _parse_tag(line, dialog):
		print("解析成功：标签相关\n")
		return dialog

	dialog = null
	_scripts_tip(path, line_number, "解析失败：无法识别的语法，请检查语法是否正确或删除该行: %s" % line)
	print("\n")
	return null

# 解析元数据（前两行）
func _parse_metadata(lines: PackedStringArray, path: String) -> PackedStringArray:
	if lines.size() < 2:
		_scripts_debug(path, 1, "文件不完整，至少需要5行元数据")
		return []

	var metadata: PackedStringArray = []

	for i in 5:
		var result = dialogue_metadata_regex.search(lines[i])
		if not result:
			_scripts_debug(path, i + 1, "无效的元数据格式: %s" % lines[i])
			return []
		
		var key = result.get_string(1)
		var value = result.get_string(2)
		
		match key:
			"chapter_id":
				metadata.append(value)
			"chapter_name":
				metadata.append(value)
			"chapter_lang":
				metadata.append(value)
			"chapter_author":
				metadata.append(value)
			"chapter_desc":
				metadata.append(value)
	return metadata

# 背景切换解析
func _parse_background(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("background"):
		return false
	
	var parts = line.split(" ", false)
	if parts.size() < 2:
		return false

	dialog.dialog_type = Dialogue.Type.Switch_Background
	dialog.background_image_name = parts[1]
	
	if parts.size() >= 3:
		var effect = parts[2]
		dialog.background_toggle_effects = {
			"erase": ActingInterface.EffectsType.EraseEffect,
			"blinds": ActingInterface.EffectsType.BlindsEffect,
			"wave": ActingInterface.EffectsType.WaveEffect,
			"fade": ActingInterface.EffectsType.FadeInAndOut
		}.get(effect, ActingInterface.EffectsType.None)

	return true

# 角色相关解析
func _parse_actor(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("actor"):
		return false
	
	var parts = line.split(" ", false)
	if parts.size() < 3:
		return false

	match parts[1]:
		"show":
			dialog.dialog_type = Dialogue.Type.Display_Actor
			var actor = _create_actor(parts)
			if actor: 
				dialog.show_actor = actor
				# 添加检查功能
				if not cur_tmp_actors.has(actor.character_name):
					cur_tmp_actors.append(actor.character_name)
				else:
					_scripts_debug(tmp_path, tmp_original_line_number, "角色已存在，请检查角色名称是否重复创建")
		"exit":
			dialog.dialog_type = Dialogue.Type.Exit_Actor
			dialog.exit_actor = parts[2]
			# 添加检查功能
			if cur_tmp_actors.has(parts[2]):
				cur_tmp_actors.erase(parts[2])
			else:
				_scripts_debug(tmp_path, tmp_original_line_number, "无法移除不存在的角色，请检查角色名称是否正确")
		"change":
			dialog.dialog_type = Dialogue.Type.Actor_Change_State
			dialog.change_state_actor = parts[2]

			# 添加检查功能
			if not cur_tmp_actors.has(parts[2]):
				_scripts_debug(tmp_path, tmp_original_line_number, "无法改变不存在的角色的状态，请检查角色名称是否正确")
				
			dialog.change_state = parts[3]
		"move":
			dialog.dialog_type = Dialogue.Type.Move_Actor
			dialog.target_move_chara = parts[2]

			# 添加检查功能
			if not cur_tmp_actors.has(parts[2]):
				_scripts_debug(tmp_path, tmp_original_line_number, "无法移动不存在的角色的位置，请检查角色名称是否正确")

			dialog.target_move_pos = Vector2(parts[3].to_float(), parts[4].to_float())
	
	return true

# 创建角色
func _create_actor(parts: PackedStringArray) -> DialogueActor:
	if parts.size() < 8:
		return null
	
	var actor = DialogueActor.new()
	actor.character_name = parts[2]
	actor.character_state = parts[3]
	actor.actor_position = Vector2(parts[5].to_float(), parts[6].to_float())
	actor.actor_scale = parts[8].to_float()
	if parts.size() == 10:
		if parts[9] == "mirror":
			actor.actor_mirror = true
	return actor

# 音频解析
func _parse_audio(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("play") and not line.begins_with("stop"):
		return false
	
	var parts = line.split(" ", false)
	if parts[0] == "play":
		dialog.dialog_type = Dialogue.Type.Play_BGM if parts[1] == "bgm" else Dialogue.Type.Play_SoundEffect
		dialog["bgm_name" if parts[1] == "bgm" else "soundeffect_name"] = parts[2]
	else:
		dialog.dialog_type = Dialogue.Type.Stop_BGM
	
	return true

# 解析选项
func _parse_choice(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("choice"):
		return false
	
	dialog.dialog_type = Dialogue.Type.Show_Choice
	var choices = line.split(" ", false)
	for i in range(1, choices.size()):
		if i % 2 == 1 and i + 1 < choices.size():
			var choice = DialogueChoice.new()
			choice.choice_text = choices[i].trim_prefix("\"").trim_suffix("\"")
			choice.jump_tag = choices[i + 1]
			dialog.choices.append(choice)
	var choices_strs = ""
	for choice in dialog.choices:
		choices_strs += choice.choice_text + " "
	# 添加检查功能
	cur_tmp_option_lines[tmp_original_line_number] = line

	_scripts_info(tmp_path, tmp_line_number + 1, "选项解析完成" + " " + "选项数量" + str(dialog.choices.size()) +  "  选项： " + choices_strs)
	return true

# 解析标签
func _parse_tag(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("tag"):
		return false
	
	var parts = line.split(" ", false)
	if parts.size() < 2:
		_scripts_debug(tmp_path, tmp_original_line_number, "tag标签格式错误")
		return false
	dialog.dialog_type = Dialogue.Type.Tag
	dialog.tag_id = parts[1]

	var tag_inner_line_number = tmp_line_number + 1

	# 遍历标签内的行(缩进)
	while tag_inner_line_number < tmp_content_lines.size():
		var inner_line = tmp_content_lines[tag_inner_line_number].strip_edges()

		# 检查缩进
		if tmp_content_lines[tag_inner_line_number].begins_with("    ") or tmp_content_lines[tag_inner_line_number].begins_with("\t"):
			tag_inner_line_number += 1
			if not (inner_line.is_empty() or inner_line.begins_with("#")):
				if (inner_line.begins_with("tag")):
					_scripts_debug(tmp_path, tag_inner_line_number + 5, "tag标签内不能嵌套标签")
					return false
				var inner_dialog = parse_line(inner_line, tag_inner_line_number + 5, tmp_path)
				dialog.tag_dialogue.append(inner_dialog)
				pass
		else:
			break

	tmp_tags.append(dialog.tag_id)

	_scripts_info(tmp_path, tmp_original_line_number, "标签" + dialog.tag_id + "解析完成" + " " + "标签内有" + str(dialog.tag_dialogue.size()) + "行对话")

	return true

# 跳转解析
func _parse_jump(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("jump"):
		return false
	
	var parts = line.split(" ", false)
	dialog.dialog_type = Dialogue.Type.JUMP
	dialog.jump_data_name = parts[1]
	return true

# 对话解析（使用正则表达式优化）
func _parse_dialog(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("\""):
		return false
	
	var result = dialogue_content_regex.search(line)
	if not result:
		return false
	
	dialog.dialog_type = Dialogue.Type.Ordinary_Dialog
	dialog.character_id = result.get_string(1)
	dialog.dialog_content = result.get_string(2)
	if result.get_string(3):
		dialog.voice_id = result.get_string(3)
	
	return true

# 检查tag和choice
func _check_tag_and_choice() -> bool:
	var target_jump_tag = []

	for line in cur_tmp_option_lines:
		var choices = cur_tmp_option_lines[line].split(" ", false)
		for i in range(1, choices.size()):
			if i % 2 == 1 and i + 1 < choices.size():
				target_jump_tag.append(choices[i + 1])
		for tar in target_jump_tag:
			if not tmp_tags.has(tar):
				_scripts_debug(tmp_path, line, "跳转标签" + tar + "不存在")
				return false
		target_jump_tag = []
	return true


# 解析开始
func _parse_start(line: String, dialog: Dialogue) -> bool:
	if line.begins_with("start"):
		dialog.dialog_type = Dialogue.Type.START
		return true
	return false
	
# 解析结束
func _parse_end(line: String, dialog: Dialogue) -> bool:
	if line.begins_with("end"):
		dialog.dialog_type = Dialogue.Type.THE_END
		return true
	return false


# 错误报告
func _scripts_debug(path: String, line: int, error_info: String):
	push_error("错误：%s [行：%d] %s " % [path, line, error_info])


# 警告提示
func _scripts_tip(path: String, line: int, warning_info: String):
	push_warning("警告：%s [行：%d] %s " % [path, line, warning_info])

# 信息提示
func _scripts_info(path: String, line: int, info_info: String):
	print("信息：%s [行：%d] %s " % [path, line, info_info])
