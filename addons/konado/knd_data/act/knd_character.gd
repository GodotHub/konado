@tool
extends KND_Data
class_name KND_Character

## 数据图标
const icon: Texture2D = preload("uid://q2w6piu3t1md")

## 角色姓名
@export var name: String = "新角色"

## 出演过的演员-镜头表
## 键：演员名字符串
## 值：该演员出演的镜头ID数组
@export var actor_id_map: Dictionary[String, Array] = {}

## 角色状态配置
## 键：状态名称字符串（如："normal", "angry", "happy"等）
## 值：对应状态下的资源路径或标识符字符串
@export var character_status: Dictionary[String, String] = {}

## 根据指定状态获取角色纹理，
## 需要根据 [member KND_Character.character_status] 字典中配置的路径加载对应纹理资源 [br]
## 示例：[br]
## [codeblock lang=gdscript]
##   var texture = character_data.get_character_texture("happy")
##   if texture:
##       $Sprite2D.texture = texture
## [/codeblock]
##
## 需要根据 [member KND_Character.character_status] 字典中配置的路径加载对应纹理资源
func get_character_texture(status: String) -> Texture2D:
	# TODO: 实现加载演员纹理的函数
	return null
