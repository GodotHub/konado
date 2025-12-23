extends Control
class_name SaveLoadUI

## 存读档界面

@export var save_componect: PackedScene = preload("res://addons/konado/template/ui_template/save_commponect/save_componect.tscn")

@onready var root_container: BoxContainer = $Panel/ScrollContainer/MarginContainer/RootSlotContainer

@export var save_slot_count: int = 20

func _ready() -> void:
	_create_save_slot()


## 创建存档
func _create_save_slot() -> void:
	for i in save_slot_count:
			var save_slot: SaveComponent = save_componect.instantiate() as SaveComponent
			# 确保实例化成功
			if save_slot:
				root_container.add_child(save_slot)
				save_slot.save_id = i
				
				var format_save_id: String = str("%02d" % (i + 1))
				
				# 设置存档名称
				save_slot.save_name = "存档" + format_save_id
				save_slot.auto_save = false
				
				save_slot.init_empty_save_slot()
				

func _process(delta: float) -> void:
	pass
