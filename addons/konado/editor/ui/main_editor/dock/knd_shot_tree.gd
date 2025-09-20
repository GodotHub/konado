@tool
extends Node
@onready var shot_tree: Tree = %ShotTree

var current_data_lise :Array     ## 当前数据
var selected_item     :TreeItem
var current_shot_id   :int=-1

var shot_list:Array =[]

func _ready() -> void:
	_build_data_tree()

func _build_data_tree():
	# 清空现有树结构
	shot_tree.clear()
	# 创建根节点
	current_data_lise = KND_Database.get_data_list("KND_Shot")
	#
	var root = shot_tree.create_item()
	#root.set_text(0, current_button.text)
	#root.set_icon(0, current_button.icon)  
	for i in current_data_lise.size():
		var node_item = shot_tree.create_item(null)
		var shot_id = current_data_lise[i]
		node_item.set_icon(0,KND_Database.get_data_property(shot_id,"icon"))
		node_item.set_text(0,KND_Database.get_data_property(shot_id,"name"))  # 数据的名称绑定到item
		node_item.set_metadata(0,shot_id)

func _on_add_pressed() -> void:
	KND_Database.create_data("KND_Shot")
	_build_data_tree()

	
func _on_delete_pressed() -> void:
	if current_shot_id != -1:
		KND_Database.delete_data(current_shot_id)
		# 刷新 Tree
		_build_data_tree() 


func _on_shot_tree_item_selected() -> void:
	selected_item = shot_tree.get_selected()
	if selected_item:
		current_shot_id = selected_item.get_metadata(0)
	else :
		current_shot_id = -1
	KND_Database.cur_shot = current_shot_id
	
	print("选中：",shot_tree.get_selected(),current_shot_id)
