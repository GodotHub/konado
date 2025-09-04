@tool
extends EditorPlugin

const CONFIG_FILE = "res://presets_main_scenes.json"

var menu_button: MenuButton
var popup: PopupMenu
var config_data: Dictionary


func _enter_tree() -> void:
	# 创建菜单按钮
	menu_button = MenuButton.new()
	menu_button.text = "主场景"
	menu_button.tooltip_text = "切换导出预设的主场景"

	# 添加菜单按钮到编辑器顶部栏
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, menu_button)

	# 获取弹出菜单
	popup = menu_button.get_popup()
	popup.id_pressed.connect(_on_menu_item_selected)

	# 加载配置
	load_config()
	update_menu()


func _exit_tree() -> void:
	# 清理资源
	if menu_button:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, menu_button)
		menu_button.queue_free()


func load_config() -> void:
	config_data = {}

	if FileAccess.file_exists(CONFIG_FILE):
		var file = FileAccess.open(CONFIG_FILE, FileAccess.READ)
		if file:
			var json = JSON.new()
			var error = json.parse(file.get_as_text())
			if error == OK:
				config_data = json.data
			else:
				push_error("解析JSON配置文件失败: " + json.get_error_message())
			file.close()
	else:
		# 如果配置文件不存在，创建一个示例配置
		create_sample_config()


func create_sample_config() -> void:
	config_data = {
		"Android": "res://scenes/main_android.tscn",
		"Windows": "res://scenes/main_windows.tscn"
	}

	save_config()
	print("已创建示例配置文件: " + CONFIG_FILE)


func save_config() -> void:
	var file = FileAccess.open(CONFIG_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(config_data, "\t"))
		file.close()
	else:
		push_error("无法保存配置文件: " + CONFIG_FILE)


func update_menu() -> void:
	popup.clear()

	if config_data.is_empty():
		popup.add_item("无配置项", 0)
		popup.set_item_disabled(0, true)
		return

	var index = 0
	for preset_name in config_data:
		popup.add_item(preset_name, index)
		index += 1

	# 添加分隔符和配置管理选项
	popup.add_separator()
	popup.add_item("重新加载配置", index)
	popup.add_item("编辑配置", index + 1)


func _on_menu_item_selected(id: int) -> void:
	var item_count = config_data.size()

	if id < item_count:
		# 选择的是预设项
		var preset_name = config_data.keys()[id]
		var scene_path = config_data[preset_name]
		set_main_scene(scene_path, preset_name)
	elif id == item_count:
		# 重新加载配置
		load_config()
		update_menu()
		print("主场景切换器: 配置已重新加载")
	elif id == item_count + 1:
		# 编辑配置
		open_config_file()


func set_main_scene(scene_path: String, preset_name: String) -> void:
	if not FileAccess.file_exists(scene_path):
		push_error("场景文件不存在: " + scene_path)
		return

	# 在 Godot 4 中设置主场景
	ProjectSettings.set_setting("application/run/main_scene", scene_path)
	ProjectSettings.save()
	print("已设置主场景为: " + scene_path + " (预设: " + preset_name + ")")


func open_config_file() -> void:
	var editor_interface = get_editor_interface()
	editor_interface.get_resource_filesystem().scan()
	editor_interface.select_file(CONFIG_FILE)