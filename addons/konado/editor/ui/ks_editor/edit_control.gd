@tool
extends Node
## 镜头编辑器视图交互操作

@onready var staff_window: Window = %staff_window
@onready var shot_id: OptionButton = %shot_id
var cur_shot :int ## 当前镜头
var shot_list:Array
func _ready() -> void:
	KND_Database.cur_shot_change.connect(edit_shot)
 
func edit_shot():
	cur_shot = KND_Database.cur_shot
	shot_id.text = KND_Database.get_data_property(cur_shot,"name")
	
## 添加演员按钮
func _on_add_act_pressed() -> void:
	staff_window.show()

## 按下选择镜头
func _on_shot_id_pressed() -> void:
	shot_id.clear()
	shot_list = KND_Database.get_data_list("KND_Shot")
	for i in shot_list.size():
		cur_shot = shot_list[i]
		var shot_name = KND_Database.get_data_property(cur_shot,"name")
		shot_id.add_item(shot_name)

## 选择镜头
func _on_shot_id_item_selected(index: int) -> void:
	KND_Database.cur_shot = shot_list[index]
