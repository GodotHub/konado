extends Control
@onready var selected_box: Panel = %selected_box

@export var tip :="": ## 备注信息
	set(value):
		tip = value 
		tooltip_text = tip
@export var selected:=false :
	set(value):
		selected = value
		if selected_box != null:
			if value :
				selected_box.show()
			else:
				selected_box.hide()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		selected = !selected
