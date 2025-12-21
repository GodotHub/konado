extends Control
class_name ActionBar

signal continue_pressed      # 继续按钮点击信号
signal replay_pressed        # 重新播放按钮点击信号
signal save_pressed(visible: bool)          # 存档按钮点击信号
signal load_pressed(visible: bool)          # 读档按钮点击信号
signal record_pressed        # 记录按钮点击信号
signal exit_pressed          # 退出按钮点击信号
signal autoplay_pressed      # 自动按钮点击信号
signal review_pressed        # 回顾按钮点击信号

## 功能栏

@export_group("Action Buttons")
@export var continue_btn: Button
@export var replay_btn: Button
@export var save_btn: Button
@export var load_btn: Button
@export var record_btn: Button
@export var exit_btn: Button
@export var autoplay_btn: Button
@export var review_btn: Button

@export_group("Actions")
@export var save_load_ui: SaveLoadUI

func _ready() -> void:
	if continue_btn:
		continue_btn.pressed.connect(_on_continue_btn_pressed)
	if replay_btn:
		replay_btn.pressed.connect(_on_replay_btn_pressed)
	if save_btn:
		save_btn.toggled.connect(_on_save_btn_pressed)
	if load_btn:
		load_btn.toggled.connect(_on_load_btn_pressed)
	if record_btn:
		record_btn.pressed.connect(_on_record_btn_pressed)
	if exit_btn:
		exit_btn.pressed.connect(_on_exit_btn_pressed)
	if autoplay_btn:
		autoplay_btn.pressed.connect(_on_autoplay_btn_pressed)
	if review_btn:
		review_btn.pressed.connect(_on_review_btn_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_continue_btn_pressed() -> void:
	continue_pressed.emit()

func _on_replay_btn_pressed() -> void:
	replay_pressed.emit()

func _on_save_btn_pressed(toggled_on: bool) -> void:
	save_pressed.emit(toggled_on)
	save_load_ui.visible = toggled_on

func _on_load_btn_pressed(toggled_on: bool) -> void:
	load_pressed.emit(toggled_on)
	

func _on_record_btn_pressed() -> void:
	record_pressed.emit()

func _on_exit_btn_pressed() -> void:
	exit_pressed.emit()

func _on_autoplay_btn_pressed() -> void:
	autoplay_pressed.emit()

func _on_review_btn_pressed() -> void:
	review_pressed.emit()
