@tool
extends RefCounted
class_name KonadoScriptsInterpreter

## Konado脚本解释器

## 是否初始化完成
var is_init: bool = false

## 源文件脚本路径
var tmp_path = ""
## 源文件脚本行，显示在编辑器中
var tmp_original_line_number = 0
## 当前脚本行，经过处理后的行
var tmp_line_number = 0
var tmp_content_lines = []

## 对话内容正则表达式
var dialogue_content_regex: RegEx
## 元数据正则表达式
var dialogue_metadata_regex: RegEx

## 演员验证表
var cur_tmp_actors = []

## 角色依赖记录，出现的角色将记录下来
var dep_characters: Array[String] = []

## 选项行记录表 key: 行号 value: 行内容
var cur_tmp_option_lines = {}
var tmp_tags = []

# ====================== 编译选项 ====================== #

## 是否允许自定义后缀脚本，开启后将不强制要求使用ks作为脚本文件后缀
var allow_custom_suffix: bool = false

## 是否允许跳过错误语法行，开启后将跳过错误语法行，继续解析后续语法，只打印警告信息
var allow_skip_error_line: bool = false

## 是否开启演员验证，开启后将针对所有演员语法进行验证，判断是否存在
var enable_actor_validation: bool = true

# ====================================================== #


## 初始化解释器
func _init(flags: Dictionary[String, Variant]) -> void:
	is_init = false
	if flags.has("allow_custom_suffix"):
		if flags["allow_custom_suffix"] is not bool:
			_scripts_debug(tmp_path, tmp_original_line_number, "allow_custom_suffix选项类型错误，应为bool类型")
			return
		allow_custom_suffix = flags["allow_custom_suffix"] as bool
	if flags.has("allow_skip_error_line"):
		if flags["allow_skip_error_line"] is not bool:
			_scripts_debug(tmp_path, tmp_original_line_number, "allow_skip_error_line选项类型错误，应为bool类型")
			return
		allow_skip_error_line = flags["allow_skip_error_line"] as bool
	if flags.has("enable_actor_validation"):
		if flags["enable_actor_validation"] is not bool:
			_scripts_debug(tmp_path, tmp_original_line_number, "enable_actor_validation选项类型错误，应为bool类型")
			return
		enable_actor_validation = flags["enable_actor_validation"] as bool
		
	# 提前初始化正则表达式，避免重复编译
	dialogue_content_regex = RegEx.new()
	dialogue_content_regex.compile("^\"(.*?)\"\\s+\"(.*?)\"(?:\\s+(\\S+))?$")

	dialogue_metadata_regex = RegEx.new()
	dialogue_metadata_regex.compile("^(shot_id)\\s+(\\S+)")
	
	is_init = true
	print("解释器初始化完成" + " " + "flags: " + str(flags))
	
