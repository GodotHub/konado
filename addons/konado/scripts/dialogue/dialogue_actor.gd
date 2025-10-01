extends Resource
class_name DialogueActor

# 创建和显示的角色ID
@export var character_name: String
# 角色图片ID
@export var character_state: String
# 创建角色的位置
@export var actor_position: Vector2
# 角色图片缩放
@export var actor_scale: float
## 演员立绘水平镜像翻转
@export var actor_mirror: bool

# 序列化为字典
func serialize_to_dict() -> Dictionary:
	return {
		"character_name": character_name,
		"character_state": character_state,
		"actor_position": {"x": actor_position.x, "y": actor_position.y},
		"actor_scale": actor_scale,
		"actor_mirror": actor_mirror
	}

# 从字典反序列化
func deserialize_from_dict(dict: Dictionary) -> bool:
	if "character_name" in dict:
		character_name = dict["character_name"]
	if "character_state" in dict:
		character_state = dict["character_state"]
	if "actor_position" in dict:
		var pos_dict = dict["actor_position"]
		if pos_dict is Dictionary and "x" in pos_dict and "y" in pos_dict:
			actor_position = Vector2(pos_dict["x"], pos_dict["y"])
	if "actor_scale" in dict:
		actor_scale = dict["actor_scale"]
	if "actor_mirror" in dict:
		actor_mirror = dict["actor_mirror"]
	return true