@tool
extends Window
class_name KonadoEditorWindow

## 编辑主场景路径
const konado_editor = preload("uid://bommt7l6wmdsa")

func _init() -> void:
	# 禁用默认主题
	theme = load("uid://xb40j2mc624h")
	title = "Konado Editor"
	## TODO 
	#var language = "automatic"
	#if language == "automatic":
		#var preferred_language = OS.get_locale_language()
		#TranslationServer.set_locale(preferred_language)
	#else:
		#TranslationServer.set_locale("en")
	
	size = DisplayServer.window_get_size() * 0.7
	initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	
	close_requested.connect(func(): 
		self.queue_free())

	min_size = size

	var editor = konado_editor.instantiate() as Control
	self.add_child(editor)
	KND_Database.load_database()
	pass
