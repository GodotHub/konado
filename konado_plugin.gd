@tool
extends EditorPlugin

const panel = preload("res://addons/konado/editor/pluliter_script_manager.tscn")
var _panel

var import_plugin: EditorImportPlugin

var loader: ResourceFormatLoader

func _enter_tree() -> void:
	add_custom_type("DialogueData", "Resource", preload("res://addons/konado/scripts/dialogue/dialogue_data.gd"), null)
	import_plugin = preload("res://addons/konado/importer/konado_importer.gd").new()
	add_import_plugin(import_plugin)
	
	ResourceLoader.add_resource_format_loader(loader)
	
	add_autoload_singleton("KS", "res://addons/konado/scripts/konado_scripts/konadoscripts_Interpreter.gd")
	
	_panel = panel.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, _panel)
	print_rich("---------------------------------------------------------------------------------")
	print_rich("-------------- [b][i][color=ALICE_BLUE]Konado V1.0[/color][/i][/b] --------------")
	print_rich("---------------------------------------------------------------------------------")

func _exit_tree() -> void:
	remove_import_plugin(import_plugin)
	import_plugin = null
	remove_autoload_singleton("KS")
	remove_control_from_docks(_panel)
	_panel.free()
	ResourceLoader.remove_resource_format_loader(loader)
	remove_custom_type("DialogueData")
