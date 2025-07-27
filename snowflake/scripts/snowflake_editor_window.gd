extends Window
class_name KonadoEditorWindow 

const konado_editor = preload("res://addons/konado/snowflake/SnowFlake.tscn")

    
func _init() -> void:
	# 禁用默认主题
	theme = null
	title = "Snowflake Editor (雪花编辑器)"
	size = Vector2(1280, 720)
	initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN

	close_requested.connect(func(): self.hide())
	min_size = size
	var editor = konado_editor.instantiate() as SnowflakeEditor
	add_child(editor)
	pass
