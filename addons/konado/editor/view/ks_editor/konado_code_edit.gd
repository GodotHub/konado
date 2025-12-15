@tool
extends CodeEdit
class_name KonadoCodeEdit

## 已知的角色列表
#var known_characters := ["alice", "bob", "eve", "narrator"]
## 已知的背景列表
#var known_backgrounds := ["forest_bg", "village_bg", "castle_bg", "cave_bg"]
## 已知的状态列表
#var known_states := ["happy", "sad", "angry", "neutral", "surprised"]
## 已知的音频列表
#var known_bgms := ["main_theme", "battle_theme", "peaceful"]
#var known_sounds := ["click", "door_open", "footsteps"]
## 已知的镜头ID列表
#var known_shot_ids := ["opening_scene", "forest_path", "village_stay"]

func _ready():
	#print(self.get_path())
	# 启用代码补全
	self.code_completion_enabled = true
	# 设置触发补全的前缀（空格和引号）
	code_completion_prefixes = [" ", "\""]
	
	clear_string_delimiters()
	# 添加字符串分隔符（双引号）
	add_string_delimiter("\"", "\"", false)

	text_changed.connect(_on_text_changed)
	
	# 连接信号
	#code_completion_requested.connect(_on_code_completion_requested)

func _on_text_changed():
	# print("Text changed")
	self.request_code_completion()

func _request_code_completion(_force: bool):
	var current_line = get_caret_line()
	var current_column = get_caret_column()
	var line_text = get_line(current_line)
	
	# 获取当前单词（光标前的部分）
	var current_word := ""
	for i in range(current_column - 1, -1, -1):
		if line_text[i] in [" ", "\t", "\n", "\""]:
			break
		current_word = line_text[i] + current_word
	
	# 根据上下文提供补全建议
	var candidates = _get_completion_candidates(current_line, line_text, current_word)
	
	# 清除现有补全选项
	cancel_code_completion()
	
	# 添加新的补全选项
	for candidate in candidates:
		add_code_completion_option(
			candidate.get("kind", CodeCompletionKind.KIND_PLAIN_TEXT),
			candidate.display_text,
			candidate.insert_text,
			candidate.get("color", Color(1, 1, 1)),
			candidate.get("icon", null),
			candidate.get("value", null),
			candidate.get("location", CodeCompletionLocation.LOCATION_LOCAL)
		)
	
	# 更新补全选项
	update_code_completion_options(false)

