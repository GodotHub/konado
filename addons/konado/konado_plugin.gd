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


var konado_editor_instance: KonadoEditorWindow = null

## 配置常量
const DIALOGUE_DATA_SCRIPT := preload("res://addons/konado/scripts/dialogue/dialogue_data.gd")
const IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const SAVE_AND_LOAD := "res://addons/konado/scripts/save_and_load/SaL.gd"
const Component_Factory = "res://addons/konado/editor/ui/ui_components/component_factory.gd"

## 插件成员
var import_plugin: EditorImportPlugin

## 帮助文档按钮
var help_doc_btn: Button = null
## 打开Konado编辑器按钮
var open_konado_editor_btn: Button = null


func _enter_tree() -> void:
	# 添加自动加载单例
	add_autoload_singleton("KS_SAVE_AND_LOAD",SAVE_AND_LOAD)
	add_autoload_singleton("ComponentFactory",Component_Factory)
	
	# 注册自定义资源类型
	add_custom_type("DialogueData", "Resource", DIALOGUE_DATA_SCRIPT, null)

	## 将翻译文件csv导入并添加到项目设置？？？
	# 文档似乎又是啥也没写666，等有时间再研究
	# var cn_translation: Translation = ResourceLoader.load("res://addons/konado/i18n/konado_zh-cn.zh.translation") as Translation
	# var en_translation: Translation = ResourceLoader.load("res://addons/konado/i18n/konado_en.en.translation") as Translation
	# TranslationServer.add_translation(cn_translation)
	# TranslationServer.add_translation(en_translation)
	
	# 获取本机语言
	# var locale = TranslationServer.get_locale()
	# # 设置翻译
	# TranslationServer.set_locale(locale)
	
	# 初始化导入插件
	import_plugin = IMPORTER_SCRIPT.new()
	add_import_plugin(import_plugin)

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
		konado_editor_instance.popup()
	else:
		konado_editor_instance = KonadoEditorWindow.new()
		get_editor_interface().get_base_control().add_child(konado_editor_instance)
		konado_editor_instance.popup()
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
	btn.text = "Snowflake编辑器"
	btn.pressed.connect(func():
		open_snowflake_editor()
	)
	return btn

func _exit_tree() -> void:
	# 移除导入插件
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null

	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, help_doc_btn)
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, open_konado_editor_btn)

	# 清理自动加载和自定义类型
	remove_autoload_singleton("KS_SAVE_AND_LOAD")
	remove_custom_type("DialogueData")
	print("Konado unloaded")
