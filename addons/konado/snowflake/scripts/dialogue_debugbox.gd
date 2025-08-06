################################################################################
# Project: Konado
# File: dialogue_debugbox.gd
# Author: DSOE1024
# Created: 2027-07-25
# Last Modified: 2027-07-25
# Description:
#   对话调试框
################################################################################

@tool

extends Node
class_name DialogueDebugBox

signal on_play_btn_pressed(index: int)
signal on_edit_btn_pressed(line: int)

var index: int
var line: int

@export var des_label: Label

@export var source_label: Label

@export var edit_button: Button

@export var play_button: Button

@export var is_sub_box: bool = false

@export var margin: MarginContainer

func _ready() -> void:
	edit_button.pressed.connect(func():
		on_edit_btn_pressed.emit(line)
		)
	play_button.pressed.connect(func():
		on_play_btn_pressed.emit(index)
		)
	pass

func init_box(index: int, line: int, des: String, source: String) -> void:
	self.index = index
	self.line = line
	self.des_label.text = des
	self.source_label.text = source

func set_sub_box() -> void:
	margin.add_theme_constant_override("margin_left", 20)
