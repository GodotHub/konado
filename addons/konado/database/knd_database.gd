## KND_Database数据库类，将在Konado启用时添加到自动加载
@tool
extends Node

## 信号定义
signal cur_shot_change
signal update_data_tree

## 项目资源表
@export var knd_data_file_dic: Dictionary[int, String] = {}

## 缓存数据库
var tmp_knd_data_dic: Dictionary[int, KND_Data] = {}

## 数据类型列表 {data_type:[id]}
var data_type_map: Dictionary = {}

## 项目信息
var project_name: String = ""
var project_description: String = ""

## 常量定义
const PROJECT_CONFIG_PATH: String = "res://knd_project.kson"

## 数据类型映射
const KND_CLASS_DB: Dictionary[String, String] = {
	"KND_Data": "res://addons/konado/knd_data/knd_data.gd",
	"KND_Template": "res://addons/konado/knd_data/act/knd_template.gd",
	"KND_Character": "res://addons/konado/knd_data/act/knd_character.gd",
	"KND_Background": "res://addons/konado/knd_data/act/knd_background.gd",
	"KND_Soundeffect": "res://addons/konado/knd_data/audio/knd_soundeffect.gd",
	"KND_Bgm": "res://addons/konado/knd_data/audio/knd_bgm.gd",
	"KND_Voice": "res://addons/konado/knd_data/audio/knd_voice.gd",
	"KND_Shot": "res://addons/konado/knd_data/shot/knd_shot.gd"
}

## 线程安全和状态管理
var data_id_number: int = 0
var data_id_name_map: Dictionary = {}
var database_mutex: Mutex = Mutex.new()
var file_operation_mutex: Mutex = Mutex.new()
var is_saving: bool = false
var pending_operations: Array = []
var operation_mutex: Mutex = Mutex.new()

## 当前镜头
var cur_shot: int:
	set(value):
		if value != cur_shot:
			cur_shot = value
			cur_shot_change.emit()

## 线程安全的ID分配
func _allocate_data_id() -> int:
	database_mutex.lock()
	var new_id = data_id_number
	data_id_number += 1
	database_mutex.unlock()
	return new_id

## 线程安全的名称检查
func _generate_unique_name(base_name: String) -> String:
	database_mutex.lock()
	var unique_name = base_name
	var name_number: int = 1
	
	while data_id_name_map.values().has(unique_name):
		unique_name = base_name + "_" + str(name_number)
		name_number += 1
	
	database_mutex.unlock()
	return unique_name

## 批量操作支持
func _execute_batch_operations() -> void:
	operation_mutex.lock()
	var operations = pending_operations.duplicate()
	pending_operations.clear()
	operation_mutex.unlock()
	
	for operation in operations:
		if operation.type == "create":
			_create_data_internal(operation.type, operation.callback)
		elif operation.type == "delete":
			_delete_data_internal(operation.id, operation.callback)
		elif operation.type == "rename":
			_rename_data_internal(operation.id, operation.new_name, operation.callback)

## 获取指定类型的所有资源ID数组
func get_data_list(type: String) -> Array:
	database_mutex.lock()
	var result = []
	if _has_data_type(type) and data_type_map.has(type):
		result = data_type_map[type].duplicate()
	database_mutex.unlock()
	return result

## 判断是否有这个类型
func _has_data_type(type: String) -> bool:
	if type.is_empty():
		printerr("type不能为空")
		return false
	if not KND_CLASS_DB.has(type):
		printerr("没有这个类型: " + type)
		return false
	return true

## 判断是否有这个data
func _has_data(id: int) -> bool:
	var exists = tmp_knd_data_dic.has(id)
	if not exists:
		printerr("KND_Database没有这个数据: " + str(id))
	return exists

## 保存ID配置（异步优化）
func _save_data_id_config() -> void:
	file_operation_mutex.lock()
	
	var config = ConfigFile.new()
	var err = config.load("res://data.cfg")
	if err != OK:
		config.save("res://data.cfg")
	
	database_mutex.lock()
	config.set_value("data", "id_number", data_id_number)
	config.set_value("data", "data_id_map", data_id_name_map.duplicate())
	database_mutex.unlock()
	
	config.save("res://data.cfg")
	file_operation_mutex.unlock()

