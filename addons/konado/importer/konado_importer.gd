@tool
extends EditorImportPlugin

func _get_importer_name():
	return "konado.scripts"
	
func _get_import_order() -> int:
	return 0
	
func _get_priority():
	return 1.0

func _get_visible_name():
	return "Konado Scripts"

func _get_recognized_extensions():
	return ["ks"]

func _get_save_extension():
	return "res"

func _get_resource_type():
	return "Resource"

func _get_preset_count():
	return 1

func _get_preset_name(preset_index):
	return "Default"

func _get_import_options(path, preset_index):
	return [
		{
			"name": "allow_skip_error_line",
			"default_value": false
		},
		{
			"name": "enable_actor_validation",
			"default_value": true
		}
		]

func _get_option_visibility(path, option_name, options):
	return true

func _import(source_file, save_path, options, platform_variants, gen_files):
	var interpreter = KonadoScriptsInterpreter.new()

	interpreter.init_insterpreter({
		"allow_custom_suffix": true,
		"allow_skip_error_line": options["allow_skip_error_line"],
		"enable_actor_validation": options["enable_actor_validation"]
	})
	
	var diadata = interpreter.process_scripts_to_data(source_file)
	if diadata == null:
		printerr("Failed to process scripts")
		return FAILED
	var output_path = "%s.%s" % [save_path, _get_save_extension()]
	var error = ResourceSaver.save(diadata, output_path,
		ResourceSaver.FLAG_COMPRESS | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	
	if error != OK:
		printerr(error)
		return error
	
	return OK
