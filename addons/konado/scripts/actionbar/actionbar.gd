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

# 存储所有需要被禁用的其他按钮（排除save_btn和load_btn）
var other_buttons: Array[Button] = []

func _ready() -> void:
	# 初始化其他按钮数组（排除保存和加载按钮）
	other_buttons = [
		continue_btn,
		replay_btn,
		record_btn,
		exit_btn,
		autoplay_btn,
		review_btn
	]
	
	# 原有信号连接逻辑
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
	# 调用通用方法，根据保存按钮的切换状态启用/禁用其他按钮
	toggle_other_buttons_state(toggled_on)
	# 确保加载按钮状态与保存按钮联动（可选，根据需求调整）
	if load_btn and toggled_on:
		load_btn.disabled = true  # 保存按钮激活时，加载按钮保持不可用
	elif load_btn and not toggled_on and not load_btn.button_pressed:
		load_btn.disabled = false  # 两者都未激活时，加载按钮恢复可用

func _on_load_btn_pressed(toggled_on: bool) -> void:
	load_pressed.emit(toggled_on)
	# 调用通用方法，根据加载按钮的切换状态启用/禁用其他按钮
	toggle_other_buttons_state(toggled_on)
	# 确保保存按钮状态与加载按钮联动（可选，根据需求调整）
	if save_btn and toggled_on:
		save_btn.disabled = true  # 加载按钮激活时，保存按钮保持可用
	elif save_btn and not toggled_on and not save_btn.button_pressed:
		save_btn.disabled = false  # 两者都未激活时，保存按钮恢复可用

func _on_record_btn_pressed() -> void:
	record_pressed.emit()

func _on_exit_btn_pressed() -> void:
	exit_pressed.emit()

func _on_autoplay_btn_pressed() -> void:
	autoplay_pressed.emit()

func _on_review_btn_pressed() -> void:
	review_pressed.emit()

# 通用方法：切换其他按钮的启用/禁用状态
func toggle_other_buttons_state(is_disable: bool) -> void:
	# 遍历所有其他按钮，逐一设置禁用状态
	for btn in other_buttons:
		# 仅对已赋值（非null）的按钮进行操作，避免空指针错误
		if btn:
			btn.disabled = is_disable
