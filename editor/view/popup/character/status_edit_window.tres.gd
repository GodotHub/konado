@tool
extends Window

## 角色立绘
@onready var status_texture: TextureRect = %status_texture
## 角色头像
@onready var portrait_picture: TextureRect = %portrait_picture
## 角色头像背景
@onready var portrait_preview_bg: Panel = %portrait_preview_bg

@onready var portrait_rect: ResizeControl  = %portrait_rect
@onready var full_body_pos: PanelContainer = %full_body_pos
@onready var half_body_pos: PanelContainer = %half_body_pos



## 全身立绘原点
func _on_full_body_toggled(toggled_on: bool) -> void:
	full_body_pos.visible = toggled_on
	set_picture_alpha(toggled_on)
	
## 设置半身按钮
func _on_half_body_toggled(toggled_on: bool) -> void:
	half_body_pos.visible = toggled_on
	set_picture_alpha(toggled_on)

## 设置头像框按钮
func _on_portrait_toggled(toggled_on: bool) -> void:
	portrait_rect.visible = toggled_on
	set_picture_alpha(toggled_on)

## 设置头像框
func _on_portrait_rect_set_portrait_rect(rect: Rect2) -> void:
	if portrait_picture.texture == null:
		portrait_picture.texture = status_texture.texture
	if portrait_picture.texture == status_texture.texture:
		portrait_picture.position = - portrait_rect.control_rect.position
		portrait_picture.size = portrait_rect.control_rect.size
		print(portrait_picture.size)

func set_picture_alpha(toggled_on):
	if toggled_on:
		status_texture.self_modulate.a = 0.6
	else:
		status_texture.self_modulate.a = 1

func _on_character_close_requested() -> void:
	self.hide()

## 调色
func _on_color_picker_button_color_changed(color: Color) -> void:
	portrait_preview_bg.self_modulate = color


func _on_close_requested() -> void:
	self.hide()