## 全文解析模式
func process_scripts_to_data(path: String) -> KND_Shot:
	if not is_init:
		_scripts_debug(path, 0, "解释器未初始化，无法解析脚本文件")
		return
	if not path:
		_scripts_debug(path, 0, "路径为空，无法打开脚本文件")
		return null

	if not FileAccess.file_exists(path):
		_scripts_debug(path, 0, "文件不存在，无法打开脚本文件")
		return null

	if not path.ends_with(".ks"):
		if allow_custom_suffix:
			_scripts_warning(path, 0, "建议使用使用ks作为脚本文件后缀")
		else:
			_scripts_debug(path, 0, "编译器要求使用ks作为脚本文件后缀，如果需要使用自定义后缀，请开启allow_custom_suffix选项")
			return null

	tmp_path = path

	# 读取文件内容
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		_scripts_debug(path, 0, "无法打开脚本文件")
		return null
	var lines = file.get_as_text().split("\n")
	file.close()

	
	_scripts_info(path, 0, "开始解析脚本文件")

	var diadata: KND_Shot = KND_Shot.new()

	# 解析元数据
	var metadata_result = _parse_metadata(lines, path)
	dialogue_metadata_regex = null
	if not metadata_result:
		_scripts_debug(path, 0, "元数据解析失败")
		return diadata
	diadata.shot_id = metadata_result[0]


	_scripts_info(path, 1, "Shot id：%s" % [diadata.shot_id])

	# 清空演员验证表
	cur_tmp_actors = []

	# 只保留内容行
	var content_lines = lines.slice(1)

	tmp_content_lines = content_lines

	# 解析内容行
	for i in content_lines.size():
		tmp_line_number = i
		var line = content_lines[i]
		var original_line_number =  i + 2

		tmp_original_line_number = original_line_number

		# 不处理缩进的行
		if line.begins_with("    ") or line.begins_with("\t"):
			#print("解析成功：忽略标签内缩进行\n")
			continue
		line = line.strip_edges()
		# 空行或注释行，必须提前处理strip_edges
		if line.is_empty():
			#print("解析成功：忽略空行\n")
			continue
		if line.begins_with("#") or line.begins_with("##"):
			#_scripts_debug(path, original_line_number, "注释行请用 ## 代替 #：%s" % line)
			continue

		print("解析第%d行" % original_line_number)
		print("第%d行内容：" % original_line_number, line)

		var dialog: Dialogue = parse_line(line, original_line_number, path)
		if dialog:
			# 如果是标签对话，则添加到标签对话字典中
			if dialog.dialog_type == Dialogue.Type.Branch:
				diadata.source_branches.set(dialog.branch_id, dialog.serialize_to_dict())
			else:
				var dialogue_dic: Dictionary = dialog.serialize_to_dict()
				diadata.dialogues_source_data.append(dialogue_dic)
		else:
			if allow_skip_error_line:
				_scripts_warning(path, original_line_number, "解析失败：无法识别的语法，请检查语法是否正确或删除该行: %s" % line)
				continue
			else:
				_scripts_debug(path, original_line_number, "解析失败：无法识别的语法，请检查语法是否正确或删除该行: %s" % line)
				break
			print("\n")
			
	diadata.get_dialogues()
	

	_scripts_info(path, 0, "文件：%s 章节ID：%s 对话数量：%d" % 
		[path, diadata.shot_id, diadata.dialogues.size()])

	tmp_path = ""

	if not _check_tag_and_choice():
		_scripts_debug(path, 0, "标签和选项解析失败")

	# 生成演员快照
	var cur_actor_dic: Dictionary = {}
	for dialogue in diadata.get_dialogues():
		#print("当前演员快照：", cur_actor_dic)
		if dialogue.dialog_type == Dialogue.Type.Display_Actor:
				var actor: DialogueActor = dialogue.show_actor
				var chara_dict := {
					"id": actor.character_name,
					"x": actor.actor_position.x,
					"y": actor.actor_position.y,
					"state": actor.character_state,
					"c_scale": actor.actor_scale,
					"mirror": actor.actor_mirror
					}
				cur_actor_dic[actor.character_name] = chara_dict
		if dialogue.dialog_type == Dialogue.Type.Exit_Actor:
			if cur_actor_dic.has(dialogue.exit_actor):
				cur_actor_dic.erase(dialogue.exit_actor)
		if dialogue.dialog_type == Dialogue.Type.Actor_Change_State:
			if cur_actor_dic.has(dialogue.change_state_actor):
				cur_actor_dic[dialogue.change_state_actor]["state"] = dialogue.change_state
		if dialogue.dialog_type == Dialogue.Type.Move_Actor:
			if cur_actor_dic.has(dialogue.target_move_chara):
				cur_actor_dic[dialogue.target_move_chara]["x"] = dialogue.target_move_pos.x
				cur_actor_dic[dialogue.target_move_chara]["y"] = dialogue.target_move_pos.y
		dialogue.actor_snapshots = cur_actor_dic
	
	return diadata

# 单行解析模式
func parse_single_line(line: String, line_number: int, path: String) -> Dialogue:
	return parse_line(line.strip_edges(), line_number, path)

# 内部解析实现
func parse_line(line: String, line_number: int, path: String) -> Dialogue:
	var dialog := Dialogue.new()
	dialog.source_file_line = line_number
	
	#if _parse_label(line, dialog):
		#print("解析成功：注释相关\n")
		#return dialog
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
	if _parse_jumpshot(line, dialog):
		print("解析成功：跳转镜头相关\n")
		return dialog
	if _parse_dialog(line, dialog):
		print("解析成功：对话相关\n")
		return dialog
	if _parse_end(line, dialog): 
		print("解析成功：结束相关\n")
		return dialog
	if _parse_branch(line, dialog):
		print("解析成功：标签相关\n")
		return dialog

	dialog = null

	return null

