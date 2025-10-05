@tool
extends Button
## 存档标签组件，

@onready var name_label      : Label = %name_label
@onready var save_time_label : Label = %save_time_label
@onready var game_time_label : Label = %game_time_label
@onready var autosave_sign   : Label = $autosave_sign

@export var save_name := "存档":  ## 存档名称
	set(value):
		if save_name  != value:
			save_name = value
			if name_label:
				name_label.text=value

@export var save_time := "2025/8/25/12:02":
	set(value):
		if save_time  != value:
			save_time = value
			if save_time_label:
				save_time_label.text=value

@export var game_time := " 3h 2min":
	set(value):
		if game_time  != value:
			game_time = value
			if game_time_label:
				game_time_label.text=value

@export var auto_save := false:
	set(value):
		auto_save = value
		if autosave_sign:
			autosave_sign.visible = value
		
func _ready() -> void:
	name_label.text = save_name
	save_time_label.text  = save_time
	autosave_sign.visible = auto_save
