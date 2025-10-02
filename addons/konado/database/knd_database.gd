## KND_Database数据库类，将在Konado启用时添加到自动加载
@tool
extends Node

## 当前镜头变更
signal cur_shot_change

## 刷新节点树（当新建、删除、重命名数据时发送）
signal update_data_tree

## 项目资源表，未来考虑分页（现在应该写进去一部红楼梦没问题）
@export var knd_data_file_dic: Dictionary[int, String] = {}

## 缓存数据库，在缓存中操作然后再调用 save_database() 持久化保存数据库
var tmp_knd_data_dic: Dictionary[int, KND_Data] = {}

## 数据类型列表 {data_type:[id]}
var data_type_map: Dictionary = {}

## 项目名称
var project_name: String = ""

## 项目描述
var project_description: String = ""

## 项目配置文件路径
const PROJECT_CONFIG_PATH: String = "res://knd_project.kson"

## 数据类型,key为类型名，value为脚本路径
const KND_CLASS_DB: Dictionary[String, String] = {
## KND_Data 基类
	"KND_Data": "res://addons/konado/knd_data/knd_data.gd",
## 资源
	"KND_Template":"res://addons/konado/knd_data/act/knd_template.gd",
	"KND_Character": "res://addons/konado/knd_data/act/knd_character.gd",
	"KND_Background": "res://addons/konado/knd_data/act/knd_background.gd",
	"KND_Soundeffect": "res://addons/konado/knd_data/audio/knd_soundeffect.gd",
	"KND_Bgm": "res://addons/konado/knd_data/audio/knd_bgm.gd",
	"KND_Voice": "res://addons/konado/knd_data/audio/knd_voice.gd",
## 镜头
	"KND_Shot": "res://addons/konado/knd_data/shot/knd_shot.gd"
}

var data_id_number: int = 0 ## id 计数

var data_id_name_map: Dictionary = {} 

## TODO :
var cur_shot :int :## 当前镜头
	set(value):
		if value!=cur_shot:
			cur_shot = value
			cur_shot_change.emit()


## 获取指定类型的所有资源ID数组
func get_data_list(type: String) -> Array:
	if not _has_data_type(type):
		return []
	if not data_type_map.has(type):
		return []
	return data_type_map[type]  # 返回副本避免外部修改

## 判断是否有这个类型，保证创建数据时不会出错
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
	if not tmp_knd_data_dic.has(id):
		printerr("KND_Database没有这个数据: " + str(id))
		return false
	return true
	
func _save_data_id_config() -> void:
	## TODO: 需要优化
	var config = ConfigFile.new()
	
	var err = config.load("res://data.cfg")
	if err != OK:
		config.save("res://data.cfg")
	config.set_value("data", "id_number", data_id_number)
	config.set_value("data", "data_id_map", data_id_name_map)
	config.save("res://data.cfg")
	
func _load_data_id_config() -> void:
	## TODO: 需要优化
	var config = ConfigFile.new()
	
	var err = config.load("res://data.cfg")
	if err != OK:
		config.set_value("data", "id_number", 0)
		config.set_value("data", "data_id_map", {})
		config.save("res://data.cfg")

	if config.get_value("data", "id_number") == null:
		config.set_value("data", "id_number", 0)
	if config.get_value("data", "data_id_map") == null:
		config.set_value("data", "data_id_map", {})
		
	data_id_number = config.get_value("data", "id_number")
	data_id_name_map = config.get_value("data", "data_id_map")
	


## 创建数据实例，如果创建失败，返回null
func create_data_instance(type: String) -> KND_Data:
	if not _has_data_type(type):
		return null
		
	var script_path = KND_CLASS_DB[type]
	var script: GDScript = load(script_path)
	if script != null and script is GDScript:
		# 新建一个KND_Data实例
		var knd_data: KND_Data = script.new()
		# 生成唯一id
		#_load_data_id_config()
		knd_data.id = data_id_number
		data_id_number += 1
		knd_data.gen_source_data()
		
		## 如果有name字段，则重命名
		if knd_data.get("name") != null:
			var name_number: int = 1
			var tmp_name: String = knd_data.get("name")
			
			for i in data_id_name_map.keys():
				if data_id_name_map.find_key(knd_data.get("name")) != null:
				#if knd_data.get("name") == data_id_name_map[i]:
					knd_data.set("name", tmp_name + "_" + str(name_number))
					name_number += 1
			knd_data._source_data["name"] = knd_data.get("name")
			data_id_name_map[knd_data.id] = knd_data.get("name")
		knd_data.emit_changed()
		knd_data.print_data()
		
		# 赋值对应类型
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

