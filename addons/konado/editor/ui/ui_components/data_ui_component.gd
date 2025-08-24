@tool
extends Control
@onready var selected_box: Panel = %selected_box
@onready var name_label: Label = %name_Label

@export var selected:=false :
	set(value):
		if selected!= value:
			selected = value
			if selected_box != null:
				if value :
					selected_box.show()
				else:
					selected_box.hide()

@export var shot_name :String ="镜头":
	set(value):
		if shot_name != value:
			shot_name = value
			if name_label:
				name_label.text = value 

@export var timestamp:= "2025/1/1/12:00" ## 时间戳

@export var tip :="": ## 备注信息
	set(value):
		tip = value 
		tooltip_text = timestamp +"\n" + tip

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		selected = !selected
		
		
		
