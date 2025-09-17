@tool
extends Control
## 数据管理器窗口

@onready var node_tree: Tree = %Tree
var current_data_lise :Array     ## 当前数据
var selected_item     :TreeItem
var current_data_id   :int=-1

var list:Array =[]

func _build_data_tree():
	# 清空现有树结构
	node_tree.clear()
	# 创建根节点
	current_data_lise = KND_Database.get_data_list("KND_Character")
	#
	var root = node_tree.create_item()
	#root.set_text(0, current_button.text)
	#root.set_icon(0, current_button.icon)  
	for i in current_data_lise.size():
		var node_item = node_tree.create_item(null)
		var data_id = current_data_lise[i]
		node_item.set_icon(0,KND_Database.get_data_property(data_id,"icon"))
		node_item.set_text(0,KND_Database.get_data_property(data_id,"name"))  # 数据的名称绑定到item
		node_item.set_metadata(0,data_id)

func _on_tree_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int):
	pass
	#_build_data_tree() 
	
func _on_tree_item_selected() -> void:
	selected_item = node_tree.get_selected()
	if selected_item:
		current_data_id = selected_item.get_metadata(0)
	else :
		current_data_id = -1
	print("选中：",node_tree.get_selected(),current_data_id)


func _on_add_pressed() -> void:
	KND_Database.create_data("KND_Character")
	_build_data_tree()

func _on_copy_pressed() -> void:
	pass
	
func _on_delete_pressed() -> void:
	if current_data_id != -1:
		KND_Database.delete_data(current_data_id)
		# 刷新 Tree
		_build_data_tree() 