# 解析元数据（前两行）
func _parse_metadata(lines: PackedStringArray, path: String) -> PackedStringArray:
	if lines.size() < 2:
		_scripts_debug(path, 1, "文件不完整，至少需要shot id")
		return []

	var metadata: PackedStringArray = []

	if lines[0]:
		var result = dialogue_metadata_regex.search(lines[0])
		if not result:
			_scripts_debug(path, 1, "无效的元数据格式: %s" % lines[0])
			return []
		
		var key = result.get_string(1)
		var value = result.get_string(2)
		
		match key:
			"shot_id":
				metadata.append(value)
	return metadata

	

# 解析注释
#func _parse_label(line: String, dialog: Dialogue) -> bool:
	#if not line.begins_with("##"):
		#return false
#
	#dialog.dialog_type = Dialogue.Type.LABEL
	#dialog.label_notes = line.replace("##", "").strip_edges()
#
	#return true

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
			"none": ActingInterface.BackgroundTransitionEffectsType.NONE_EFFECT,
			"erase": ActingInterface.BackgroundTransitionEffectsType.EraseEffect,
			"blinds": ActingInterface.BackgroundTransitionEffectsType.BlindsEffect,
			"wave": ActingInterface.BackgroundTransitionEffectsType.WaveEffect,
			"fade": ActingInterface.BackgroundTransitionEffectsType.ALPHA_FADE_EFFECT,
			"vortex": ActingInterface.BackgroundTransitionEffectsType.VORTEX_SWAP_EFFECT,
			"windmill": ActingInterface.BackgroundTransitionEffectsType.WINDMILL_EFFECT,
			"cyberglitch": ActingInterface.BackgroundTransitionEffectsType.CYBER_GLITCH_EFFECT
		}.get(effect, ActingInterface.BackgroundTransitionEffectsType.NONE_EFFECT)

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
				if not dep_characters.has(actor.character_name):
					dep_characters.append(actor.character_name)
				# 添加检查功能
				if enable_actor_validation:
					if not cur_tmp_actors.has(actor.character_name):
						cur_tmp_actors.append(actor.character_name)
					else:
						_scripts_debug(tmp_path, tmp_original_line_number, "角色已存在，请检查角色名称是否重复创建")
						return false
		"exit":
			dialog.dialog_type = Dialogue.Type.Exit_Actor
			dialog.exit_actor = parts[2]
			# 添加检查功能
			if enable_actor_validation:
				if cur_tmp_actors.has(parts[2]):
					cur_tmp_actors.erase(parts[2])
				else:
					_scripts_debug(tmp_path, tmp_original_line_number, "无法移除不存在的角色，请检查角色名称是否正确")
		"change":
			dialog.dialog_type = Dialogue.Type.Actor_Change_State
			dialog.change_state_actor = parts[2]

			# 添加检查功能
			if enable_actor_validation:
				if not cur_tmp_actors.has(parts[2]):
					_scripts_debug(tmp_path, tmp_original_line_number, "无法改变不存在的角色的状态，请检查角色名称是否正确")
				
			dialog.change_state = parts[3]
		"move":
			dialog.dialog_type = Dialogue.Type.Move_Actor
			dialog.target_move_chara = parts[2]

			# 添加检查功能
			if enable_actor_validation:
				if not cur_tmp_actors.has(parts[2]):
					_scripts_debug(tmp_path, tmp_original_line_number, "无法移动不存在的角色的位置，请检查角色名称是否正确")

			dialog.target_move_pos = Vector2(parts[3].to_float(), parts[4].to_float())
	
	return true

# 创建角色
func _create_actor(parts: PackedStringArray) -> DialogueActor:
	if parts.size() < 9:
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
		if parts[1] == "bgm":
			dialog.dialog_type = Dialogue.Type.Play_BGM 
		elif parts[1] == "sfx":
			dialog.dialog_type = Dialogue.Type.Play_SoundEffect
		dialog["bgm_name" if parts[1] == "bgm" else "soundeffect_name"] = parts[2]
	elif parts[0] == "stop":
		dialog.dialog_type = Dialogue.Type.Stop_BGM
	
	return true

