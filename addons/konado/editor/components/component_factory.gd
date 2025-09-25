extends Node
## 节点工厂
var node_menu:=PopupMenu.new() # 添加列表弹窗
var EDITOR_CONFIG := {  ## 编辑器配置 
	"component_editor": { ## 节点编辑器
		"演员": {
			"scene": "uid://tgcygvvajaui",
		},
		"场景": {
			"scene": "",
		},
		"跳转到": {
			"scene": "",
		},
	},
	"data_new": {
		
	}
}
#
### 生成对应编辑器的节点列表
#func add_node_factory_data(scene_name: String) ->Dictionary:
	#var node_factory_data = EDITOR_CONFIG[scene_name]
	## 检查 EDITOR_CONFIG 是否为空
	#if EDITOR_CONFIG.is_empty():
		#push_error("EDITOR_CONFIG 未初始化或为空，请检查配置文件是否加载成功。")
		#return node_factory_data
#
	## 检查场景名称是否存在
	#if EDITOR_CONFIG.has(scene_name):
		#return node_factory_data
#
	#else:
		#push_error("未知的场景名称: ", scene_name)
		#return node_factory_data
#
### 生成对应编辑器的弹窗，用于新建节点
#func add_node_menu(scene_name: String) ->PopupMenu:
	#node_menu = PopupMenu.new()
	#node_menu.max_size.y = 800
	#node_menu.min_size.x = 300
	#node_menu.show()
	## 检查 EDITOR_CONFIG 是否为空
	#if EDITOR_CONFIG.is_empty():
		#push_error("EDITOR_CONFIG 未初始化或为空，请检查配置文件是否加载成功。")
		#return node_menu
	## 检查场景名称是否存在
	#if EDITOR_CONFIG.has(scene_name):
		#var node_factory_data = EDITOR_CONFIG[scene_name]
		#for node in node_factory_data:
			#print("弹窗",node)
			#node_menu.add_item(node)
			##node_menu.add_icon_item(load(item["icon"]),node)
	#else:
		#push_error("未知的场景名称: ", scene_name)
	#return node_menu
#
### 创建节点
#func create_node(editor_name: String, node_type: String) -> Node:
	#if EDITOR_CONFIG.has(editor_name):
		#var node_config = EDITOR_CONFIG[editor_name]
		#if node_config.has(node_type):
			#var node_info = node_config[node_type]
			#var scene_path = node_info["scene"]  # 获取场景地址
			#var scene = ResourceLoader.load(scene_path)
			#if scene:
				#var node = scene.instantiate()
				#return node
			#else:
				#push_error("加载失败: ", scene_path)
				#return null
		#else:
			#push_error("未知节点类型 '", node_type, "' for editor '", editor_name, "'")
			#return null
	#else:
		#push_error("未知编辑器类型: ", editor_name)
		#return null
#
#func add_ks_text(editor_name: String, node_type: String)-> String:
	#return ""

## 添加角色
func add_character(template_id:int,character_id:int,status_id:int,avatar:bool=false):
	pass
