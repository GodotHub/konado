## KND_Database数据库类
@tool
extends Node
#class_name KND_Database

## 项目资源表，未来考虑分页（现在应该写进去一部红楼梦没问题）
@export var knd_data_file_dic: Dictionary[int, String] = {}

## 缓存数据库，在缓存中操作然后再调用 save_database() 持久化保存数据库
var tmp_knd_data_dic: Dictionary[int, KND_Data] = {}

## 数据类型列表 {data_type:[id]}
var data_type_map: Dictionary = {}

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
	"KND_Shot": "res://addons/konado/knd_data/shot/knd_shot.gd",
## 对话
	"KND_Dialogue": "res://addons/konado/knd_data/dialogue/knd_dialogue.gd",
## 具体的对话类型
	"KND_Ordinary_Dialogue": "res://addons/konado/knd_data/dialogue/knd_ordinary_dialogue.gd",
	"KND_DisplayActor_Dialogue": "res://addons/konado/knd_data/dialogue/knd_display_actor_dialogue.gd",
	"KND_Actor_Change_State_Dialogue": "res://addons/konado/knd_data/dialogue/knd_actor_change_state_dialogue.gd"
}

## TODO :
var cur_shot ## 当前镜头


## 获取指定类型的所有资源ID数组
func get_data_list(type: String) -> Array:
	if not _has_data_type(type):
		return []
	return data_type_map[type]
	
#func get_all_data_ids_by_type(type: String) -> Array[int]:
	#if not _has_data_type(type):
		#return []
	#return KND_Data.data_type_map[type]
	#
	#var result: Array[int] = []
	#var target_script: GDScript = load(KND_CLASS_DB[type])
	#
	#for id in tmp_knd_data_dic:
		#var data: KND_Data = tmp_knd_data_dic[id]
		#if data.get_script() == target_script:
			#result.append(id)
	#return result
	
## 判断是否有这个类型，保证创建数据时不会出错
func _has_data_type(type: String) -> bool:
	if type == "":
		printerr("type不能为空")
		return false
	if not KND_CLASS_DB.has(type):
		printerr("没有这个类型"+type)
		return false
	return true
	
## 判断是否有这个data
func _has_data(id: int) -> bool:
	if not tmp_knd_data_dic.has(id):
		printerr("KND_Database没有这个数据"+str(id))
		return false
	return true

## 创建数据实例，如果创建失败，返回null
func create_data_instance(type: String) -> KND_Data:
	if _has_data_type(type) == false:
		return null
	var script_path = KND_CLASS_DB[type]
	var script: GDScript = load(script_path)
	if script != null && script is GDScript:
		return script.new(false)
	else:
		printerr("Script not found or is not GDScript: " + script_path)
		return null

## 创建子资源
func create_sub_data(type: String) -> Dictionary:
	if _has_data_type(type) == false:
		return {}
	
	var data: KND_Data = create_data_instance(type)
	if data == null:
		return {}
	return { "id": data.id, "data": data.get_source_data() }

## 新建数据 type : 数据类名，返回数据id，如果创建失败，返回-1
func create_data(type: String) -> int:
	if _has_data_type(type) == false:
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
	print(data.save_path)

	if ensure_directory_exists(folder_path) == false:
		printerr("创建目录失败")
		return -1
	
	data.save_data(save_path)
	
	print("创建数据成功，保存路径为: ", save_path)
	
	# 不知道有没有用，还能不能立即触发导入
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
	
	# 添加到缓存
	tmp_knd_data_dic[data.id] = data

	var id = data.id
	data.type = type
	## TODO :测试	
	# 将数据添加到对应列表
	if data_type_map.has(type):
		data_type_map[type].append(id)
	else :
		var data_list:Array = []
		data_list.append(id)
		data_type_map[type] = data_list
		
		
	return id

## TODO : BUG 
## 删除数据，如果删除成功返回 true，失败则返回 false
func delete_data(id: int) -> bool:
	if not _has_data(id):
		printerr("数据库中没有这个数据" + str(id))
		return false
	# 删除属性表数据
	var type:String = get_data_type(id)
	if data_type_map.has(type):
		data_type_map[type].erase(id)

	print(KND_Data.data_id_map[id])
	# 删除文件
	var data: KND_Data = tmp_knd_data_dic.get(id)
	var path: String = data.save_path

	var dir = DirAccess.open("res://")
	if DirAccess.get_open_error() != OK:
		printerr("无法访问res://")
		return false
	
	if dir.file_exists(path):
		var error = dir.remove(path)
		if Engine.is_editor_hint():
			EditorInterface.get_resource_filesystem().scan()
		if error != OK:
			printerr("删除文件失败，错误代码: ", error)
			return false
	else:
		printerr("无法删除不存在的文件")
		return false
		
	print("文件删除成功: ", path)
	#print("当前数据名字表: ",KND_Data.data_id_map)
	
	# 从id映射表删除
	if KND_Data.data_id_map.has(id):
		KND_Data.data_id_map.erase(id)
		
	# 从缓存表删除
	tmp_knd_data_dic.erase(id)
	
	return true
	

## 获取数据的属性字典
func get_source_data(id: int) -> Dictionary:
	if not tmp_knd_data_dic.has(id):
		return {}
	
	var knd_data: KND_Data = tmp_knd_data_dic[id]
	var data: Dictionary = knd_data.get_source_data()
	return data
	