## 加载ID配置
func _load_data_id_config() -> void:
	file_operation_mutex.lock()
	
	var config = ConfigFile.new()
	var err = config.load("res://data.cfg")
	if err != OK:
		config.set_value("data", "id_number", 0)
		config.set_value("data", "data_id_map", {})
		config.save("res://data.cfg")

	var id_num = config.get_value("data", "id_number", 0)
	var id_map = config.get_value("data", "data_id_map", {})
	
	database_mutex.lock()
	data_id_number = id_num
	data_id_name_map = id_map
	database_mutex.unlock()
	
	file_operation_mutex.unlock()

## 创建数据实例（线程安全版本）
func create_data_instance(type: String) -> KND_Data:
	if not _has_data_type(type):
		return null
		
	var script_path = KND_CLASS_DB[type]
	var script: GDScript = load(script_path)
	if script != null and script is GDScript:
		var knd_data: KND_Data = script.new()
		
		# 线程安全的ID分配
		knd_data.id = _allocate_data_id()
		knd_data.gen_source_data()
		
		# 线程安全的名称处理
		if knd_data.get("name") != null:
			var base_name = knd_data.get("name")
			var unique_name = _generate_unique_name(base_name)
			
			knd_data.set("name", unique_name)
			knd_data._source_data["name"] = unique_name
			
			database_mutex.lock()
			data_id_name_map[knd_data.id] = unique_name
			database_mutex.unlock()
		
		knd_data.emit_changed()
		if KonadoMacros.is_enabled("DEBUG"):
			knd_data.print_data()
		
		knd_data.type = type
		return knd_data
	else:
		printerr("未找到脚本或脚本不是GDScript: " + script_path)
		return null

## 创建子资源
func create_sub_data(type: String) -> Dictionary:
	if not _has_data_type(type):
		return {}
	
	var data: KND_Data = create_data_instance(type)
	if data == null:
		return {}
	
	return { "id": data.id, "data": data.get_source_data() }

## 新建数据（支持异步回调）
func create_data(type: String, callback: Callable = Callable()) -> int:
	if not _has_data_type(type):
		if callback:
			callback.call(-1)
		return -1
	
	# 如果是批量操作模式，添加到队列
	if is_saving:
		operation_mutex.lock()
		pending_operations.append({
			"type": "create",
			"type_str": type,
			"callback": callback
		})
		operation_mutex.unlock()
		return -2  # 表示已加入队列
	
	return _create_data_internal(type, callback)

## 内部创建实现
func _create_data_internal(type: String, callback: Callable = Callable()) -> int:
	var data: KND_Data = create_data_instance(type)
	if data == null:
		if callback:
			callback.call(-1)
		return -1

	var path_type_str: String = type.to_lower().replace("knd_", "konado_")
	var folder_path: String = "res://konado_data/" + path_type_str
	var save_path: String = folder_path + "/" + str(data.id) + ".kdb"
	
	data.save_path = save_path
	data.type = type

	if not ensure_directory_exists(folder_path):
		printerr("创建目录失败: " + folder_path)
		if callback:
			callback.call(-1)
		return -1
	
	# 文件操作加锁
	file_operation_mutex.lock()
	var save_success = data.save_data(save_path)
	file_operation_mutex.unlock()
	
	if not save_success:
		printerr("保存数据失败: " + save_path)
		if callback:
			callback.call(-1)
		return -1
	
	if KonadoMacros.is_enabled("DEBUG"):
		print("创建数据成功，保存路径为: ", save_path)
	
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
	
	# 线程安全的数据添加
	database_mutex.lock()
	tmp_knd_data_dic[data.id] = data

	if not data_type_map.has(type):
		data_type_map[type] = []
	
	if not data.id in data_type_map[type]:
		data_type_map[type].append(int(data.id))
	database_mutex.unlock()
	
	# 异步保存数据库配置
	_queue_database_save()
	
	if callback:
		callback.call(data.id)
	
	return data.id

## 删除数据（线程安全版本）
func delete_data(id: int, callback: Callable = Callable()) -> bool:
	if is_saving:
		operation_mutex.lock()
		pending_operations.append({
			"type": "delete",
			"id": id,
			"callback": callback
		})
		operation_mutex.unlock()
		return false
	
	return _delete_data_internal(id, callback)

