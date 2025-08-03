################################################################################
# Project: Konado
# File: konado_project.gd
# Author: DSOE1024
# Created: 2025-08-03
# Last Modified: 2025-08-03
# Description:
#   Konado工程配置文件
################################################################################

@tool
extends Resource
class_name KonadoProject

# 默认项目配置
const DEFAULT_PRO_NAME = "Default Project"
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


## 从json字典加载
func from_json(json: Dictionary) -> void:
    project_name = json["project_name"]
    project_version = json["project_version"]
    project_url = json["project_url"]
    project_author = json["project_author"]
    project_description = json["project_description"]

## 从json字符串加载
func from_json_string(json_string: String) -> void:
    from_json(JSON.parse_string(json_string))


## 转化为json字典
func to_json() -> Dictionary:
    return {
        "project_name": project_name,
        "project_version": project_version,
        "project_url": project_url,
        "project_author": project_author,
        "project_description": project_description
    }

## 从json字符串加载
func to_json_string() -> String:
    return JSON.stringify(to_json())

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


