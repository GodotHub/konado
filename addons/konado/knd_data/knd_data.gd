@tool
extends Resource
class_name KND_Data


static var id_number := 0 ## id 计数

## 数据id，为-1的时候需要重新赋值
var id: int


## 源数据字典
@export var source_data: Dictionary = {}

## 依赖管理，保存id
@export var data_deps: Array[int] = []

## 数据名称 集合
static var data_id_map: Dictionary = {}  ## {id:Data}
static var data_list: Array =[]

## 黑名单，不保存到文件中
const black_list: Array[String] = ["source_data",
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
	id = id_number
	id_number += 1
	
	#var property_list = get_property_list()
	## 将属性写到data字典
	#for property in property_list:
		#var property_name = property["name"]
		#if property_name in black_list: # 添加其他需要排除的属性名
			#continue
		#source_data[property_name] = get(property_name)
		
	gen_source_data()
	
	
		
	rename(get("name")) # 重命名
	data_list.append(self)
	data_id_map[id] = get("name")
	emit_changed()
	print_data()
	


func gen_source_data() -> void:
	var property_list = get_property_list()
	# 将属性写到data字典
	for property in property_list:
		var property_name = property["name"]
		if property_name in black_list: # 添加其他需要排除的属性名
			continue
		source_data[property_name] = get(property_name)
	pass

## 从字典更新数据到属性
func update():
	for property in source_data:
		set(property, source_data[property])
		emit_changed()
		
## 重命名，并且保证命名唯一化 new_name:名字 ，name_list:名字集合
func rename(new_name):
	var number = id_number
	for i in data_id_map:
		if get("name") == data_id_map[i]:
			set("name", new_name + "_" + str(number))
			number += 1
	source_data["name"] = get("name")
	data_id_map[id] = get("name")
	print("重命名 ", get("name"))

## 打印数据
func print_data():
	print("数据 id %s %s" % [id, source_data])
	