## 内部删除实现
func _delete_data_internal(id: int, callback: Callable = Callable()) -> bool:
	database_mutex.lock()
	var has_data = _has_data(id)
	if not has_data:
		database_mutex.unlock()
		if callback:
			callback.call(false)
		return false
		
	var type: String = get_data_type(id)
	if type.is_empty():
		printerr("无法确定数据类型: " + str(id))
		database_mutex.unlock()
		if callback:
			callback.call(false)
		return false
		
	# 从数据结构中移除
	if data_type_map.has(type) and id in data_type_map[type]:
		data_type_map[type].erase(id)
		
	var data: KND_Data = tmp_knd_data_dic.get(id)
	var path: String = data.save_path
	tmp_knd_data_dic.erase(id)
	
	if data_id_name_map.has(id):
		data_id_name_map.erase(id)
	database_mutex.unlock()
	
	# 文件删除操作
	file_operation_mutex.lock()
	var dir = DirAccess.open("res://")
	if DirAccess.get_open_error() != OK:
		printerr("无法访问res://")
		file_operation_mutex.unlock()
		if callback:
			callback.call(false)
		return false
	
	var success = true
	if dir.file_exists(path):
		var error = dir.remove(path)
		if error != OK:
			printerr("删除文件失败，错误代码: ", error)
			success = false
		else:
			var import_path = path + ".import"
			if dir.file_exists(import_path):
				dir.remove(import_path)
			
			if Engine.is_editor_hint():
				EditorInterface.get_resource_filesystem().scan()
	else:
		printerr("无法删除不存在的文件: ", path)
		success = false
	
	file_operation_mutex.unlock()
	
	if success:
		_queue_database_save()
	
	if callback:
		callback.call(success)
	
	return success

## 数据重命名（线程安全版本）
func rename_data(id: int, new_name: String, callback: Callable = Callable()) -> bool:
	if is_saving:
		operation_mutex.lock()
		pending_operations.append({
			"type": "rename", 
			"id": id,
			"new_name": new_name,
			"callback": callback
		})
		operation_mutex.unlock()
		return false
	
	return _rename_data_internal(id, new_name, callback)

## 内部重命名实现
func _rename_data_internal(id: int, new_name: String, callback: Callable = Callable()) -> bool:
	database_mutex.lock()
	if not tmp_knd_data_dic.has(id):
		database_mutex.unlock()
		if callback:
			callback.call(false)
		return false
		
	var data: KND_Data = tmp_knd_data_dic[id]
	
	if data.get("name") != null:
		if data.get("name") == new_name:
			database_mutex.unlock()
			if callback:
				callback.call(true)
			return true
			
		data.set("name", new_name)
		var unique_name = _generate_unique_name(new_name)
		data.set("name", unique_name)
		data._source_data["name"] = unique_name
		data_id_name_map[data.id] = unique_name
	
	database_mutex.unlock()
	
	data.emit_changed()
	
	file_operation_mutex.lock()
	var save_success = data.save_data(data.save_path)
	file_operation_mutex.unlock()
	
	if not save_success:
		printerr("改名保存失败")
		if callback:
			callback.call(false)
		return false
		
	if KonadoMacros.is_enabled("DEBUG"):
		data.print_data()
	
	_queue_database_save()
	
	if callback:
		callback.call(true)
	
	return true

## 获取数据的属性字典
func get_source_data(id: int) -> Dictionary:
	database_mutex.lock()
	var result = {}
	if tmp_knd_data_dic.has(id):
		var knd_data: KND_Data = tmp_knd_data_dic[id]
		result = knd_data.get_source_data()
	database_mutex.unlock()
	return result

## 获取数据类型
func get_data_type(id: int) -> String:
	database_mutex.lock()
	var result = ""
	if tmp_knd_data_dic.has(id):
		result = tmp_knd_data_dic[id].type
	database_mutex.unlock()
	return result

## 获取数据属性
func get_data_property(id: int, property: String) -> Variant:
	database_mutex.lock()
	var result = null
	#if tmp_knd_data_dic.has(id):
		#var knd_data = tmp_knd_data_dic[id]
		#if knd_data.get(property) != null:
			#result = knd_data.get(property)
	if not tmp_knd_data_dic.has(id):
		printerr("无法获取数据属性 " + property)
	var script_path = KND_CLASS_DB[tmp_knd_data_dic[id].type]
	var script: GDScript = load(script_path)
	if script != null and script is GDScript:
		var data = script.new()
		data._source_data = tmp_knd_data_dic[id]._source_data
		data.update()
		result = data.get(property)
	database_mutex.unlock()
	return result

## 设置数据属性
func set_data(id: int, property: String, value: Variant) -> void:
	database_mutex.lock()
	if tmp_knd_data_dic.has(id):
		tmp_knd_data_dic[id].set(property, value)
	database_mutex.unlock()

