################################################################################
# Project: Konado
# File: character_list.gd
# Author: DSOE1024
# Created: 2025-06-27
# Last Modified: 2025-06-27
# Description:
#   角色列表类
################################################################################


extends Resource
class_name CharacterList

## 角色列表资源
@export var characters: Array[Character]

func get_json_data() -> String:
	var charas_dict = {}
	for chara in characters:
		charas_dict[chara.chara_id] = chara.get_json_data()
	return JSON.stringify(charas_dict)
