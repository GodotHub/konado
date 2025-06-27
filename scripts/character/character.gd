################################################################################
# Project: Konado
# File: character.gd
# Author: DSOE1024
# Created: 2025-06-21
# Last Modified: 2025-06-21
# Description:
#   角色类
################################################################################

@tool
extends Resource
class_name Character

## 角色ID
var chara_id: String
## 角色姓名
var chara_name: String

## 角色标记颜色
var tag_color: Color

## 角色状态图集
var chara_status: Array[CharacterStatus]


func _get_property_list():
	var properties = []
	
	properties.append({
		"name": "角色ID",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"hint": PROPERTY_HINT_NONE
	})
	
	properties.append({
		"name": "角色姓名",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		"hint": PROPERTY_HINT_NONE
	})
	
	properties.append({
		"name": "角色标记颜色",
		"type": TYPE_COLOR,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	# 对于资源数组（例如`Array[CharacterStatus]`），`hint_string`的格式为："%s/%s:%s"
	# ???

	properties.append({
		"name": "角色状态",
		"type": TYPE_ARRAY,
		"hint": PROPERTY_HINT_ARRAY_TYPE,
		"hint_string": "%s/%s:%s" % [
			TYPE_OBJECT, 
			PROPERTY_HINT_RESOURCE_TYPE, 
			"CharacterStatus"
		],
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	return properties

func _get(property):
	match property:
		"角色ID": 
			return chara_id
		"角色姓名":
			return chara_name
		"角色标记颜色":
			return tag_color
		"角色状态":
			return chara_status

func _set(property, value):
	match property:
		"角色ID": 
			chara_id = value
			return true
		"角色姓名":
			chara_name = value
			return true
		"角色标记颜色":
			tag_color = value
			return true
		"角色状态":
			chara_status = value
			return true
	return false