## 添加子资源数据
func add_sub_source_data(parent: int, id: int, data: Dictionary) -> void:
	database_mutex.lock()
	if tmp_knd_data_dic.has(parent):
		var knd_data: KND_Data = tmp_knd_data_dic[parent]
		knd_data.add_sub_source_data(id, data)
	database_mutex.unlock()

## 队列化数据库保存（避免频繁保存）
func _queue_database_save() -> void:
	if not is_saving:
		is_saving = true
		call_deferred("_deferred_save_database")

## 延迟保存数据库
func _deferred_save_database() -> void:
	save_database()
	is_saving = false
	
	# 执行挂起的操作
	if not pending_operations.is_empty():
		_execute_batch_operations()
	update_data_tree.emit()

## 保存数据库到本地（线程安全优化）
func save_database() -> void:
	database_mutex.lock()
	
	# 准备保存的数据
	knd_data_file_dic.clear()
	for id in tmp_knd_data_dic:
		if is_instance_valid(tmp_knd_data_dic[id]):
			knd_data_file_dic[id] = tmp_knd_data_dic[id].save_path
	
	var save_data := {
		"version": 2.0,
		"pro_name": project_name,
		"pro_desc": project_description,
		"file_map": knd_data_file_dic.duplicate(),
		"type_map": _clean_type_map(data_type_map.duplicate()),
	}
	
	database_mutex.unlock()
	
	# 序列化为JSON
	var json_string = JSON.stringify(save_data, "\t")
	if json_string.is_empty():
		printerr("JSON序列化失败")
		return
	
	# 写入文件（加锁）
	file_operation_mutex.lock()
	var file = FileAccess.open(PROJECT_CONFIG_PATH, FileAccess.WRITE)
	if file == null:
		printerr("无法打开文件进行写入: ", PROJECT_CONFIG_PATH)
		file_operation_mutex.unlock()
		return
		
	file.store_string(json_string)
	file.close()
	file_operation_mutex.unlock()
	
	_save_data_id_config()
	
	if KonadoMacros.is_enabled("DEBUG"):
		print("数据库配置保存成功: ", PROJECT_CONFIG_PATH)

## 清理类型映射，移除无效数据
func _clean_type_map(type_map: Dictionary) -> Dictionary:
	var cleaned_map = {}
	for type in type_map:
		var valid_ids = []
		for id in type_map[type]:
			if tmp_knd_data_dic.has(id):
				valid_ids.append(id)
		cleaned_map[type] = valid_ids
	return cleaned_map

