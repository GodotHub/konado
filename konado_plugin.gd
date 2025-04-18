#_____________________________________________________#
#   _  __                              _              #
#  | |/ /   ___    _ __     __ _    __| |   ___       #
#  | ' /   / _ \  | '_ \   / _` |  / _` |  / _ \      #
#  | . \  | (_) | | | | | | (_| | | (_| | | (_) |     #
#  |_|\_\  \___/  |_| |_|  \__,_|  \__,_|  \___/      #
#                                                     #
#_____________________________________________________#
#                                                     #
# Main Programmer: DSOE1024                           #
# Shaders Programmer: yxj                             #
# Version: 1.0.0                                      #
# Description: Visual Novel Game Engine               #
#_____________________________________________________#
#                                                     #
# License: MIT                                        #
# ____________________________________________________#
#                                                     #
# If you want to enjoy art,                           #
# then you must be a person with artistic cultivation #
#_____________________________________________________#


@tool
extends EditorPlugin

### 配置常量 ###
const DIALOGUE_DATA_SCRIPT := preload("res://addons/konado/scripts/dialogue/dialogue_data.gd")
const IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const INTERPRETER_PATH := "res://addons/konado/scripts/konado_scripts/konadoscripts_Interpreter.gd"

### 插件成员 ###
var _panel := Panel.new()  # 使用基础Panel作为占位符
var import_plugin: EditorImportPlugin

func _enter_tree() -> void:
	# 注册自定义资源类型
	add_custom_type("DialogueData", "Resource", DIALOGUE_DATA_SCRIPT, null)
	
	# 初始化导入插件
	import_plugin = IMPORTER_SCRIPT.new()
	add_import_plugin(import_plugin)
	
	# 添加自动加载单例
	add_autoload_singleton("KS", INTERPRETER_PATH)
	
	# 添加UI面板到编辑器
	_panel.name = "KonadoPanel"
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, _panel)
	
	print_rich("""
	---------------------------------------------------------------------------------
	-------------- [b][i][color=ALICE_BLUE]Konado V1.0.0[/color][/i][/b] --------------
	:: Loaded modules:
	   • Dialogue System
	   • Script Interpreter
	   • Resource Loader
	---------------------------------------------------------------------------------
	""")

func _exit_tree() -> void:
	# 清理顺序很重要，先移除依赖项
	remove_control_from_docks(_panel)
	_panel.queue_free()
	
	# 移除导入插件
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null
	
	# 清理自动加载和自定义类型
	remove_autoload_singleton("KS")
	remove_custom_type("DialogueData")
