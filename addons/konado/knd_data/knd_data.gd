## KND_Data是所有数据类的基类，所有数据类都应该继承自这个类
@tool
#@abstract
extends Resource
class_name KND_Data

## 数据id，为-1的时候需要重新赋值
var id: int

## 源数据字典
@export var _source_data: Dictionary = {}

## 子资源
@export var sub_source_data: Dictionary[int, Dictionary] = {}

## 依赖管理，保存id
@export var data_deps: Array[int] = []

## 保存路径
@export var save_path: String = ""

## 数据类型
@export var type: String = ""

## 收藏
@export var love: bool = false

## tip
@export var tip: String = ""

## 属性字段黑名单，这些字段不会被保存到本地的KDB文件中
const PROPERTY_BLACK_LIST: Array[String] = [
	"_source_data",
 	"RefCounted",
 	"Resource",
 	"Resource",
 	"resource_local_to_scene",
 	"resource_path",
 	"resource_name",
 	"resource_scene_unique_id",
 	"script",
 	"Built-in script",
 	"knd_data.gd"
	]


## 获取源数据
func get_source_data() -> Dictionary:
	gen_source_data()
	return self._source_data

## 生成源数据，在保存到本地时需要调用
func gen_source_data() -> void:
	var property_list = get_property_list()
	# 将属性写到data字典
	for property in property_list:
		var property_name: String = property["name"]
		if property_name in PROPERTY_BLACK_LIST: # 添加其他需要排除的属性名
			continue
		# 屏蔽脚本
		if property_name.ends_with(".gd"):
			continue
		_source_data[property_name] = get(property_name)
	
func add_sub_source_data(id: int, data: Dictionary) -> void:
	if sub_source_data.has(id):
		printerr("无法添加子资源")
		return
	
	sub_source_data[id] = data
	print("添加子资源" + str(id) + str(data))
	
	# 需要再次保存到本地
	gen_source_data()
	save_data(save_path)
	
func load_sub_source_data(id: int) -> Dictionary:
	if not sub_source_data.has(id):
		printerr("没有这个子资源")
		return {}
	return sub_source_data[id]
	
func update_sub_source_data(id: int, new: Dictionary) -> void:
	if not sub_source_data.has(id):
		printerr("无法修改子资源")
		return
	sub_source_data[id] = new
	gen_source_data()
	save_data(save_path)

## 从字典更新数据到属性
func update() -> void:
	for property in _source_data:
		set(property, _source_data[property])
	self.emit_changed()
		
## 打印数据
func print_data() -> void:
	print("数据 id %s %s" % [id, _source_data])
	
## 将数据保存到本地
func save_data(path: String) -> bool:
	gen_source_data()
	# 首先确保目录存在
	var dir_path = path.get_base_dir()
	if not ensure_directory_exists(dir_path):
		print("无法创建目录: ", dir_path)
		return false
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		var error = FileAccess.get_open_error()
		print("文件打开失败，错误代码: ", error)
		return false
	
	var json_string: String = JSON.stringify(_source_data)
	file.store_line(json_string)
	file.close()
	if KonadoMacros.is_enabled("DEBUG"):
		print("保存数据 " + path)
	return true

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
	
	var json = JSON.new()
	var parse_result = json.parse(data)
	if parse_result == OK:
		_source_data = json.get_data()
		update()
		if KonadoMacros.is_enabled("DEBUG"):
			print("加载数据 " + path)
	else:
		print("JSON 解析失败，错误: ", json.get_error_message(), " 在位置: ", json.get_error_line())
	update()

## 确保目录存在的函数
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
