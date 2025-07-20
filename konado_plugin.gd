@tool
extends EditorPlugin

## 配置常量
const DIALOGUE_DATA_SCRIPT := preload("res://addons/konado/scripts/dialogue/dialogue_data.gd")
const IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const SAVE_AND_LOAD := "res://addons/konado/scripts/save_and_load/SaL.gd"

## 插件成员
var import_plugin: EditorImportPlugin

## 帮助文档按钮
var help_doc_btn: Button = null


func _enter_tree() -> void:
	# 添加自动加载单例
	add_autoload_singleton("KS_SAVE_AND_LOAD",SAVE_AND_LOAD)
	# 注册自定义资源类型
	add_custom_type("DialogueData", "Resource", DIALOGUE_DATA_SCRIPT, null)
	
	# 初始化导入插件
	import_plugin = IMPORTER_SCRIPT.new()
	add_import_plugin(import_plugin)

	# 从version.txt读取字符串并打印
	print(load_string("res://addons/konado/version.txt"))
	help_doc_btn = _create_toolbar_btn()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, help_doc_btn)
	print("Konado loaded")

func load_string(path: String) -> String:
	return FileAccess.open(path, FileAccess.READ).get_as_text()

func _create_toolbar_btn() -> Button:
	var btn = Button.new()
	btn.text = "Konado文档"
	btn.pressed.connect(func(): 
		# 跳转到Konado文档
		var url = "https://godothub.com/konado/tutorial/install.html"
		OS.shell_open(url)
	)
	return btn

func _exit_tree() -> void:
	# 移除导入插件
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null

	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, help_doc_btn)

	# 清理自动加载和自定义类型
	remove_autoload_singleton("KS_SAVE_AND_LOAD")
	remove_custom_type("DialogueData")
	print("Konado unloaded")
