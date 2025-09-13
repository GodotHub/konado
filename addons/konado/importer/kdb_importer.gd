@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "konado.kdb"
	
func _get_import_order() -> int:
	return 0
	
func _get_priority() -> float:
	return 1.0

func _get_visible_name() -> String:
	return "Konado Data"

func _get_recognized_extensions() -> PackedStringArray:
	return ["kdb"]

func _get_save_extension() -> String:
	return "res"

func _get_resource_type() -> String:
	return "Resource"

func _get_preset_count() -> int:
	return 1

func _get_preset_name(preset_index) -> String:
	return "Default"

func _get_import_options(path, preset_index) -> Array[Dictionary]:
	return []

func _get_option_visibility(path, option_name, options) -> bool:
	return true

func _import(source_file, save_path, options, platform_variants, gen_files) -> Error:
	var data = KND_Data.new()

	print("Importing %s" % source_file)
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		printerr("Failed to open file: ", source_file, " Error code: ", error)
		return ERR_CANT_OPEN
	var source_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(source_text)
	if parse_result != OK:
		printerr("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		return parse_result
	var json_data = json.get_data()

	if typeof(json_data) != TYPE_DICTIONARY:
		printerr("Parsed JSON is not a Dictionary. Type: ", typeof(json_data))
		return ERR_INVALID_DATA

	data.source_data = json_data

	var output_path = "%s.%s" % [save_path, _get_save_extension()]
	var error = ResourceSaver.save(
		data,
		output_path,
		ResourceSaver.FLAG_COMPRESS | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS
	)
	if error != OK:
		printerr("ResourceSaver error: ", error)
		return error

	return OK

