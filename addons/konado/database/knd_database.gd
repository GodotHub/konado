## KND_Database数据库类，将在Konado插件启用时添加到自动加载
@tool
extends Node

## 信号定义
signal cur_shot_change
signal update_data_tree

## 项目资源表
@export var knd_data_file_dic: Dictionary[int, String] = {}

## 缓存数据库
var tmp_knd_data_dic: Dictionary[int, KND_Data] = {}

## 数据类型列表 {data_type:[id]}
var data_type_map: Dictionary = {}


## 数据类型映射
const KND_CLASS_DB: Dictionary[String, String] = {
	"KND_Data": "res://addons/konado/knd_data/knd_data.gd",
	"KND_Template": "res://addons/konado/knd_data/act/knd_template.gd",
	"KND_Character": "res://addons/konado/knd_data/act/knd_character.gd",
	"KND_Background": "res://addons/konado/knd_data/act/knd_background.gd",
	"KND_Soundeffect": "res://addons/konado/knd_data/audio/knd_soundeffect.gd",
	"KND_Bgm": "res://addons/konado/knd_data/audio/knd_bgm.gd",
	"KND_Voice": "res://addons/konado/knd_data/audio/knd_voice.gd",
	"KND_Shot": "res://addons/konado/knd_data/shot/knd_shot.gd"
}



## 当前镜头
var cur_shot: int:
	set(value):
		if value != cur_shot:
			cur_shot = value
			cur_shot_change.emit()

func rename(new_name: String) -> String:
	return new_name

			
func create_character() -> KND_Character:
	var character = KND_Character.new()
	# 保存到本地
	ResourceSaver.save(character, "res://knd_data/" + "character" + "/" + character.name + ".tres")
	return character

func create_background() -> KND_Background:
	return KND_Background.new()
