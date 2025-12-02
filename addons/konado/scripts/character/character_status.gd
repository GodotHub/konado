################################################################################
# Project: Konado
# File: character_status.gd
# Author: DSOE1024
# Created: 2025-06-22
# Last Modified: 2025-06-22
# Description:
#   角色状态类
################################################################################

@tool
extends Resource
class_name CharacterStatus

# 状态名称
var status_name: String
# 状态角色图片
var status_texture: Texture


func get_json_data() -> Dictionary:
	# 图片转Base64

	## 获取图片的PackedByteArray
	var packed_bytes = status_texture.get_image().get_data()
	var base_str = Marshalls.raw_to_base64(packed_bytes)

	return {
		"status_name": status_name,
		"status_texture": base_str
	}

func _get_property_list() -> Array:
	var properties = []
	
	# 添加状态名称属性
	properties.append({
		"name": "角色状态名称",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"hint": PROPERTY_HINT_NONE
	})
	
	# 添加状态图片属性
	properties.append({
		"name": "角色状态图片",
		"type": TYPE_OBJECT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "Texture"
	})
	
	return properties

func _get(property: StringName):
	match property:
		"角色状态名称": 
			return status_name
		"角色状态图片":
			return status_texture
	return null

func _set(property: StringName, value) -> bool:
	var mod: bool = false
	
	match property:
		"角色状态名称": 
			status_name = value
			mod = true
		"角色状态图片":
			status_texture = value
			mod = true
	if mod:
		notify_property_list_changed()
		emit_changed()

	return mod
