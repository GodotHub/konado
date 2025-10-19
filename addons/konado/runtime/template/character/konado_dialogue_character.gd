@tool
extends Control
class_name KonadoDialogueCharacter

## 对话角色类，用于在对话中显示角色

## 是否使用补间动画
@export var use_tween: bool = true
## 动画时间，不得小于0
@export var animation_time: float = 0.2:
	set(value):
		if animation_time != value:
			animation_time = max(value, 0)

@export var texture_rect: TextureRect


## 屏幕分块数，不得小于2，将屏幕分为从左到右递增的块，每个块大小相同
@export var division: int = 3:
	set(value):
		if division != value:
			division = clamp(value,2,15)
			_on_resized()

## 当前角色位置所在区块索引，从0开始，从左到右递增
@export var character_position: int = 2:
	set(value):
		if character_position!= value:
			character_position = clamp(value, 0, division)
			_on_resized()

func _ready() -> void:
	if not self.resized.is_connected(_on_resized):
		self.resized.connect(_on_resized)

func _on_resized() -> void:
	if texture_rect:
		var target_x = -size.x / division * (division - character_position ) + texture_rect.size.x / 2
		if use_tween:
			var tween: Tween = texture_rect.create_tween()
			tween.tween_property(texture_rect, "position", Vector2(target_x, texture_rect.position.y), animation_time)
			tween.play()
		else:
			texture_rect.position.x = target_x

func set_character_texture(texture: Texture) -> void:
	texture_rect.texture = texture
	_on_resized()

func set_texture_scale(scale: float) -> void:
	texture_rect.scale = Vector2(scale, scale)
	_on_resized()
