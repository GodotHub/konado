@tool
extends Control

@onready var texture_rect: TextureRect = %TextureRect
@onready var control: Control = $Control

@export var division:= 3:
	set(value):
		if division != value:
			division = clamp(value,2,15)
			_on_resized()

@export var character_position := 2:
	set(value):
		if character_position!= value:
			character_position = clamp(value,0,division)
			_on_resized()

func _on_resized() -> void:
	if texture_rect:
		texture_rect.position.x = -size.x /division * (division - character_position )+ texture_rect.size.x/2
