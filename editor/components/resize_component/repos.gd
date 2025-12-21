extends Control

var style_box :StyleBoxTexture

@export var picture:TextureRect
var picture_rect

var click_position 
var control_rect: = Rect2(position,size)

var drag:=false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index  ==1 and event.pressed:
			click_position = get_local_mouse_position() 
			drag = true
		else :
			drag = false
	if event is InputEventMouseMotion:
		if drag:
			var unit_distance =  get_local_mouse_position() - click_position
			position += unit_distance
			click_position = get_local_mouse_position()
