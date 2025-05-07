extends Node

const SAVE_DIR := "user://saves/"#存档文件夹路径
const SLOT_PREFIX := "save_"#存档文件前缀
var chara : CharacterList
var dialog_data_id: int
var background : BackgroundList
var bgm : DialogBGMList
var voice : DialogVoiceList
var sound_effect : DialogSoundEffectList
var curline : int

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

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
	#print(str(dialoguemanager.chara_list))
	return{
		"metadata" : {
			"timestamp" : "0"
		},
		"game_data" : {
			"chara" : chara,#角色列表数据
			"background" : background,#背景列表数据
			"dialogue_data_id" : dialog_data_id,
			"bgm" : bgm,#bgm列表
			"voice" : voice,#配音列表
			"sound_effect" : sound_effect,#音效列表
			"curline" : curline#当前对话
			}
		}
