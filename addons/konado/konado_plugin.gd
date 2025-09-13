################################################################################
# Project: Konado
# File: konado_plugin.gd
# Author: DSOE1024
# Created: 2025-07-27
# Last Modified: 2025-07-27
# Description:
#   Konado框架引擎插件入口文件，负责初始化插件和注册相关功能
################################################################################

@tool
extends EditorPlugin


var konado_editor_instance: Control = null

## 配置常量
const DIALOGUE_DATA_SCRIPT := preload("res://addons/konado/scripts/dialogue/dialogue_shot.gd")
const IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const KDB_SCRIPT := preload("res://addons/konado/importer/kdb_importer.gd")
const CSV_IMPORTER_SCRIPT := preload("res://addons/konado/editor/ks_csv_importer/ks_csv_importer.gd")
const SAVE_AND_LOAD := "res://addons/konado/scripts/save_and_load/SaL.gd"

const KONADO_EDITOR := preload("uid://bommt7l6wmdsa")




## 插件成员
var import_plugin: EditorImportPlugin
var kdb_import_plugin: EditorImportPlugin
var csv_import_plugin: EditorImportPlugin

## 帮助文档按钮
var help_doc_btn: Button = null
## 打开Konado编辑器按钮
var open_konado_editor_btn: Button = null



func _enter_tree() -> void:
	# 添加自动加载单例
	add_autoload_singleton("KS_SAVE_AND_LOAD",SAVE_AND_LOAD)
	
	# 注册自定义资源类型
	#add_custom_type("DialogueData", "Resource", DIALOGUE_DATA_SCRIPT, null)
	#add_custom_type("KND_Data", "Resource", KDB, null)

	# 初始化导入插件
	## TODO: 未来用字典遍历方式添加
	import_plugin = IMPORTER_SCRIPT.new()
	kdb_import_plugin = KDB_SCRIPT.new()
	csv_import_plugin = CSV_IMPORTER_SCRIPT.new()
	
	add_import_plugin(import_plugin)
	add_import_plugin(kdb_import_plugin)
	add_import_plugin(csv_import_plugin)

	

	# 从version.txt读取字符串并打印
	print(load_string("res://addons/konado/version.txt"))

	help_doc_btn = _create_toolbar_btn()
	open_konado_editor_btn = _create_editor_toolbar_btn()

	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, help_doc_btn)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, open_konado_editor_btn)

	print("Konado loaded")

func load_string(path: String) -> String:
	return FileAccess.open(path, FileAccess.READ).get_as_text()


func open_snowflake_editor() -> void:
	if konado_editor_instance and is_instance_valid(konado_editor_instance):
		konado_editor_instance.show()
	else:
		konado_editor_instance = KONADO_EDITOR.instantiate()
		var subWindow = get_editor_interface().add_subwindow(konado_editor_instance)
		get_editor_interface().get_base_control().add_child(konado_editor_instance)
		konado_editor_instance.show()
	pass

func _create_toolbar_btn() -> Button:
	var btn = Button.new()
	btn.text = "Konado文档"
	btn.pressed.connect(func(): 
		# 跳转到Konado文档
		var url = "https://godothub.com/konado/tutorial/install.html"
		OS.shell_open(url)
	)
	return btn

func _create_editor_toolbar_btn() -> Button:
	var btn = Button.new()
	btn.text = "Konado 编辑器"
	btn.pressed.connect(func():
		open_snowflake_editor()
	)
	return btn

func _exit_tree() -> void:
	# 移除导入插件
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null
		
	if kdb_import_plugin:
		remove_import_plugin(kdb_import_plugin)
		kdb_import_plugin = null

	if csv_import_plugin:
		remove_import_plugin(csv_import_plugin)
		csv_import_plugin = null


	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, help_doc_btn)
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, open_konado_editor_btn)

	# 清理自动加载和自定义类型
	remove_autoload_singleton("KS_SAVE_AND_LOAD")
	remove_custom_type("DialogueData")
	print("Konado unloaded")