## 新建数据 type : 数据类名，返回数据id，如果创建失败，返回-1
func create_data(type: String) -> int:
	if not _has_data_type(type):
		return -1
	
	var data: KND_Data = create_data_instance(type)
	if data == null:
		return -1

	# type变小写
	var path_type_str: String = type.to_lower().replace("knd_", "konado_")

	# 文件路径
	var folder_path: String = "res://konado_data/" + path_type_str
	
	# 保存路径
	var save_path: String = folder_path + "/" + str(data.id) + ".kdb"
	
	data.save_path = save_path
	data.type = type

	if not ensure_directory_exists(folder_path):
		printerr("创建目录失败: " + folder_path)
		return -1
	
	if not data.save_data(save_path):
		printerr("保存数据失败: " + save_path)
		return -1
	
	print("创建数据成功，保存路径为: ", save_path)
	
	## TODO: 不知道有没有用，还能不能立即触发导入
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
	
	# 添加到缓存
	tmp_knd_data_dic[data.id] = data

	# 将数据添加到对应列表
	if not data_type_map.has(type):
		data_type_map[type] = []
	
	if not data.id in data_type_map[type]:
		data_type_map[type].append(int(data.id))
		
	# 自动保存数据库配置
	save_database()
	return data.id

## 删除数据，如果删除成功返回 true，失败则返回 false
func delete_data(id: int) -> bool:
	if not _has_data(id):
		return false
		
	# 获取数据类型
	var type: String = get_data_type(id)
	if type.is_empty():
		printerr("无法确定数据类型: " + str(id))
		return false
		
	# 删除属性表数据
	if data_type_map.has(type) and id in data_type_map[type]:
		data_type_map[type].erase(id)

	# 删除文件
	var data: KND_Data = tmp_knd_data_dic.get(id)
	var path: String = data.save_path

	var dir = DirAccess.open("res://")
	if DirAccess.get_open_error() != OK:
		printerr("无法访问res://")
		return false
	
	if dir.file_exists(path):
		var error = dir.remove(path)
		if error != OK:
			printerr("删除文件失败，错误代码: ", error)
			return false
			
		# 删除对应的import文件
		var import_path = path + ".import"
		if dir.file_exists(import_path):
			dir.remove(import_path)
			
		if Engine.is_editor_hint():
			EditorInterface.get_resource_filesystem().scan()
	else:
		printerr("无法删除不存在的文件: ", path)
		return false
		
	print("文件删除成功: ", path)
		
	# 从缓存表删除
	tmp_knd_data_dic.erase(id)
	
	# 从id映射表删除
	if data_id_name_map.has(id):
		data_id_name_map.erase(id)
		
	# 更新配置文件
	save_database()
	return true

## 获取数据的属性字典
func get_source_data(id: int) -> Dictionary:
	if not tmp_knd_data_dic.has(id):
		return {}
	
	var knd_data: KND_Data = tmp_knd_data_dic[id]
	return knd_data.get_source_data()
	
## 获取数据类型
func get_data_type(id: int) -> String:
	if not tmp_knd_data_dic.has(id):
		return ""
	return tmp_knd_data_dic[id].type

## 获取数据属性
func get_data_property(id: int, property: String) -> Variant:
	if not tmp_knd_data_dic.has(id):
		printerr("无法获取数据属性 " + property)
		return null
	var script_path = KND_CLASS_DB[tmp_knd_data_dic[id].type]
	var script: GDScript = load(script_path)
	if script != null and script is GDScript:
		var data = script.new()
		data._source_data = tmp_knd_data_dic[id]._source_data
		data.update()
		return data.get(property)
	return null

