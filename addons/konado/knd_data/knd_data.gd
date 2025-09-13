@tool
extends Resource
class_name KND_Data

static var id_number: int = 0 ## id 计数
## 数据名称 集合
static var data_id_map: Dictionary = {}  ## {id:Data}

## 数据id，为-1的时候需要重新赋值
var id: int

## 源数据字典
@export var _source_data: Dictionary = {}

## 依赖管理，保存id
@export var data_deps: Array[int] = []


## 黑名单，不保存到文件中
const black_list: Array[String] = ["_source_data",
 "RefCounted",
 "Resource",
 "Resource",
 "resource_local_to_scene",
 "resource_path",
 "resource_name",
 "resource_scene_unique_id",
 "script",
 "Built-in script",
 "knd_data.gd"]


func _init() -> void:
	_load_data_config()
	id = id_number
	id_number += 1
	
	_save_data_config()

	gen_source_data()
	
	if get("name") != null:
		rename(get("name")) # 重命名
	data_id_map[id] = get("name")
	emit_changed()
	print_data()
	
func _save_data_config() -> void:
	## TODO: 需要优化
	var config = ConfigFile.new()
	
	var err = config.load("res://data.cfg")
	if err != OK:
		config.save("res://data.cfg")
	config.set_value("data", "id_number", id_number)
	config.set_value("data", "data_id_map", data_id_map)
	config.save("res://data.cfg")
	
func _load_data_config() -> void:
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
		
	id_number = config.get_value("data", "id_number")
	data_id_map = config.get_value("data", "data_id_map")
	
func get_source_data() -> Dictionary:
	gen_source_data()
	return self.source_data

func gen_source_data() -> void:
	var property_list = get_property_list()
	# 将属性写到data字典
	for property in property_list:
		var property_name = property["name"]
		if property_name in black_list: # 添加其他需要排除的属性名
			continue
		_source_data[property_name] = get(property_name)
	pass

## 从字典更新数据到属性
func update():
	for property in _source_data:
		set(property, _source_data[property])
		emit_changed()
		
## 重命名，并且保证命名唯一化 new_name:名字 ，name_list:名字集合
func rename(new_name: String) -> void:
	var number = id_number
	if data_id_map.has(new_name):
		set("name", new_name + "_" + str(number))
		number += 1
	#for i in data_id_map:
		#if get("name") == data_id_map[i]:
			#set("name", new_name + "_" + str(number))
			#number += 1
	_source_data["name"] = get("name")
	data_id_map[id] = get("name")
	print("重命名 ", get("name"))

## 打印数据
func print_data():
	print("数据 id %s %s" % [id, _source_data])
	
## 将数据保存到本地
func save_data(path: String) -> void:
	# 首先确保目录存在
	var dir_path = path.get_base_dir()
	if not ensure_directory_exists(dir_path):
		print("无法创建目录: ", dir_path)
		return
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		var error = FileAccess.get_open_error()
		print("文件打开失败，错误代码: ", error)
		return
	
	var json_string: String = JSON.stringify(_source_data, "\t")
	file.store_line(json_string)
	file.close()
	print("保存数据 " + path)


## 从本地加载数据
func load_data(path: String) -> void:
	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		print("文件不存在: ", path)
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		print("文件打开失败，错误代码: ", error)
		return
	
	var data = file.get_line()
	file.close()
	
	# 使用 JSON.parse_string() 替代已弃用的 JSON.parse()
	var json = JSON.new()
	var parse_result = json.parse(data)
	if parse_result == OK:
		_source_data = json.get_data()
		update()
		print("加载数据 " + path)
	else:
		print("JSON 解析失败，错误: ", json.get_error_message(), " 在位置: ", json.get_error_line())

# 确保目录存在的函数
func ensure_directory_exists(path: String) -> bool:
	var dir = DirAccess.open(path)
	if dir == null:
		# 尝试创建目录
		dir = DirAccess.open(path.get_base_dir())
		if dir == null:
			return false
		var error = dir.make_dir_recursive(path)
		return error == OK
	return true
