extends Control
class_name ArchiveManager

const archive_file_name: String = "archive.sav"
## 存档密钥
const ARCHIVE_KEY = "YEs!cKnf4uq#"
## 对话管理器
@export var _dialog_manager: DialogueManager
## 表演接口
@export var _acting_interface: ActingInterface
## 存档列表
@export var archives_list: ArchiveList
## 存档字典
@export var archive_dic: Dictionary
@export_group("存档UI")
@export var archive_buttons: Array[ArchiveBox]
@export var archive_ui: Control
@export var archive_back_btn: Button
@export_group("读档UI")
@export var load_buttons: Array[ArchiveBox]
@export var load_ui: Control
@export var load_back_btn: Button

## 存档路径
var ARCHIVE_PATH = ""

## 存档确认对话框
@export var archive_dialog: ArchiveDialog
		
func _ready():
	# 检测是否有DialogManager
	if !_dialog_manager:
		print("没找到对话播放器")
		return
	await get_tree().create_timer(1.0).timeout
	archive_back_btn.pressed.connect(hide_archive_ui)
	load_back_btn.pressed.connect(hide_load_ui)
	# 遍历存档位添加信号
	var a_id: int = 0
	for b in archive_buttons:
		if b == null:
			return
		b.archive_id = a_id
		if not b.archive_box_pressed.is_connected(_on_save_btn_pressed):
			b.archive_box_pressed.connect(_on_save_btn_pressed.bind())
		a_id += 1
	# 遍历读档位添加信号
	var l_id: int = 0
	for lb in load_buttons:
		lb.archive_id = l_id
		if not lb.archive_box_pressed.is_connected(_on_load_btn_pressed):
			lb.archive_box_pressed.connect(_on_load_btn_pressed.bind())
		l_id += 1
	## 获取存档路径
	_get_path()
	## 检查存档文件是否存在，如果存在就读取，不存在就创建
	if _create_archive_file():
		pass
	else:
		load_archive_from_file()
		_array_to_dic()
# 获取存档路径
func _get_path():
	# 编辑器
	if OS.has_feature("editor"):
		ARCHIVE_PATH = "res://".path_join(archive_file_name)
	# PC平台
	elif OS.has_feature("windows") || OS.has_feature("linuxbsd"):
		ARCHIVE_PATH = OS.get_executable_path().get_base_dir().path_join(archive_file_name)

## 创建文件的方法，如果没有就会创建并返回true，如果已经创建返回false
func _create_archive_file() -> bool:
	if not FileAccess.file_exists(ARCHIVE_PATH):
		var file = FileAccess.open_encrypted_with_pass(ARCHIVE_PATH, FileAccess.WRITE, ARCHIVE_KEY)
		print("未找到存档文件，在" +ARCHIVE_PATH+"新建")
		_array_to_dic()
		file.close()
		save_archive_to_file()
		return true
	else:
		print("存档文件已经存在")
		var file = FileAccess.open_encrypted_with_pass(ARCHIVE_PATH, FileAccess.READ, ARCHIVE_KEY)
		# 如果是空文件就重置存档文件
		if file.get_as_text().length() == 0:
			print("存档文件是空的，清空存档")
			_array_to_dic()
			save_archive_to_file()
		return false
		
## 获取游戏进度并转为存档
func get_game_progress_to_archive():
	var game_progress = _dialog_manager.get_game_progress()
	if game_progress:
		var archive = Archive.new()
		archive.chapter_name = game_progress["chapter_name"]
		archive.chapter_id = game_progress["chapter_id"]
		archive.curline = game_progress["curline"]
		# 如果有播放BGM
		if _dialog_manager._audio_interface.bgm_name.length() > 0:
			archive.bgm_id = _dialog_manager._audio_interface.bgm_name
		# 如果是空演员表
		if not _acting_interface.actor_dict.is_empty():
			archive.actor_dict = _acting_interface.actor_dict
		archive.archive_time = Time.get_datetime_string_from_system(false, true)
		return archive
	else:
		return null


## 快速存档的方法，保存在0号存档位
func quick_save():
	archives_list.archives[0] = get_game_progress_to_archive()
	save_archive_to_file()
	update_archive_button(0)
	update_load_button(0)
	pass

## 保存存档到文件
func save_archive_to_file():
	_array_to_dic()
	var file = FileAccess.open_encrypted_with_pass(ARCHIVE_PATH, FileAccess.WRITE, ARCHIVE_KEY)
	if file:
		var json_string = JSON.stringify(archive_dic)
		file.store_string(json_string)
		file.close()
		print("游戏保存成功")
	else:
		print("游戏保存失败")
	

## 从文件读取存档
func load_archive_from_file():
	var file
	file = FileAccess.open_encrypted_with_pass(ARCHIVE_PATH, FileAccess.READ, ARCHIVE_KEY)
	if file:
		if file.get_as_text().length() > 0:
			var json = JSON.new()
			json.parse(file.get_as_text())
			archive_dic = json.data
		file.close()
	_dic_to_array()
	var id = 0
	for archive in archives_list.archives:
		update_archive_button(id)
		update_load_button(id)
		id+=1
	
