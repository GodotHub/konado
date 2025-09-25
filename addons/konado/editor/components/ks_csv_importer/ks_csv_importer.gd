@tool
extends EditorImportPlugin

func _get_importer_name() -> String:
	return "konado.kscsv"

func _get_import_order() -> int:
	return 0

func _get_priority() -> float:
	return 1.0

func _get_visible_name() -> String:
	return "Konado Editor CSV"

func _get_recognized_extensions() -> PackedStringArray:
	return ["kdic"]

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

	var data = KsCsvDict.new()
	
	data.csv_data = load_csv(source_file)

	var output_path = "%s.%s" % [save_path, _get_save_extension()]
	var error = ResourceSaver.save(data, output_path,
		ResourceSaver.FLAG_COMPRESS | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	
	if error != OK:
		printerr(error)
		return error

	return OK

## 读取 CSV 文件并返回一个字典
func load_csv(ks_statement_path: String) -> Dictionary:
	var file = FileAccess.open(ks_statement_path, FileAccess.READ)
	var data: Dictionary = {}
	
	# 首先读取标题行
	var headers = file.get_csv_line()
	if headers.size() == 0:
		file.close()
		return data
	
	# 读取数据行
	while not file.eof_reached():
		var line = file.get_csv_line()
		if line.size() > 0 and line[0] != "": # 跳过空行和空键的行
			var key = line[0]
			var entry: Dictionary = {
				"按钮名称": line[1] if line.size() > 1 else "",
				"按钮图标": line[2] if line.size() > 2 else "",
				"插入语句": line[3] if line.size() > 3 else "",
				"按钮备注": line[4] if line.size() > 4 else ""
			}
			
			# 如果键已存在，创建或添加到嵌套字典中
			if data.has(key):
				if typeof(data[key]) == TYPE_DICTIONARY:
					# 如果已经是一个字典，转换为数组
					var existing_entry = data[key]
					data[key] = [existing_entry, entry]
				elif typeof(data[key]) == TYPE_ARRAY:
					# 如果已经是数组，添加新条目
					data[key].append(entry)
			else:
				# 键不存在，直接添加
				data[key] = entry
	
	file.close()
	# print("CSV 数据已加载:")
	# print(data)
	return data
