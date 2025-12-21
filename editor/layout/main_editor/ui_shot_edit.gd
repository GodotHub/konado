@tool
extends Node
## 画布交互组件
## 画布层操作

## ui组件
@onready var canvas: SubViewportContainer = %Canvas          ## 游戏运行时画面
@onready var canvas_container: Control    = %CanvasContainer ## 画布容器
@onready var zoom_button : OptionButton   = %zoom_button     ## 控制并显示画布缩放的按钮

## ui数据
@export var canvas_size := Vector2i(1920,1080)               ## 画布分辨率
@export var zoom            := 0.5:                          ## 画布缩放 
	set(value):
		if value != zoom :
			zoom =  value
			if canvas:
				canvas.scale = Vector2(zoom,zoom)
			if zoom_button:
				zoom_button.text = str(int(value*100)) + "%"
@export var position_offset := Vector2.ZERO:                 ## 画布滚动值 

	set(value):
		if value != position_offset :
			position_offset =  value
			if canvas:
				canvas.position = position_offset

var mos_pos =Vector2.ZERO
var current_pos = Vector2.ZERO
var drag:=false
func _ready() -> void:
	zoom = 0.5
	
## 画布交互
func _on_canvas_gui_input(event: InputEvent) -> void:         ## 画布交互
	if event is InputEventMouseButton:
		if event.is_pressed():
			drag = true
			mos_pos = canvas.get_global_mouse_position()
			current_pos = position_offset
		else:
			drag = false
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom +=0.02
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -=0.02
			
	if event is InputEventMouseMotion:
		if drag:
			position_offset = canvas.get_global_mouse_position() - mos_pos +current_pos

## 画布缩放按钮
func _on_zoom_button_item_selected(index: int) -> void:
	match  index:
		0:
			zoom=0.2
		1:
			zoom=0.5
		2:
			zoom=0.8
		3:
			zoom=1.0
		4:
			zoom=canvas_container.size.x / canvas_size.x
			position_offset = Vector2.ZERO
			_on_center_button_pressed()

## 画布居中
func _on_center_button_pressed() -> void: 
	position_offset = canvas_container.size/2 -canvas.size/2*zoom

## 画布区尺寸更改时自动居中
func _on_panel_resized() -> void:
	_on_center_button_pressed()