## 从本地加载数据库（线程安全）
func load_database() -> void:
	file_operation_mutex.lock()
	
	if not FileAccess.file_exists(PROJECT_CONFIG_PATH):
		print("项目配置文件不存在，创建新数据库")
		file_operation_mutex.unlock()
		return
		
	var file = FileAccess.open(PROJECT_CONFIG_PATH, FileAccess.READ)
	if file == null:
		printerr("无法打开配置文件: ", PROJECT_CONFIG_PATH)
		file_operation_mutex.unlock()
		return
		
	var json_string = file.get_as_text()
	file.close()
	file_operation_mutex.unlock()
	
	if json_string.is_empty():
		printerr("配置文件为空")
		return
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		printerr("JSON解析错误: ", json.get_error_message(), " at line ", json.get_error_line())
		return
	
	var parsed: Dictionary = json.get_data()
	if not parsed is Dictionary:
		printerr("配置文件格式错误")
		return
	
	var version = parsed.get("version", 0)
	if version < 2.0:
		printerr("不支持的数据库文件版本", version)
		return
	
	# 准备新数据
	var new_project_name = parsed.get("pro_name", "")
	var new_project_description = parsed.get("pro_desc", "")
	var new_knd_data_file_dic: Dictionary[int, String] = {}
	var new_tmp_knd_data_dic: Dictionary[int, KND_Data] = {}
	var new_data_type_map: Dictionary = {}
	
	var tmp_dic = parsed.get("file_map", {})
	for key in tmp_dic:
		var key_int = key as int
		new_knd_data_file_dic[key_int] = tmp_dic[key] as String
	
	# 加载所有数据文件
	var invalidated_data_files: Array[String] = []
	
	for id in new_knd_data_file_dic:
		var path = new_knd_data_file_dic[id]
		if path.is_empty():
			continue
			
		file_operation_mutex.lock()
		var file_exists = FileAccess.file_exists(path)
		file_operation_mutex.unlock()
		
		if not file_exists:
			printerr("文件不存在: ", path)
			invalidated_data_files.append(path)
			continue
		
		file_operation_mutex.lock()
		var data_file = FileAccess.open(path, FileAccess.READ)
		if data_file == null:
			printerr("无法打开文件: ", path, " Error code: ", FileAccess.get_open_error())
			invalidated_data_files.append(path)
			file_operation_mutex.unlock()
			continue
	
		if data_file.get_length() == 0:
			printerr("文件为空: ", path)
			invalidated_data_files.append(path)
			data_file.close()
			file_operation_mutex.unlock()
			continue
				
		var source_text = data_file.get_as_text()
		data_file.close()
		file_operation_mutex.unlock()

		error = json.parse(source_text)
		if error != OK:
			printerr("数据文件JSON解析错误: ", json.get_error_message(), " at line ", json.get_error_line())
			invalidated_data_files.append(path)
			continue
			
		var json_data = json.get_data()
		if json_data == null or not json_data is Dictionary:
			printerr("数据文件格式错误: ", path)
			invalidated_data_files.append(path)
			continue

		var data = KND_Data.new()
		data._source_data = json_data
		data.update()
		new_tmp_knd_data_dic[id] = data
			
	var tmp_type_map: Dictionary = parsed.get("type_map", {})
	print("11111")
	print(tmp_type_map)
	print("11111")
	for type in tmp_type_map:
		var valid_items: Array[int] = []
		for item in tmp_type_map[type]:
			print(int(item))
			if new_knd_data_file_dic.has(int(item)):
				valid_items.append(int(item))
		new_data_type_map[type] = valid_items
	
	_load_data_id_config()
	
	# 原子性更新所有数据
	database_mutex.lock()
	project_name = new_project_name
	project_description = new_project_description
	knd_data_file_dic = new_knd_data_file_dic
	tmp_knd_data_dic = new_tmp_knd_data_dic
	data_type_map = new_data_type_map
	database_mutex.unlock()
		
	# 清理无效文件
	if not invalidated_data_files.is_empty():
		_cleanup_invalid_files(invalidated_data_files)
		
	print("数据库加载完成，加载了 ", new_tmp_knd_data_dic.size(), " 个数据项")
	
	# 保存清理后的配置
	save_database()

## 清理无效文件
func _cleanup_invalid_files(invalid_paths: Array) -> void:
	file_operation_mutex.lock()
	var dir = DirAccess.open("res://")
	if DirAccess.get_open_error() != OK:
		printerr("无法访问res://目录")
		file_operation_mutex.unlock()
		return
		
	for path in invalid_paths:
		if dir.file_exists(path):
			var error = dir.remove(path)
			if error == OK:
				print("删除无效数据文件: ", path)
				var import_path = path + ".import"
				if dir.file_exists(import_path):
					dir.remove(import_path)
			else:
				printerr("删除文件失败，错误代码: ", error, " 文件: ", path)
		else:
			print("文件不存在，无需删除: ", path)
			
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
	file_operation_mutex.unlock()

## 确保目录存在
func ensure_directory_exists(path: String) -> bool:
	file_operation_mutex.lock()
	var result = true
	if not DirAccess.dir_exists_absolute(path):
		var error = DirAccess.make_dir_recursive_absolute(path)
		if error == OK:
			print("目录创建成功: ", path)
		else:
			printerr("目录创建失败，错误代码: ", error, " 路径: ", path)
			result = false
	file_operation_mutex.unlock()
	return result

## 获取所有数据ID
func get_all_data_ids() -> Array:
	database_mutex.lock()
	var result = tmp_knd_data_dic.keys()
	database_mutex.unlock()
	return result

## 根据类型获取数据
func get_data_by_type(type: String) -> Array:
	database_mutex.lock()
	var result := []
	for id in tmp_knd_data_dic:
		if get_data_type(id) == type:
			result.append(tmp_knd_data_dic[id])
	database_mutex.unlock()
	return result

## 根据名称查找数据
func find_data_by_name(name: String, type: String = "") -> Array:
	database_mutex.lock()
	var result := []
	for id in tmp_knd_data_dic:
		var data = tmp_knd_data_dic[id]
		if (type.is_empty() or get_data_type(id) == type) and data.has_method("get_name"):
			if data.get_name() == name:
				result.append(data)
	database_mutex.unlock()
	return result
