################################################################################
# Project: Konado
# File: konado_project.gd
# Author: DSOE1024
# Created: 2025-08-03
# Last Modified: 2025-08-25
# Description:
#   Konado工程配置文件
################################################################################

@tool
extends Resource
class_name KonadoProject

# 默认项目配置
const DEFAULT_PRO_NAME = "Konado Project"
const DEFAULT_PRO_VER = "0.0.1"
const DEFAULT_PRO_URL = "https://gitcode.com/godothub/konado"
const DEFAULT_PRO_DESC = "This is a game project powered by Konado."

## 项目名称，应用于项目设置的"application/config/name"
@export var project_name: String = DEFAULT_PRO_NAME:
	set(v):
		project_name = v
		notify_property_list_changed()
		apply_to_project_settings()

# 项目版本，应用于项目设置的"application/config/version"
@export var project_version: String = DEFAULT_PRO_VER:
	set(v):
		project_version = v
		notify_property_list_changed()
		apply_to_project_settings()

# 项目地址，可以是游戏下载网页地址，也可以是git地址，没有实际用途
@export var project_url: String = DEFAULT_PRO_URL

# 项目作者
@export var project_author: String

# 项目描述，应用于项目设置的"application/config/description"
@export var project_description: String = DEFAULT_PRO_DESC:
	set(v):
		project_description = v
		notify_property_list_changed()
		apply_to_project_settings()

## BGM列表
@export var bgm_list: DialogBGMList

## 音效列表
@export var se_list: DialogSoundEffectList

## 配音列表
@export var voice_list: DialogVoiceList

## 角色列表
@export var character_list: CharacterList

## 背景列表
@export var background_list: BackgroundList

# 对话镜头
@export var dialogue_shots: Dictionary = {}

## 添加对话镜头，chapter为章节名，shot为镜头
func add_dialogue_shot(chapter: String, shot_path: String) -> void:
	if not dialogue_shots.has(chapter):
		dialogue_shots[chapter] = []

	if not FileAccess.file_exists(shot_path):
		printerr("对话镜头文件不存在: " + shot_path)
		return

	dialogue_shots[chapter].append(shot_path)
	print("添加对话镜头: " + chapter + " " + shot_path)

## 是否有对话镜头，chapter为章节名，index为镜头索引
func has_dialogue_shot(chapter: String, index: int) -> bool:
	if not dialogue_shots.has(chapter):
		printerr("章节没有找到: " + chapter)
		return false
	return index < dialogue_shots[chapter].size()

## 获取对话镜头，chapter为章节名，index为镜头索引
func get_dialogue_shot(chapter: String, index: int) -> String:
	if not dialogue_shots.has(chapter):
		printerr("章节没有找到: " + chapter)
		return ""
	return dialogue_shots[chapter][index]

## 删除对话镜头，chapter为章节名，index为镜头索引
func delete_dialogue_shot(chapter: String, index: int) -> void:
	if not dialogue_shots.has(chapter):
		printerr("章节没有找到: " + chapter)
		return
	var shot_path = dialogue_shots[chapter][index]
	dialogue_shots[chapter].remove(index)
	print("删除对话镜头: " + chapter + " " + shot_path)
	

## 生成默认项目
func gen_default_project() -> void:
	project_name = DEFAULT_PRO_NAME
	project_version = DEFAULT_PRO_VER
	project_url = DEFAULT_PRO_URL
	project_author = ""
	project_description = DEFAULT_PRO_DESC


## 应用到项目设置
func apply_to_project_settings() -> void:
	if Engine.is_editor_hint():
		print("编辑器模式应用项目设置")
		# 更改项目设置
		ProjectSettings.set("application/config/name", project_name)
		ProjectSettings.set("application/config/version", project_version)
		ProjectSettings.set("application/config/description", project_description)

	else:
		print("非编辑器模式无法应用项目设置")
