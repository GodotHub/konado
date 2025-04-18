extends Panel
class_name ArchiveDialog
# 点击确认发出的信号
signal click_confirm
# 点击取消发出的信号
signal click_cancel

## 确认按钮
@export var confirm_btn: Button
## 取消按钮
@export var cancel_btn: Button
## 存档对话文本
@export var dialog_label: Label


# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_btn.pressed.connect(_on_confirm_btn_press)
	cancel_btn.pressed.connect(_on_cancel_btn_press)
	confirm_btn.set_disabled(true)
	cancel_btn.set_disabled(true)

func show_dialog_box(index: String):
	dialog_label.text = index
	show()
	confirm_btn.set_disabled(false)
	cancel_btn.set_disabled(false)
	
func hide_dialog_box():
	dialog_label.text = "？？？"
	confirm_btn.set_disabled(true)
	cancel_btn.set_disabled(true)
	hide()

## 当确认按钮按下
func _on_confirm_btn_press():
	click_confirm.emit()
	hide_dialog_box()
	pass

## 当取消按钮按下
func _on_cancel_btn_press():
	click_cancel.emit()
	hide_dialog_box()
	pass