func _get_completion_candidates(line: int, line_text: String, current_word: String) -> Array:
	var candidates := []
	
	## 第一行应该是shot_id
	if line == 0 and line_text.strip_edges().is_empty():
		candidates.append({
			"kind": CodeCompletionKind.KIND_CONSTANT,
			"display_text": "shot_id",
			"insert_text": "shot_id your_shot_name",
			"color": Color(0.8, 0.5, 1.0)
		})
		return candidates
	
	# 分析当前行已输入的内容
	var tokens = line_text.strip_edges().split(" ", false)
	
	# 空行或只有部分内容
	if tokens.size() == 0:
		return _get_root_commands()
	
	# 根据第一个token决定补全类型
	match tokens[0]:
		"shot_id":
			if tokens.size() == 1:
				# 补全已知的镜头ID
				#for shot_id in known_shot_ids:
					#candidates.append({
						#"kind": CodeCompletionKind.KIND_CONSTANT,
						#"display_text": shot_id,
						#"insert_text": shot_id,
						#"color": Color(0.6, 0.8, 1.0)
					#})
				pass
		"background":
			if tokens.size() == 1:
				# 补全背景名称
				#for bg in known_backgrounds:
					#candidates.append({
						#"kind": CodeCompletionKind.KIND_CONSTANT,
						#"display_text": bg,
						#"insert_text": bg + " ",
						#"color": Color(0.8, 0.8, 0.6)
					#})
				pass
			elif tokens.size() == 2:
				# 补全效果类型
				var effects = [
					"none",
					"erase", 
					"blinds", 
					"wave", 
					"fade", 
					"vortex",
					"windmill", 
					"cyberglitch"]
				for effect in effects:
					candidates.append({
						"kind": CodeCompletionKind.KIND_CONSTANT,
						"display_text": effect,
						"insert_text": effect,
						"color": Color(0.7, 0.9, 0.7)
					})
		"actor":
			if tokens.size() == 1:
				# 补全actor子命令
				var subcommands = ["show", "exit", "change", "move"]
				for cmd in subcommands:
					candidates.append({
						"kind": CodeCompletionKind.KIND_FUNCTION,
						"display_text": cmd,
						"insert_text": cmd + " ",
						"color": Color(0.9, 0.7, 0.7)
					})
			elif tokens.size() >= 2:
				match tokens[1]:
					"show", "change", "exit", "move":
						if tokens.size() == 2:
							# 补全角色名称
							#for char_name in known_characters:
								#candidates.append({
									#"kind": CodeCompletionKind.KIND_VARIABLE,
									#"display_text": char_name,
									#"insert_text": char_name + " ",
									#"color": Color(0.7, 0.8, 0.9)
								#})
							pass
						elif tokens.size() == 3 and tokens[1] == "show":
							# 补全角色状态
							#for state in known_states:
								#candidates.append({
									#"kind": CodeCompletionKind.KIND_CONSTANT,
									#"display_text": state,
									#"insert_text": state + " ",
									#"color": Color(0.8, 0.9, 0.7)
								#})
							pass
						elif tokens.size() == 4 and tokens[1] == "show" and tokens[3] == "at":
							# 补全坐标和scale关键字
							candidates.append({
								"kind": CodeCompletionKind.KIND_PLAIN_TEXT,
								"display_text": "x y scale",
								"insert_text": "x y scale ",
								"color": Color(0.8, 0.8, 0.8)
							})
		"play":
			if tokens.size() == 1:
				# 补全play子命令
				var subcommands = ["bgm", "sound"]
				for cmd in subcommands:
					candidates.append({
						"kind": CodeCompletionKind.KIND_FUNCTION,
						"display_text": cmd,
						"insert_text": cmd + " ",
						"color": Color(0.7, 0.9, 0.9)
					})
			elif tokens.size() == 2:
				match tokens[1]:
					"bgm":
						# 补全BGM名称
						#for bgm in known_bgms:
							#candidates.append({
								#"kind": CodeCompletionKind.KIND_CONSTANT,
								#"display_text": bgm,
								#"insert_text": bgm,
								#"color": Color(0.9, 0.8, 0.6)
							#})
						pass
					"sound":
						# 补全音效名称
						#for sound in known_sounds:
							#candidates.append({
								#"kind": CodeCompletionKind.KIND_CONSTANT,
								#"display_text": sound,
								#"insert_text": sound,
								#"color": Color(0.8, 0.6, 0.9)
							#})
						pass
		"stop":
			if tokens.size() == 1:
				candidates.append({
					"kind": CodeCompletionKind.KIND_FUNCTION,
					"display_text": "bgm",
					"insert_text": "bgm",
					"color": Color(0.9, 0.7, 0.7)
				})
		"choice":
			if tokens.size() == 1:
				candidates.append({
					"kind": CodeCompletionKind.KIND_PLAIN_TEXT,
					"display_text": "\"option_text\" jump_label ...",
					"insert_text": "\"\"  \"\" ",
					"color": Color(0.8, 0.8, 0.8)
				})
		"branch":
			if tokens.size() == 1:
				# 补全分支标签（这里需要从文件中提取已知标签）
				candidates.append({
					"kind": CodeCompletionKind.KIND_CONSTANT,
					"display_text": "branch_name",
					"insert_text": "branch_name",
					"color": Color(0.7, 0.8, 0.9)
				})
		"jump":
			if tokens.size() == 1:
				# 补全跳转目标（这里需要从文件中提取已知shot_id）
				#for shot_id in known_shot_ids:
					#candidates.append({
						#"kind": CodeCompletionKind.KIND_CONSTANT,
						#"display_text": shot_id,
						#"insert_text": shot_id,
						#"color": Color(0.6, 0.8, 1.0)
					#})
				pass
		_:
			# 检查是否以引号开头（对话行）
			if line_text.begins_with("\"") and not line_text.ends_with("\""):
				var quote_pos = line_text.find("\"")
				var second_quote_pos = line_text.find("\"", quote_pos + 1)
				
				if second_quote_pos == -1:
					# 第一个引号后没有第二个引号，补全角色ID
					#for char_name in known_characters:
						#if char_name.begins_with(current_word):
							#candidates.append({
								#"kind": CodeCompletionKind.KIND_VARIABLE,
								#"display_text": char_name,
								#"insert_text": char_name + "\" \"",
								#"color": Color(0.7, 0.8, 0.9)
							#})
					pass
				else:
					# 已有角色ID，补全语音ID（可选）
					pass
			
			# 如果不是以任何关键字开头，提供根命令补全
			elif tokens.size() == 1 and current_word != "":
				candidates = _get_root_commands()
	
	return candidates

func _get_root_commands() -> Array:
	var commands := []
	
	var root_commands = {
		"shot_id": {"kind": CodeCompletionKind.KIND_CONSTANT, "color": Color(0.8, 0.5, 1.0)},
		"background": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.8, 0.8, 0.6)},
		"actor": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.9, 0.7, 0.7)},
		"play": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.7, 0.9, 0.9)},
		"stop": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.9, 0.7, 0.7)},
		"choice": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.8, 0.9, 0.8)},
		"branch": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.7, 0.8, 0.9)},
		"jump": {"kind": CodeCompletionKind.KIND_FUNCTION, "color": Color(0.6, 0.8, 1.0)},
		"start": {"kind": CodeCompletionKind.KIND_CONSTANT, "color": Color(0.5, 0.9, 0.5)},
		"end": {"kind": CodeCompletionKind.KIND_CONSTANT, "color": Color(0.9, 0.5, 0.5)}
	}
	
	for cmd in root_commands:
		commands.append({
			"kind": root_commands[cmd].kind,
			"display_text": cmd,
			"insert_text": cmd + " ",
			"color": root_commands[cmd].color
		})
	
	return commands

func _confirm_code_completion(replace: bool):
	# 获取当前选中的补全选项
	var selected_index = get_code_completion_selected_index()
	var option = get_code_completion_option(selected_index)
	
	# 插入文本
	var _text_to_insert = option["insert_text"]
	
	if replace:
		# 替换当前单词
		var current_line = get_caret_line()
		var current_column = get_caret_column()
		var line_text = get_line(current_line)
		
		# 找到当前单词的起始位置
		var word_start = current_column - 1
		while word_start >= 0 and line_text[word_start] not in [" ", "\t", "\n", "\""]:
			word_start -= 1
		
		# 选择当前单词
		set_caret_line(current_line)
		set_caret_column(word_start + 1)
		select(current_line, word_start + 1, current_line, current_column)
		
		# 替换选中文本
		insert_text_at_caret(_text_to_insert)
	else:
		# 直接插入文本
		insert_text_at_caret(_text_to_insert)
	
	# 取消补全
	cancel_code_completion()
