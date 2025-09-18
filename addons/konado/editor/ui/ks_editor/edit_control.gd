@tool
extends Node
## 镜头编辑器视图层交互操作

@onready var staff_window: Window = %staff_window


## 添加演员按钮
func _on_add_act_pressed() -> void:
	staff_window.show()