## 设置数据属性
func set_data(id: int, property: String, value: Variant) -> void:
	if not tmp_knd_data_dic.has(id):
		return
	tmp_knd_data_dic[id].set(property, value)

## 数据重命名
func rename_data(id: int, new_name: String) -> bool:
	if not tmp_knd_data_dic.has(id):
		return false
		
	var data: KND_Data = tmp_knd_data_dic[id]
	
	if data.get("name") != null:
		if data.get("name") == new_name:
			return true
		data.set("name", new_name)
		var name_number: int = 1
		var tmp_name: String = data.get("name")
			
		for i in data_id_name_map.keys():
			if data_id_name_map.find_key(data.get("name")) != null:
				data.set("name", tmp_name + "_" + str(name_number))
				name_number += 1
		data._source_data["name"] = data.get("name")
		data_id_name_map[data.id] = data.get("name")
	data.emit_changed()
	data.print_data()
	return true

func add_sub_source_data(parent: int, id: int, data: Dictionary) -> void:
	if not tmp_knd_data_dic.has(parent):
		printerr("无父节数据")
		return
		
	var knd_data: KND_Data = tmp_knd_data_dic[parent]
	knd_data.add_sub_source_data(id, data)


## TODO : 保存data_type_map数据
## 保存数据库到本地
func save_database() -> void:
	# 更新文件路径字典
	knd_data_file_dic.clear()
	for id in tmp_knd_data_dic:
		if is_instance_valid(tmp_knd_data_dic[id]):
			knd_data_file_dic[id] = tmp_knd_data_dic[id].save_path
	
	# 准备保存的数据
	var save_data := {
		"version": 2.0,
		"pro_name": project_name,
		"pro_desc": project_description,
		"file_map": knd_data_file_dic,
		"type_map": data_type_map,
	}
	
	# 序列化为JSON
	var json_string = JSON.stringify(save_data, "\t")
	if json_string.is_empty():
		printerr("JSON序列化失败")
		return
	
	# 写入文件
	var file = FileAccess.open(PROJECT_CONFIG_PATH, FileAccess.WRITE)
	if file == null:
		printerr("无法打开文件进行写入: ", PROJECT_CONFIG_PATH)
		return
		
	file.store_string(json_string)
	file.close()
	
	_save_data_id_config()
	
	print("数据库配置保存成功: ", PROJECT_CONFIG_PATH)
	#update_data_tree.emit()


## 从本地加载数据库
func load_database() -> void:
	# 检查配置文件是否存在
	if not FileAccess.file_exists(PROJECT_CONFIG_PATH):
		print("项目配置文件不存在，创建新数据库")
		return
		
	var file = FileAccess.open(PROJECT_CONFIG_PATH, FileAccess.READ)
	if file == null:
		printerr("无法打开配置文件: ", PROJECT_CONFIG_PATH)
		return
		
	var json_string = file.get_as_text()
	file.close()
	
	if json_string.is_empty():
		printerr("配置文件为空")
		return
	
	# 解析JSON
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		printerr("JSON解析错误: ", json.get_error_message(), " at line ", json.get_error_line())
		return
	
	var parsed: Dictionary = json.get_data()
	if not parsed is Dictionary:
		printerr("配置文件格式错误")
		return
	
	# 处理版本兼容性
	var version = parsed.get("version", 0)
	if version == 0:
		printerr("不支持的数据库文件版本",version)
	if version < 2.0:
		printerr("不支持的数据库文件版本",version)
		return
	else:
		project_name = parsed.get("pro_name", "")
		project_description = parsed.get("pro_desc", "")
		
		data_type_map.clear()
		#data_type_map = parsed.get("type_map", {})
		
		## 获取主表
		var tmp_dic = parsed.get("file_map", {})
		for key in tmp_dic:
			var key_int = key as int
			knd_data_file_dic[key_int] = tmp_dic[key] as String
	
	# 加载所有数据文件
	tmp_knd_data_dic.clear()
	var invalidated_data_files: Array[String] = []
	
	for id in knd_data_file_dic:
		var path = knd_data_file_dic[id]
		if path.is_empty():
			continue
			
		if not FileAccess.file_exists(path):
			printerr("文件不存在: ", path)
			invalidated_data_files.append(path)
			continue
		
		# 读取文件内容
		var data_file = FileAccess.open(path, FileAccess.READ)
		if data_file == null:
			printerr("无法打开文件: ", path, " Error code: ", FileAccess.get_open_error())
			invalidated_data_files.append(path)
			continue
	
		# 检查文件是否为空
		if data_file.get_length() == 0:
			printerr("文件为空: ", path)
			invalidated_data_files.append(path)
			data_file.close()
			continue
				
		var source_text = data_file.get_as_text()
		data_file.close()

		# 解析数据文件
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

		# 创建数据实例，复制加载模式
		var data = KND_Data.new()
		data._source_data = json_data
		data.update()
		tmp_knd_data_dic[id] = data
			
			
	var tmp_type_map: Dictionary = parsed.get("type_map", {})
	for type in tmp_type_map:
		for item in tmp_type_map[type]:
			if not knd_data_file_dic.has(item as int):
				tmp_type_map[type].erase(item)
			
	data_type_map = tmp_type_map
	
	_load_data_id_config()
		
	# 清理无效文件
	if not invalidated_data_files.is_empty():
		_cleanup_invalid_files(invalidated_data_files)
		
	print("数据库加载完成，加载了 ", tmp_knd_data_dic.size(), " 个数据项")
	
	
	# 重新保存配置，移除无效条目
	save_database()
	

	