## 获取数据类型
func get_data_type(id: int) -> String:
	return get_source_data(id).get("type")

## TODO :测试
## 获取数据属性
func get_data_property(id: int, property: String) -> Variant:
	if not tmp_knd_data_dic.has(id):
		return null
	var knd_data: KND_Data = tmp_knd_data_dic[id]
	return knd_data.get(property)

## 设置数据属性
func set_data(id: int, property: String, value: Variant) -> void:
	if not tmp_knd_data_dic.has(id):
		return
	var knd_data: KND_Data = tmp_knd_data_dic[id]
	knd_data.set(property, value)

## TODO : 测试	
## 数据重命名
func rename_data(id:int, new_name:String):
	var data: KND_Data = tmp_knd_data_dic[id]
	data.rename(new_name)

func add_sub_source_data(parent: int, id: int, data: Dictionary) -> void:
	if not tmp_knd_data_dic.has(parent):
		printerr("无父节数据")
	var knd_data: KND_Data = tmp_knd_data_dic[parent]
	knd_data.add_sub_source_data(id, data)


## TODO : 保存data_type_map数据
## 保存数据库到本地
func save_database() -> void:
	knd_data_file_dic = {}
	for tkd in tmp_knd_data_dic.keys():
		if not tmp_knd_data_dic[tkd] == null:
			knd_data_file_dic[tkd] = tmp_knd_data_dic[tkd].save_path
	var json_string = JSON.stringify(knd_data_file_dic, "\t")
	## 写入到项目根目录，创建一个 knd_project.kson 文件
	var file = FileAccess.open("res://knd_project.kson", FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

## TODO : 加载data_type_map数据
## 从本地加载数据库
func load_database() -> void:
	var file = FileAccess.open("res://knd_project.kson", FileAccess.READ)
	if file == null:
		printerr("文件不存在")
		return
	var json_string = file.get_as_text()
	# 防止空文件报错
	if json_string.length() <= 0:
		json_string = "{}"
	file.close()
	
	var parsed: Dictionary = JSON.parse_string(json_string) as Dictionary
	if not parsed is Dictionary:
		printerr("Invalid JSON format")
		return
	
	# 类型转换
	knd_data_file_dic = {}
	for key in parsed:
		# 将字符串键转换为整数，保持值不变
		if key is String and key.is_valid_int():
			knd_data_file_dic[key.to_int()] = parsed[key]
		else:
			push_error("Key %s is not a valid integer" % key)
	
	# 失效的数据
	var invalidated_data_file: Array[String] = []
	# 添加到缓存
	tmp_knd_data_dic = {}
	for kdf in knd_data_file_dic.keys():
		var path = knd_data_file_dic[kdf]
		if not path == "":
			if not FileAccess.file_exists(path):
				printerr("无法打开找不到的文件，可能已经被删除: ", path)
				continue
			# 读取文件内容
			var kdffile = FileAccess.open(path, FileAccess.READ)
			if kdffile == null:
				var error = FileAccess.get_open_error()
				printerr("无法打开文件: ", path, " Error code: ", error)
				invalidated_data_file.append(path)
				continue
	
			# 检查文件是否为空
			if kdffile.get_length() == 0:
				printerr("跳过并删除空文件: ", path)
				invalidated_data_file.append(path)
				var dir = DirAccess.open("res://")
				if DirAccess.get_open_error() != OK:
					printerr("无法访问res://")
				if dir.file_exists(path):
					var error = dir.remove(path)
					if error != OK:
						printerr("删除文件失败，错误代码: ", error)
					else:
						printerr("无法删除不存在的文件")
				kdffile.close()
				continue
				
			var source_text = kdffile.get_as_text()
			kdffile.close()

			var json = JSON.new()
			var parse_result = json.parse(source_text)
			if parse_result != OK:
				printerr("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
				continue
			var json_data = json.get_data()
				
			if json_data == null:
				printerr("Failed to parse file data as variable")
				continue

			# 确保读取的数据是字典类型
			if typeof(json_data) != TYPE_DICTIONARY:
				printerr("Parsed data is not a Dictionary. Type: ", typeof(json_data))
				continue
			var data = KND_Data.new(true)
			data._source_data = json_data
			data.update()
			tmp_knd_data_dic[kdf] = data
			
	# 遍历删除失效的数据
	if invalidated_data_file.size() > 0:
		var dir = DirAccess.open("res://")
		if DirAccess.get_open_error() != OK:
			printerr("无法访问res://")
		for invalidated_path in invalidated_data_file:
			if dir.file_exists(invalidated_path):
				var error = dir.remove(invalidated_path)
				print("删除无效数据文件", invalidated_path)
				if error != OK:
					printerr("删除文件失败，错误代码: ", error)
				# 同时删除import文件
				dir.remove(invalidated_path.replace(".kdb", ".kdb.import"))
			else:
				printerr("无法删除不存在的文件", invalidated_path)

func ensure_directory_exists(path: String) -> bool:
	# 检查目录是否已经存在
	if DirAccess.dir_exists_absolute(path):
		print("目录已存在: ", path)
		return true
		
	# 尝试递归创建目录
	var error = DirAccess.make_dir_recursive_absolute(path)
	if error == OK:
		print("目录创建成功: ", path)
		return true
	else:
		print("目录创建失败，错误代码: ", error)
		return false
