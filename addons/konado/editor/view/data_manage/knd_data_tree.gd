#@tool
extends Node
### 角色、场景、bgm等数据管理
#
#@export var data_tree: Tree 
#@export var type_tab_bar: TabBar
### 按钮
#@export var floder_button: Button 
#@export var add_button: Button 
#@export var delete_button: Button
#
### 编辑弹窗
#@onready var character_edit: Window = %character_edit
#@onready var background_edit: Window = %background_edit
#
#const love_icon = preload("uid://cl6sx74x3kaow")
#const un_love_icon = preload("uid://dj3bvhjcwquy8")
#
#var current_type      :String ="KND_Character"        ## 当前数据类型
#var current_data_lise :Array   ## 当前数据id列表
#var selected_item     :TreeItem
#var id_list:=[]
#
#func _ready() -> void:
	### 树信号
	##KND_Database.update_data_tree.connect(_build_data_tree)
	#
	#data_tree.empty_clicked.connect(_on_data_tree_empty_clicked)
	#data_tree.multi_selected.connect(_on_tree_multi_selected)
	#data_tree.item_activated.connect(_on_tree_item_activated)
	#data_tree.button_clicked.connect(_on_tree_button_clicked)
	#
	###添加类信号
	##type_tab_bar.current_tab = 0
	#type_tab_bar.tab_changed.connect(_on_tab_bar_select)
	#_on_tab_bar_select(0)
	#_build_data_tree()
	### 添加按钮信号
	#floder_button.pressed.connect(_on_add_folder_pressed)
	#add_button.pressed.connect(_on_add_pressed)
	#delete_button.pressed.connect(_on_delete_pressed)
#
### 在空白处单击，取消选择
#func _on_data_tree_empty_clicked(click_position: Vector2, mouse_button_index: int) -> void:
	#if mouse_button_index==1:
		#id_list.clear()
	#selected_item = null
	#data_tree.deselect_all()
#
### 刷新树
#func _build_data_tree():
	## 清空现有树结构
	#data_tree.clear()
	## 创建根节点
	##current_data_lise = KND_Database.get_data_list(current_type)
	#print(current_data_lise)
	#var root = data_tree.create_item()
	#if current_data_lise.size() == 0:
		#return
	#var node_item_root
	#for i in current_data_lise.size():
		#var node_item = data_tree.create_item(null)
		#if i== 0:
			#node_item_root = node_item
		#var id = current_data_lise[i]
		##node_item.set_icon(0,KND_Database.get_data_property(id,"icon"))
		##node_item.set_text(0,KND_Database.get_data_property(id,"name"))  # 数据的名称绑定到item
		##var love = KND_Database.get_data_property(id,"love")
		#node_item.add_button(0,un_love_icon, id, false, "收藏")
		##if love:
			##node_item.set_button(0,0,love_icon) 
			##if  node_item_root:
				##node_item.move_before( node_item_root)
		##node_item.set_metadata(0,id)
		#
#
### 选择多数据
#func _on_tree_multi_selected(item: TreeItem, column: int, selected: bool) -> void:
	#if selected:
		#if not id_list.has(item.get_metadata(0)):
			#id_list.append(item.get_metadata(0)) 
	#else :
		#id_list.erase(item.get_metadata(0)) 
	#print(id_list)
	#
### 现在数据类型
#func _on_tab_bar_select(tab: int) -> void:
	#current_type = type_tab_bar.get_tab_tooltip(tab)
	#print(current_type)
	#_build_data_tree()
#
### 点击收藏按钮
#func _on_tree_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	#match column:
		#0:  ## 收藏节点
			##var love = KND_Database.get_data_property(id ,"love")
			##KND_Database.set_data(id,"love",!love)
			#print(id, love)
	#_build_data_tree()  # 刷新 Tree
#
### TODO 添加文件夹
#func _on_add_folder_pressed() -> void:
	#pass
	#
### 添加数据
#func _on_add_pressed() -> void:
	#KND_Database.create_data(current_type)
	#_build_data_tree()
#
### 删除数据
#func _on_delete_pressed() -> void:
#
	#for id in id_list:
		#KND_Database.delete_data(id)
	#id_list.clear()
	#_build_data_tree()
#
### 双击item
#func _on_tree_item_activated() -> void:
	#selected_item = data_tree.get_selected()
	#if !selected_item:
		#return
	#var data_id= selected_item.get_metadata(0)
	## 镜头编辑
	#if current_type== "KND_Shot":
		#KND_Database.cur_shot = data_id
		#KND_Database.cur_shot_change.emit()
		#return
	## 其他数据
	#var editor 
	#match current_type:
		#"KND_Character":
			#editor = character_edit
		#"KND_Background":
			#editor = background_edit
		#_:
			#print("未完成数据类型")
	#if editor:
		#editor.data = data_id
		#editor.show()
		#print("编辑：",KND_Database.get_data_property(data_id,"name"))