## 将列表转换成字典
func _array_to_dic():
	archive_dic.clear()
	var id: int = 0
	for archive in archives_list.archives:
		var c_name = archive.chapter_name
		var curline = archive.curline
		var c_id = archive.chapter_id
		var time = archive.archive_time
		var bgm_id = archive.bgm_id
		var actor_dict = archive.actor_dict
		var dic: Dictionary = {}
		dic["chapter_name"] = c_name
		dic["curline"] = curline
		dic["c_id"] = c_id
		dic["time"] = time
		dic["bgm_id"] = bgm_id
		dic["actor_dict"] = actor_dict
		archive_dic[id] = dic
		id += 1

# 字典转为列表
func _dic_to_array():
	archives_list.archives.clear()
	for arc in archive_dic:
		var dic: Dictionary = archive_dic[arc]
		var archive = Archive.new()
		archive.chapter_id = dic["c_id"]
		archive.chapter_name = dic["chapter_name"]
		archive.curline = dic["curline"]
		archive.archive_time = dic["time"]
		archive.bgm_id = dic["bgm_id"]
		archive.actor_dict = dic["actor_dict"]
		archives_list.archives.append(archive)
	
## 显示存档页面
func show_archive_ui():
	load_ui.hide()
	show()
	archive_ui.show()
	archive_dialog.hide_dialog_box()
	
## 隐藏存档页面
func hide_archive_ui():
	archive_ui.hide()
	hide()
	
## 显示读档页面
func show_load_ui():
	archive_ui.hide()
	show()
	load_ui.show()
	archive_dialog.hide_dialog_box()
	
## 隐藏读档页面	
func hide_load_ui():
	load_ui.hide()
	hide()

## 当按下存档按钮
func _on_save_btn_pressed(id: int, archive_box: ArchiveBox):
	_dic_to_array()
	var archive = get_game_progress_to_archive()
	print("按下"+str(id))
	# 当该存档位已经有存档时
	if archives_list.archives[id].chapter_id:
		archive_dialog.show_dialog_box("是否覆盖存档")
		archive_dialog.click_cancel.connect(func():
			if archive_dialog.click_confirm.is_connected(overwrite_archive):
				archive_dialog.click_confirm.disconnect(overwrite_archive))
		if not archive_dialog.click_confirm.is_connected(overwrite_archive):
			archive_dialog.click_confirm.connect(overwrite_archive.bind(id))
	else:
		archives_list.archives[id] = archive
		_array_to_dic()
		save_archive_to_file()
		update_archive_button(id)
		update_load_button(id)
		

## 当按下读档按钮
func _on_load_btn_pressed(id: int, archive_box: ArchiveBox):
	print("读档"+str(id))
	_dic_to_array()
	var curline = archives_list.archives[id].curline
	var data_id = archives_list.archives[id].chapter_id
	var actor_dict: Dictionary = archives_list.archives[id].actor_dict
	var bgm_id: String = archives_list.archives[id].bgm_id
	if curline and data_id and actor_dict and bgm_id:
		archive_dialog.show_dialog_box("是否读取存档")
		archive_dialog.click_cancel.connect(func():
			if archive_dialog.click_confirm.is_connected(load_archive):
				archive_dialog.click_confirm.disconnect(load_archive))
		if not archive_dialog.click_confirm.is_connected(load_archive):
			archive_dialog.click_confirm.connect(load_archive.bind(data_id, curline, bgm_id, actor_dict))
	else:
		return

## 覆盖存档
func overwrite_archive(id: int):
	archive_dialog.click_confirm.disconnect(overwrite_archive)
	var archive = get_game_progress_to_archive()
	archives_list.archives[id] = archive
	_array_to_dic()
	save_archive_to_file()
	update_archive_button(id)
	update_load_button(id)
	print("覆盖了存档位"+str(id))
	pass
	
## 读取存档
func load_archive(data_id, curline, bgm_id, actor_dict):
	print("读取存档"+data_id)
	archive_dialog.click_confirm.disconnect(load_archive)
	_dialog_manager.jump_data_and_curline(data_id, curline, bgm_id, actor_dict)
	hide_load_ui()

# 更新存档按钮显示
func update_archive_button(id: int):
	var archive_box = archive_buttons[id]
	archive_box.set_chapter_text(archives_list.archives[id].chapter_name)
	archive_box.set_time_text(archives_list.archives[id].archive_time)

# 更新读档按钮显示
func update_load_button(id: int):
	var load_box = load_buttons[id]
	load_box.set_chapter_text(archives_list.archives[id].chapter_name)
	load_box.set_time_text(archives_list.archives[id].archive_time)#小陆爱玩彩六
