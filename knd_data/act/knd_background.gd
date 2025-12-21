@tool
extends KND_Data
class_name KND_Background

const icon: Texture2D = preload("uid://1b3bn1nwu3x")
## 背景名称
@export var name: String = "新背景"

## 背景图片
@export var background_image_path: String


## 加载背景图片纹理
func get_background_texture() -> Texture2D:
	var texture: Texture2D = ResourceLoader.load(background_image_path)
	return texture
