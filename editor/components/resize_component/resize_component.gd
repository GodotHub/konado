@tool
extends Control
class_name ResizeControl
## 调整大小的控件

signal set_portrait_rect(rect:Rect2)


## 被调整的节点

## 操控区域
enum Area {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	CENTER
	}
var cur_area = Area.TOP_LEFT
const RESIZE_PANEL_TEXTURE = preload("uid://by474f70pkvpq")

## 图片样式盒
var style_box :StyleBoxTexture

@export var picture:TextureRect
var picture_rect

var click_position 
var control_rect: = Rect2(position,size)

var drag:=false

func _ready() -> void:
	control_rect =get_rect() 
	picture.resized.connect(_on_control_resized)

func set_control_size():
	#if control_rect is Control:
		position = -Vector2(20,20)
		size = control_rect.size + Vector2(40,40)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index  ==1 and event.pressed:
			cur_area = _click_area(event.position)
			click_position = get_local_mouse_position() 
			drag = true
		else :
			drag = false
	if event is InputEventMouseMotion:
		_click_area(event.position)
		if drag:
			var unit_distance =  get_local_mouse_position() - click_position
			resize_area(unit_distance)
			click_position = get_local_mouse_position() 

## 重新设置控件尺寸
func _click_area(click_pos)->Area:
	var rect = get_rect() 
	# 定义角落区域的大小
	var corner_size = 20
	var rect_size = Vector2(corner_size, corner_size)
	
	# 检查四个角落区域
	if Rect2(Vector2.ZERO, rect_size ).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
		return Area.TOP_LEFT
	if Rect2(Vector2(rect.size.x - corner_size, 0), rect_size ).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_BDIAGSIZE
		return Area.TOP_RIGHT
	if Rect2(Vector2(0, rect.size.y - corner_size), rect_size ).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_BDIAGSIZE
		return Area.BOTTOM_LEFT
	if Rect2(Vector2(rect.size.x - corner_size, rect.size.y - corner_size), rect_size ).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
		return Area.BOTTOM_RIGHT
	
	# 检查四个边缘区域
	if Rect2(Vector2(corner_size, 0), Vector2(rect.size.x - 2 * corner_size, corner_size)).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_VSIZE
		return Area.TOP
	if Rect2(Vector2(corner_size, rect.size.y - corner_size), Vector2(rect.size.x - 2 * corner_size, corner_size)).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_VSIZE
		return Area.BOTTOM
	if Rect2(Vector2(0, corner_size), Vector2(corner_size, rect.size.y - 2 * corner_size)).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_HSIZE
		return Area.LEFT
	if Rect2(Vector2(rect.size.x - corner_size, corner_size), Vector2(corner_size, rect.size.y - 2 * corner_size)).abs().has_point(click_pos):
		mouse_default_cursor_shape = Control.CURSOR_HSIZE
		return Area.RIGHT	
	# 如果都不在边缘或角落，则在中心区域
	mouse_default_cursor_shape = Control.CURSOR_DRAG
	return Area.CENTER

## 根据点击区域进行移动缩放
func resize_area(unit_distance:Vector2):
	match cur_area:
		Area.TOP_LEFT:
			control_rect.position += unit_distance
			control_rect.size -= unit_distance
		Area.TOP_RIGHT:
			control_rect.position.y += unit_distance.y
			control_rect.size.x += unit_distance.x
			control_rect.size.y -= unit_distance.y
			
		Area.BOTTOM_LEFT:
			control_rect.position.x += unit_distance.x
			control_rect.size.x -= unit_distance.x
			control_rect.size.y += unit_distance.y
		Area.BOTTOM_RIGHT:
			control_rect.size += unit_distance
		Area.TOP:
			control_rect.position.y += unit_distance.y
			control_rect.size.y -= unit_distance.y
		Area.BOTTOM:
			control_rect.size.y += unit_distance.y
		Area.LEFT:
			control_rect.position.x += unit_distance.x
			control_rect.size.x -= unit_distance.x
		Area.RIGHT:
			control_rect.size.x += unit_distance.x
		Area.CENTER:
			control_rect.position += unit_distance
	
	position = control_rect.position
	size = control_rect.size
	picture_rect =picture.texture.get_size()
	set_portrait_rect.emit(control_rect)
	#var bl = (control_rect.position.x - picture_rect.position.x)/picture_rect.size.x

func _on_control_resized():
	control_rect= get_rect()
