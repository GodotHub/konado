@tool
extends EditorPlugin
class_name KonadoEditorPlugin
# Konado框架引擎插件入口文件，负责初始化插件和注册相关功能

## 插件版本信息
const VERSION := "2.1"
const CODENAME := "Lebkuchen"

## 自定义EditorImportPlugin脚本
const KS_IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const KDIC_IMPORTER_SCRIPT := preload("res://addons/konado/editor/components/ks_csv_importer/ks_csv_importer.gd")

## 全局自动加载脚本
const KONADO_MACROS := "res://addons/konado/konado_macros.gd"

## 翻译文件路径
const TRANSLATION_PATHS: PackedStringArray = [
	#"res://addons/konado/i18n/i18n.zh.translation",
	#"res://addons/konado/i18n/i18n.zh_HK.translation",
	#"res://addons/konado/i18n/i18n.en.translation",
	#"res://addons/konado/i18n/i18n.ja.translation",
	#"res://addons/konado/i18n/i18n.ko.translation",
	#"res://addons/konado/i18n/i18n.de.translation"
]

## 自动加载单例名称
const AUTOLOAD_KONADO_MACROS := "KonadoMacros"

## 插件实例变量
var konado_editor_instance: KonadoEditorWindow = null
var ks_import_plugin: EditorImportPlugin
var kdic_import_plugin: EditorImportPlugin

# 文件系统dock
var filesystem_dock: FileSystemDock
var ks_tooltip_plugin: EditorResourceTooltipPlugin

var ks_editor: KsEditorWindow

func _get_plugin_name() -> String:
	return "Konado"
	
func _get_plugin_icon() -> Texture2D:
	return null
	
func _has_main_screen() -> bool:
	return true

func _enter_tree() -> void:
	_setup_autoload_singletons()
	_setup_import_plugins()
	#_setup_internationalization()
	
	_print_loading_message()
	
	filesystem_dock = get_editor_interface().get_file_system_dock()
	ks_tooltip_plugin = preload("res://addons/konado/ks/ks_tooltip_plugin.gd").new()
	filesystem_dock.add_resource_tooltip_plugin(ks_tooltip_plugin)
	

	ks_editor = load("res://addons/konado/editor/view/ks_editor/ks_editor.tscn").instantiate() as KsEditorWindow
	EditorInterface.get_editor_main_screen().add_child(ks_editor)
	ks_editor.hide()
	
# 控制显示
func _make_visible(visible:bool) -> void:
	if not ks_editor:
		return

	if ks_editor.get_parent() is Window:
		if visible:
			get_editor_interface().set_main_screen_editor("Script")
			ks_editor.show()
			ks_editor.get_parent().grab_focus()
	else:
		ks_editor.visible = visible

func _exit_tree() -> void:
	_cleanup_import_plugins()
	_cleanup_autoload_singletons()
	
	if filesystem_dock:
		filesystem_dock.remove_resource_tooltip_plugin(ks_tooltip_plugin)
		ks_tooltip_plugin = null
		
	if ks_editor:
		remove_control_from_bottom_panel(ks_editor)
	
	print("Konado unloaded")

## 用于处理ks文件
func _handles(object: Object) -> bool:
	if object is Resource and object.resource_path.get_extension() == "ks":
		ks_editor.edit(object.resource_path)
		return true
	return false
	
	
## 设置自动加载单例
func _setup_autoload_singletons() -> void:
	add_autoload_singleton(AUTOLOAD_KONADO_MACROS, KONADO_MACROS)


## 设置导入插件
func _setup_import_plugins() -> void:
	ks_import_plugin = KS_IMPORTER_SCRIPT.new()
	kdic_import_plugin = KDIC_IMPORTER_SCRIPT.new()
	
	add_import_plugin(ks_import_plugin)
	add_import_plugin(kdic_import_plugin)
	
	
## 设置国际化
func _setup_internationalization() -> void:
	ProjectSettings.set_setting("internationalization/locale/translations", TRANSLATION_PATHS)
	ProjectSettings.set_setting("internationalization/locale/locale_filter_mode", 1)  # 允许所有区域
	ProjectSettings.save()





## 打开Konado编辑器
func open_konado_editor() -> void:
	if konado_editor_instance and is_instance_valid(konado_editor_instance):
		konado_editor_instance.popup()
	else:
		konado_editor_instance = KonadoEditorWindow.new()
		get_editor_interface().get_base_control().add_child(konado_editor_instance)
		konado_editor_instance.popup()


## 清理导入插件
func _cleanup_import_plugins() -> void:
	if ks_import_plugin:
		remove_import_plugin(ks_import_plugin)
		ks_import_plugin = null
		
	if kdic_import_plugin:
		remove_import_plugin(kdic_import_plugin)
		kdic_import_plugin = null




## 清理自动加载单例
func _cleanup_autoload_singletons() -> void:
	remove_autoload_singleton(AUTOLOAD_KONADO_MACROS)


## 打印加载信息
func _print_loading_message() -> void:
	print("Konado %s %s" % [VERSION, CODENAME])
	print("Konado loaded")


## 编辑器按钮按下回调
func _on_konado_editor_button_pressed() -> void:
	open_konado_editor()
