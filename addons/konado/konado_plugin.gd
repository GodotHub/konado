# Konado框架引擎插件入口文件，负责初始化插件和注册相关功能
@tool
extends EditorPlugin

## 插件版本信息
const VERSION := "2.0"
const CODENAME := "Mooncake"

## 资源路径常量
const IMPORTER_SCRIPT := preload("res://addons/konado/importer/konado_importer.gd")
const KDB_SCRIPT := preload("res://addons/konado/importer/kdb_importer.gd")
const KDIC_SCRIPT := preload("res://addons/konado/editor/components/ks_csv_importer/ks_csv_importer.gd")
const KND_DATABASE := "res://addons/konado/database/knd_database.gd"
const KONADO_MACROS := "res://addons/konado/konado_macros.gd"

## 翻译文件路径
const TRANSLATION_PATHS: PackedStringArray = [
	"res://addons/konado/i18n/i18n.zh.translation",
	"res://addons/konado/i18n/i18n.zh_HK.translation",
	"res://addons/konado/i18n/i18n.en.translation",
	"res://addons/konado/i18n/i18n.ja.translation",
	"res://addons/konado/i18n/i18n.ko.translation",
	"res://addons/konado/i18n/i18n.de.translation"
]

## 自动加载单例名称
const AUTOLOAD_DATABASE := "KND_Database"
const AUTOLOAD_KONADO_MACROS := "KonadoMacros"

## 插件实例变量
var konado_editor_instance: KonadoEditorWindow = null
var import_plugin: EditorImportPlugin
var kdb_import_plugin: EditorImportPlugin
var kdic_import_plugin: EditorImportPlugin
var open_konado_editor_btn: Button = null


func _enter_tree() -> void:
	_setup_autoload_singletons()
	_setup_import_plugins()
	_setup_editor_interface()
	_setup_internationalization()
	
	_print_loading_message()


func _exit_tree() -> void:
	_cleanup_import_plugins()
	_cleanup_editor_interface()
	_cleanup_autoload_singletons()
	
	print("Konado unloaded")


## 设置自动加载单例
func _setup_autoload_singletons() -> void:
	add_autoload_singleton(AUTOLOAD_KONADO_MACROS, KONADO_MACROS)
	add_autoload_singleton(AUTOLOAD_DATABASE, KND_DATABASE)


## 设置导入插件
func _setup_import_plugins() -> void:
	import_plugin = IMPORTER_SCRIPT.new()
	kdb_import_plugin = KDB_SCRIPT.new()
	kdic_import_plugin = KDIC_SCRIPT.new()
	
	add_import_plugin(import_plugin)
	add_import_plugin(kdb_import_plugin)
	add_import_plugin(kdic_import_plugin)
	
	
## 设置编辑器界面
func _setup_editor_interface() -> void:
	open_konado_editor_btn = _create_editor_toolbar_button()
	add_control_to_container(CONTAINER_TOOLBAR, open_konado_editor_btn)


## 设置国际化
func _setup_internationalization() -> void:
	ProjectSettings.set_setting("internationalization/locale/translations", TRANSLATION_PATHS)
	ProjectSettings.set_setting("internationalization/locale/locale_filter_mode", 1)  # 允许所有区域
	ProjectSettings.save()


## 创建编辑器工具栏按钮
func _create_editor_toolbar_button() -> Button:
	var button := Button.new()
	button.text = "Konado 编辑器"
	button.toggle_mode = true
	button.pressed.connect(_on_konado_editor_button_pressed)
	return button


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
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null
	
	if kdb_import_plugin:
		remove_import_plugin(kdb_import_plugin)
		kdb_import_plugin = null
		
	if kdic_import_plugin:
		remove_import_plugin(kdic_import_plugin)
		kdic_import_plugin = null

## 清理编辑器界面
func _cleanup_editor_interface() -> void:
	if open_konado_editor_btn:
		remove_control_from_container(CONTAINER_TOOLBAR, open_konado_editor_btn)
		open_konado_editor_btn.queue_free()
		open_konado_editor_btn = null


## 清理自动加载单例
func _cleanup_autoload_singletons() -> void:
	remove_autoload_singleton(AUTOLOAD_DATABASE)
	remove_autoload_singleton(AUTOLOAD_KONADO_MACROS)


## 打印加载信息
func _print_loading_message() -> void:
	print("Konado %s %s" % [VERSION, CODENAME])
	print("Konado loaded")


## 编辑器按钮按下回调
func _on_konado_editor_button_pressed() -> void:
	open_konado_editor()
