@tool
extends EditorPlugin

### 配置常量 ###
const DIALOGUE_DATA_SCRIPT := preload("res://addons/konado/scripts/dialogue/dialogue_data.gd")
const IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const INTERPRETER_PATH := "res://addons/konado/scripts/konado_scripts/konadoscripts_Interpreter.gd"

### 插件成员 ###
var import_plugin: EditorImportPlugin

func _enter_tree() -> void:
	# 添加自动加载单例
	add_autoload_singleton("KS", INTERPRETER_PATH)
	# 注册自定义资源类型
	add_custom_type("DialogueData", "Resource", DIALOGUE_DATA_SCRIPT, null)
	
	# 初始化导入插件
	import_plugin = IMPORTER_SCRIPT.new()
	add_import_plugin(import_plugin)

	# 从version.txt读取字符串并打印
	print_rich(load_string("res://addons/konado/version.txt"))
	
	# print_rich("""
	# ---------------------------------------------------------------------------------
	# -------------- [b][i][color=ALICE_BLUE]Konado V1.0.0[/color][/i][/b] --------------
	# :: Loaded modules:
	#    • Dialogue System
	#    • Script Interpreter
	#    • Resource Loader
	# ---------------------------------------------------------------------------------
	# """)

func load_string(path: String) -> String:
	return FileAccess.open(path, FileAccess.READ).get_as_text()
	
func _exit_tree() -> void:	
	# 移除导入插件
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null
	
	# 清理自动加载和自定义类型
	remove_autoload_singleton("KS")
	remove_custom_type("DialogueData")
