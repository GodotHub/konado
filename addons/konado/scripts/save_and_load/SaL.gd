extends Node

const SAVE_DIR := "user://saves/"#存档文件夹路径
const SLOT_PREFIX := "save_"#存档文件前缀

#存档用变量
var chara_disc : Dictionary
var chapter_id : String
var background_id : String
var bgm_id : String
var bgm_progress : String
var voice_id : String
var sound_effect_id : String
var curline : int

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	#固定路径

func _save_game(slot_id: int) -> void:#保存数据，需要传入槽位ID
	var data_to_save = _collect_game_data()  # 收集游戏数据
	data_to_save["metadata"]["timestamp"] = Time.get_datetime_string_from_system(false,true)
	#获取时间戳
	var file_path = SAVE_DIR + SLOT_PREFIX + str(slot_id) + ".json"
	#定义路径
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(data_to_save, "\t"))
		print_rich("槽位" + str(slot_id) + "[color=gold][b] 已存入[/b][/color]")  # 带缩进的 JSON，写入
	else:
		push_error("Save failed: ", FileAccess.get_open_error())#打开失败则报错

func _collect_game_data() -> Dictionary:#收集游戏数据
	return{
		"metadata" : {
			"SaL_system_version" : "0.0.1",#开发用水印
			"timestamp" : "2025-03-24 12：00：00"#时间戳
		},
		"game_data" : {
			"chara_disc" : chara_disc,#角色用字典
			"background_id" : background_id,#背景列表数据
			"chapter_id" : chapter_id.replace("\r",""),#章节id
			"bgm_id" : bgm_id,#bgm id
			"bgm_progress" : bgm_progress,#bgm进度
			"voice_id" : voice_id,#配音列表
			"sound_effect_id" : sound_effect_id,#音效列表
			"curline" : curline#当前对话
			}
		}

func _load_game(slot_id: int) -> bool:#加载数据，需要传入槽位ID
	var file_path = SAVE_DIR + SLOT_PREFIX + str(slot_id) + ".json"
	
	# 检查存档文件是否存在
	if not FileAccess.file_exists(file_path):
		print_rich("[color=green][b]Save file not found: [/b][/color]", file_path)
		return false
	
	# 打开存档文件
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Load failed: ", FileAccess.get_open_error())
		return false
	
	# 读取并解析JSON数据
	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())
	if parse_result != OK:
		push_error("JSON parse error: ", json.get_error_message(), " at line ", json.get_error_line())
		return false
	
	var loaded_data = json.get_data()
	
	# 验证数据结构基础格式
	if not (loaded_data.has("metadata") and loaded_data.has("game_data")):
		push_error("Invalid save file structure")
		return false
	
	# 检查版本兼容性(实际没卵用，可以删，因为这版本号估计也就神木会改了）
	var metadata = loaded_data["metadata"]
	if metadata["SaL_system_version"] != "0.0.1":
		push_error("Save version mismatch. Expected 0.0.1, got ", metadata["SaL_system_version"],"，不是哥们干嘛要动这个啊")
		return false
	
	# 开始加载游戏数据
	var game_data = loaded_data["game_data"]
	
	# 使用安全访问方式获取数据，防止字段缺失
	chara_disc = game_data.get("chara_disc", {})
	background_id = game_data.get("background_id", 0)
	chapter_id = game_data.get("chapter_id", "").replace("\r", "")  # 保持与保存时一致的格式处理
	bgm_id = game_data.get("bgm_id", "")
	bgm_progress = game_data.get("bgm_progress", 0.0)
	voice_id = game_data.get("voice_id", [])
	sound_effect_id = game_data.get("sound_effect_id", [])
	curline = game_data.get("curline", 0)
	
	#调试
	print_rich("[color=yellow][b]Loaded data from slot [/b][/color]", slot_id)
	#print(loaded_data)
	return true

func _get_file_inf(slot_id : int) -> Dictionary :
	var file_path = SAVE_DIR + SLOT_PREFIX + str(slot_id) + ".json"
	
	# 检查存档文件是否存在
	if not FileAccess.file_exists(file_path):
		print_rich("[color=green][b]Save file not found: [/b][/color]", file_path)
		pass
	
	# 打开存档文件
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Load failed: ", FileAccess.get_open_error())
		pass
	
	# 读取并解析JSON数据
	var json = JSON.new()
	var parse_result = json.parse(file.get_as_text())
	if parse_result != OK:
		push_error("JSON parse error: ", json.get_error_message(), " at line ", json.get_error_line())
		pass
	
	var loaded_data = json.get_data()
	
	# 验证数据结构基础格式
	if not (loaded_data.has("metadata") and loaded_data.has("game_data")):
		push_error("Invalid save file structure")
		pass
	
	var timestamp_check : String
	var chapter_id_check : String
	
	var meta_data = loaded_data["metadata"]
	var game_data = loaded_data["game_data"]
	
	timestamp_check = meta_data.get("timestamp",[])
	chapter_id_check = game_data.get("chapter_id", "").replace("\r", "")
	
	return{
		"timestamp" : timestamp_check,
		"chapter_id" : chapter_id_check
	}
