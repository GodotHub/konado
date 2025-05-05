@tool
extends Node

# Konado脚本解释器

# 全文解析模式
func process_scripts_to_data(path: String) -> DialogueData:
	var diadata = DialogueData.new()
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return diadata
	
	var lines = file.get_as_text().split("\n")
	file.close()

	# 解析元数据
	var metadata_result = _parse_metadata(lines, path)
	if not metadata_result:
		return diadata
	
	diadata.chapter_id = metadata_result[0]
	diadata.chapter_name = metadata_result[1]
	var content_lines = lines.slice(2)

	# 解析内容行
	for i in content_lines.size():
		var line = content_lines[i].strip_edges()
		var original_line_number = 3 + i
		var dialog = parse_line(line, original_line_number, path)
		if dialog:
			diadata.dialogs.append(dialog)

	print_rich("[color=cyan]文件：[/color]%s [color=cyan]剧情预生成完毕 (｀・ω・´)[/color] 章节名称：%s 章节ID：%s 对话数量：%d" % 
		[path, diadata.chapter_name, diadata.chapter_id, diadata.dialogs.size()])
	return diadata

# 单行解析模式（line_number从3开始对应原始文件第三行）
func parse_single_line(line: String, line_number: int, path: String) -> Dialogue:
	return parse_line(line.strip_edges(), line_number, path)

# 内部解析实现
func parse_line(line: String, line_number: int, path: String) -> Dialogue:
	if line.is_empty() or line.begins_with("#"):
		return null

	var dialog := Dialogue.new()
	
	# 使用快速返回模式提升性能
	if _parse_background(line, dialog): return dialog
	if _parse_actor(line, dialog): return dialog
	if _parse_audio(line, dialog): return dialog
	if _parse_tag(line, dialog): return dialog
	if _parse_choice(line, dialog): return dialog
	if _parse_jump(line, dialog): return dialog
	if _parse_dialog(line, dialog): return dialog
	if _parse_special(line, dialog): return dialog

	_scripts_tip(path, line_number, "无法识别的语法: %s" % line)
	return null

# 解析元数据（前两行）
func _parse_metadata(lines: PackedStringArray, path: String) -> PackedStringArray:
	if lines.size() < 2:
		_scripts_debug(path, 1, "文件不完整，至少需要两行元数据")
		return []

	# 解析章节ID
	if not lines[0].begins_with("chapter_id"):
		_scripts_debug(path, 1, "缺失章节ID")
		return []
	var chapter_id = lines[0].split(" ", false)[1]

	# 解析章节名称
	if not lines[1].begins_with("chapter_name"):
		_scripts_debug(path, 2, "缺失章节名称")
		return []
	var chapter_name = lines[1].split(" ", false)[1]

	return [chapter_id, chapter_name]

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
			if actor: dialog.show_actor = actor
		"exit":
			dialog.dialog_type = Dialogue.Type.Exit_Actor
			dialog.exit_actor = parts[2]
		"change":
			dialog.dialog_type = Dialogue.Type.Actor_Change_State
			dialog.change_state_actor = parts[2]
			dialog.change_state = parts[3]
		"move":
			dialog.dialog_type = Dialogue.Type.Move_Actor
			dialog.target_move_chara = parts[2]
			dialog.target_move_pos = Vector2(parts[3].to_float(), parts[4].to_float())
	
	return true

func _create_actor(parts: PackedStringArray) -> DialogueActor:
	if parts.size() < 8:
		return null
	
	var actor = DialogueActor.new()
	actor.character_name = parts[2]
	actor.character_state = parts[3]
	actor.actor_position = Vector2(parts[5].to_float(), parts[6].to_float())
	actor.actor_scale = parts[7].to_float()
	return actor

# 音频解析
func _parse_audio(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("play") and not line.begins_with("stop"):
		return false
	
	var parts = line.split(" ", false)
	if parts[0] == "play":
		dialog.dialog_type = Dialogue.Type.Play_BGM if parts[1] == "bgm" else Dialogue.Type.Play_SoundEffect
		dialog[ "bgm_name" if parts[1] == "bgm" else "soundeffect_name"] = parts[2]
	else:
		dialog.dialog_type = Dialogue.Type.Stop_BGM
	
	return true

# 选项解析
func _parse_choice(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("choice"):
		return false
	
	dialog.dialog_type = Dialogue.Type.Show_Choice
	var choices = line.split(" ", false)
	for i in range(1, choices.size()):
		if i % 2 == 1 and i + 1 < choices.size():
			var choice = DialogueChoice.new()
			choice.choice_text = choices[i].trim_prefix("\"").trim_suffix("\"")
			choice.jumpdata_id = choices[i + 1]
			dialog.choices.append(choice)
	
	return true

# 解析标签
func _parse_tag(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("tag"):
		return false
	
	var parts = line.split(" ", false)
	dialog.dialog_type = Dialogue.Type.Tag
	dialog.tag_id = parts[1]
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
	
	var regex = RegEx.new()
	regex.compile("^\"(.*?)\"\\s+\"(.*?)\"(?:\\s+(\\S+))?$")
	var result = regex.search(line)
	if not result:
		return false
	
	dialog.dialog_type = Dialogue.Type.Ordinary_Dialog
	dialog.character_id = result.get_string(1)
	dialog.dialog_content = result.get_string(2)
	if result.get_string(3):
		dialog.voice_id = result.get_string(3)
	
	return true

# 特殊指令解析
func _parse_special(line: String, dialog: Dialogue) -> bool:
	if line.begins_with("unlock_achievement"):
		dialog.dialog_type = Dialogue.Type.UNLOCK_ACHIEVEMENTS
		dialog.achievement_id = line.split(" ", false)[1]
		return true
	if line.begins_with("end"):
		dialog.dialog_type = Dialogue.Type.THE_END
		return true
	return false

# 错误报告
func _scripts_debug(path: String, line: int, error_info: String):
	print_rich("[color=red]错误：[/color]%s [行：%d] %s" % [path, line, error_info])

# 警告提示
func _scripts_tip(path: String, line: int, warning_info: String):
	print_rich("[color=yellow]警告：[/color]%s [行：%d] %s" % [path, line, warning_info])
