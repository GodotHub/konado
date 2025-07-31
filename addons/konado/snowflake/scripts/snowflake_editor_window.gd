extends Window
class_name KonadoEditorWindow 

const konado_editor = preload("res://addons/konado/snowflake/SnowFlake.tscn")

    
func _init() -> void:
	# 禁用默认主题
	theme = null
	title = "Snowflake Editor (雪花编辑器)"
	size = Vector2(1280, 720)
	initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN

	close_requested.connect(func(): 
		# 对话框
		var dialog = ConfirmationDialog.new()
		dialog.title = "关闭编辑器？"
		dialog.dialog_text = "如果选择退出，当前编辑的内容将不会保存。如果是关闭窗口，请选择隐藏。"
		dialog.ok_button_text = "隐藏窗口"
		dialog.cancel_button_text = "退出编辑器"
		dialog.confirmed.connect(func():
			# 隐藏窗口
			self.hide()
		)
		dialog.canceled.connect(func():
			# 退出
			self.queue_free()
		)
		add_child(dialog)
		# 显示对话框
		dialog.popup_centered()
		)

	min_size = size

	var editor = konado_editor.instantiate() as SnowflakeEditor
	add_child(editor)
	pass
