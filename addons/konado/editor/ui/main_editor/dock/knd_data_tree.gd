@tool
extends Node
## 角色、场景、bgm等数据管理

@onready var data_tree: Tree = %DataTree
@onready var type_tab_bar: TabBar = %TypeTabBar

var current_type      :String ="KND_Character"        ## 当前数据类型
var current_data_lise :Array    ## 当前数据id列表
var selected_item     :TreeItem
var current_shot_id   :int=-1

var shot_list:Array =[]

func _ready() -> void:
	_build_data_tree()

func _build_data_tree():
	# 清空现有树结构
	data_tree.clear()
	# 创建根节点
	current_data_lise = KND_Database.get_data_list(current_type)
	var root = data_tree.create_item()
	#root.set_text(0, current_button.text)
	#root.set_icon(0, current_button.icon)  
	for i in current_data_lise.size():
		var node_item = data_tree.create_item(null)
		var id: int = current_data_lise[i]
		node_item.set_icon(0,KND_Database.get_data_property(id,"icon"))
		# 数据的名称绑定到item
		var node_item_name = KND_Database.get_data_property(id,"name")
		if node_item_name:
			node_item.set_text(0, node_item_name)
		else:
			node_item.set_text(0, "Error Data ID: " + str(id))
			printerr("无法将数据的名称绑定到item，该数据可能已经被外部删除")
			# TODO: 弹窗是否删除以上错误数据
		node_item.set_metadata(0,id)

## 现在数据类型
func _on_tab_bar_select(tab: int) -> void:
	current_type = type_tab_bar.get_tab_tooltip(0)
	print(current_type)

func _on_add_pressed() -> void:
	KND_Database.create_data(current_type)
	_build_data_tree()

func _on_delete_pressed() -> void:
	if current_shot_id != -1:
		KND_Database.delete_data(current_shot_id)
		# 刷新 Tree
		_build_data_tree() 

## 选择数据
func _on_tree_item_selected() -> void:
	selected_item =data_tree.get_selected()
	if selected_item:
		current_shot_id = selected_item.get_metadata(0)
	else :
		current_shot_id = -1
	print("选中：",data_tree.get_selected(),current_shot_id)

## 切换类别
func _on_type_tab_bar_tab_changed(tab: int) -> void:
	current_type = type_tab_bar.get_tab_tooltip(tab)
	print("选择 ",current_type)
	_build_data_tree()
