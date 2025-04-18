# konado_importer.gd
@tool
extends EditorImportPlugin

func _get_importer_name():
	return "konado.story"
	
func _get_import_order() -> int:
	return 0
	
func _get_priority():
	return 1.0

func _get_visible_name():
	return "Konado Story Script"

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
	return []

func _get_option_visibility(path, option_name, options):
	return true

func _import(source_file, save_path, options, platform_variants, gen_files):
	var diadata = KS.process_scripts_to_data(source_file)
	if diadata == null:
		return FAILED
	var output_path = "%s.%s" % [save_path, _get_save_extension()]
	var error = ResourceSaver.save(diadata, output_path, 
		ResourceSaver.FLAG_COMPRESS | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	
	if error != OK:
		printerr(error)
		return error
	
	return OK
