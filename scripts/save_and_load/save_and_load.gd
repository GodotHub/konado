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

func _save_game(slot_id: int) -> void:
	var data_to_save = _collect_game_data()  # 收集游戏数据
	data_to_save["metadata"]["timestamp"] = Time.get_datetime_string_from_system(false,true)
	#获取时间戳
	var file_path = SAVE_DIR + SLOT_PREFIX + str(slot_id) + ".json"
	#定义路径
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(data_to_save, "\t"))
		print(data_to_save)  # 带缩进的 JSON，写入
	else:
		push_error("Save failed: ", FileAccess.get_open_error())#打开失败则报错

func _collect_game_data() -> Dictionary:
	return{
		"metadata" : {
			"SaL_system_version" : "1.0",#开发用水印
			"timestamp" : "0"#时间戳
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