# 解析选项
func _parse_choice(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("choice"):
		return false
	
	dialog.dialog_type = Dialogue.Type.Show_Choice
	dialog.choices.clear()  # 清空现有选项
	
	# 移除开头的"choice"关键字
	var content = line.substr(6).strip_edges()
	
	# 使用正则表达式来正确解析带引号的字符串
	var regex = RegEx.new()
	regex.compile('"([^"\\\\]*(?:\\\\.[^"\\\\]*)*)"|(\\S+)')
	
	var matches = regex.search_all(content)
	var parts = []
	
	for match in matches:
		if match.get_string(1) != "":  # 带引号的部分
			# 恢复转义的引号
			var text = match.get_string(1).replace('\\"', '"')
			parts.append(text)
		elif match.get_string(2) != "":  # 无引号的部分
			parts.append(match.get_string(2))
	
	# 验证parts数量
	if parts.size() % 2 != 0:
		_scripts_debug(tmp_path, tmp_original_line_number, "选项格式错误: 每个选项必须包含文本和跳转标签")
		return false
	
	# 创建选项对象
	for i in range(0, parts.size(), 2):
		var choice = DialogueChoice.new()
		choice.choice_text = parts[i]
		choice.jump_tag = parts[i + 1]
		dialog.choices.append(choice)
	
	# 记录日志
	var choices_strs = ""
	for choice in dialog.choices:
		choices_strs += "\"" + choice.choice_text + "\" -> " + choice.jump_tag + "  "
	
	# 记录跳转标签用于后续验证
	var jump_tags = []
	for choice in dialog.choices:
		jump_tags.append(choice.jump_tag)
	cur_tmp_option_lines[tmp_original_line_number] = jump_tags
	
	_scripts_info(tmp_path, tmp_line_number + 1, "选项解析完成 选项数量: " + str(dialog.choices.size()) + "  选项: " + choices_strs)
	return true

# 分支解析
func _parse_branch(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("branch"):
		return false
	
	var parts = line.split(" ", false)
	if parts.size() < 2:
		_scripts_debug(tmp_path, tmp_original_line_number, "branch格式错误")
		return false
	dialog.dialog_type = Dialogue.Type.Branch
	dialog.branch_id = parts[1]

	var tag_inner_line_number = tmp_line_number + 1
	var expected_indent = "    "  # 预期的缩进（4个空格或制表符）

	# 遍历标签内的行(缩进)
	while tag_inner_line_number < tmp_content_lines.size():
		var original_line = tmp_content_lines[tag_inner_line_number]
		var inner_line = original_line.strip_edges()
		
		# 检查是否为空行或只有空白字符的行
		if inner_line.is_empty():
			tag_inner_line_number += 1
			continue  # 跳过空行但继续处理后续内容
		
		# 检查缩进，允许4个空格或制表符
		if not (original_line.begins_with("    ") or original_line.begins_with("\t")):
			break  # 没有缩进，结束分支内容
		
		tag_inner_line_number += 1
		
		if inner_line.begins_with("branch"):
			_scripts_debug(tmp_path, tag_inner_line_number, "branch内不能嵌套branch")
			return false
		
		var inner_dialog = parse_line(inner_line, tag_inner_line_number, tmp_path)
		if inner_dialog:
			dialog.branch_dialogue.append(inner_dialog)

	tmp_tags.append(dialog.branch_id)

	_scripts_info(tmp_path, tmp_original_line_number, "标签" + dialog.branch_id + "解析完成" + " " + "标签内有" + str(dialog.branch_dialogue.size()) + "行对话")

	return true

# 跳转解析
func _parse_jumpshot(line: String, dialog: Dialogue) -> bool:
	if not line.begins_with("jump"):
		return false
	
	var parts = line.split(" ", false)
	dialog.dialog_type = Dialogue.Type.JUMP_Shot
	dialog.jump_shot_id = parts[1]
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
# 检查tag和choice
func _check_tag_and_choice() -> bool:
	for line_num in cur_tmp_option_lines:
		var jump_tags = cur_tmp_option_lines[line_num] as Array
		for tag in jump_tags:
			if not tmp_tags.has(tag):
				_scripts_debug(tmp_path, line_num, "跳转标签 '" + tag + "' 不存在")
				return false
	return true

	
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
func _scripts_warning(path: String, line: int, warning_info: String):
	push_warning("警告：%s [行：%d] %s " % [path, line, warning_info])

# 信息提示
func _scripts_info(path: String, line: int, info_info: String):
	print("信息：%s [行：%d] %s " % [path, line, info_info])
