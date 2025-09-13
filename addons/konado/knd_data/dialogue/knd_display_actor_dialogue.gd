@tool
extends KND_Dialogue
class_name KND_DisplayActor_Dialogue

# 创建和显示的角色ID
@export var character_name: String:
	set(value):
		if character_name != value:
			character_name = value
			emit_changed()
			gen_source_data()


# 角色图片ID
@export var character_state: String:
	set(value):
		if character_state != value:
			character_state = value
			emit_changed()
			gen_source_data()

# 创建角色的位置
@export var actor_position: Vector2:
	set(value):
		if actor_position != value:
			actor_position = value
			emit_changed()
			gen_source_data()

# 角色图片缩放
@export var actor_scale: float:
	set(value):
		if actor_scale != value:
			actor_scale = value
			emit_changed()
			gen_source_data()
	
## 演员立绘水平镜像翻转
@export var actor_mirror: bool:
	set(value):
		if actor_mirror != value:
			actor_mirror = value
			emit_changed()
			gen_source_data()