## 清理无效文件
func _cleanup_invalid_files(invalid_paths: Array) -> void:
	var dir = DirAccess.open("res://")
	if DirAccess.get_open_error() != OK:
		printerr("无法访问res://目录")
		return
		
	for path in invalid_paths:
		if dir.file_exists(path):
			var error = dir.remove(path)
			if error == OK:
				print("删除无效数据文件: ", path)
				# 同时删除import文件
				var import_path = path + ".import"
				if dir.file_exists(import_path):
					dir.remove(import_path)
			else:
				printerr("删除文件失败，错误代码: ", error, " 文件: ", path)
		else:
			print("文件不存在，无需删除: ", path)
			
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()

## 确保目录存在
func ensure_directory_exists(path: String) -> bool:
	if DirAccess.dir_exists_absolute(path):
		return true
		
	var error = DirAccess.make_dir_recursive_absolute(path)
	if error == OK:
		print("目录创建成功: ", path)
		return true
	else:
		printerr("目录创建失败，错误代码: ", error, " 路径: ", path)
		return false

## 获取所有数据ID
func get_all_data_ids() -> Array:
	return tmp_knd_data_dic.keys()

## 根据类型获取数据
func get_data_by_type(type: String) -> Array:
	var result := []
	for id in tmp_knd_data_dic:
		if get_data_type(id) == type:
			result.append(tmp_knd_data_dic[id])
	return result
	
## 设置项目名称
func set_project_name(name: String):
	self.project_name = name
	
## 获取项目名称
func get_project_name() -> String:
	return self.project_name
	
## 设置项目描述
func set_project_description(description: String):
	self.project_description = description
	
## 获取项目描述
func get_project_description() -> String:
	return self.project_description
	
## 根据名称查找数据
func find_data_by_name(name: String, type: String = "") -> Array:
	var result := []
	for id in tmp_knd_data_dic:
		var data = tmp_knd_data_dic[id]
		if (type.is_empty() or get_data_type(id) == type) and data.has_method("get_name"):
			if data.get_name() == name:
				result.append(data)
	return result
	
	
## 创建ks文件，返回文件路径
func create_ks_file(knd_shot_id: int) -> String:
	var file_path = ""
	return file_path
	
## 删除ks文件，返回是否删除成功
func delete_ks_file(knd_shot_id: int) -> bool:
	return true
	
## 更新ks文件内容
func update_ks_file_content(knd_shot_id: int, new_content: String) -> void:
	pass
	
## 保存ks文件并编译成knd shot数据，如果编译成功返回Success，否则返回错误信息，用于编辑器报错提示
func save_ks_file_to_shot() -> String:
	return "Success"
	
## 获取ks文件内容
func get_ks_file_content(knd_shot_id: int) -> String:
	var content = ""
	return content
