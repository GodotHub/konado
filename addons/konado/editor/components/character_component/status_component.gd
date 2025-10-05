@tool
extends Control
## 角色状态组件
signal preview_status(node)

@onready var status_edit: LineEdit = $statusEdit
@onready var illustration_import: Button = $illustration_import
@onready var portrait: Button = $portrait

@export var preview :=false
@export var illustration_path:=""
@export var portrait_path:=""

## 状态名
func _on_status_edit_editing_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
	
## 选择立绘
func _on_illustration_import_pressed() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.filters = ["*.png ; PNG图片", "*.jpg ; JPG图片", "*.jpeg ; JPEG图片", "*.webp ; WebP图片", "*.svg ; SVG图片"]
	file_dialog.use_native_dialog = true 

	# 连接文件选择的信号
	file_dialog.file_selected.connect(_on_illustration_file_selected)
	# 将对话框添加到场景树并显示
	add_child(file_dialog)
	file_dialog.popup_centered_ratio(0.5)

func _on_illustration_file_selected(path: String) -> void:
	# 存储图片路径
	illustration_path = path
	
	# 更新按钮文字为文件名（不带路径和扩展名）
	var file_name = path.get_file().get_basename()
	illustration_import.text = file_name

## 选择头像
func _on_portrait_pressed() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.filters = ["*.png ; PNG图片", "*.jpg ; JPG图片", "*.jpeg ; JPEG图片", "*.webp ; WebP图片", "*.svg ; SVG图片"]
	file_dialog.use_native_dialog = true 

	# 连接文件选择的信号
	file_dialog.file_selected.connect(_on_portrait_file_selected)
	# 将对话框添加到场景树并显示
	add_child(file_dialog)
	file_dialog.popup_centered_ratio(0.5)
	
func _on_portrait_file_selected(path: String) -> void:
	# 存储图片路径
	portrait_path = path
	
	# 更新按钮文字为文件名（不带路径和扩展名）
	var file_name = path.get_file().get_basename()
	portrait.text = file_name

## 预览
func _on_button_toggled(toggled_on: bool) -> void:
	preview = toggled_on
	if toggled_on:
		preview_status.emit(self)

#func _on_delect_pressed() -> void:
	#KND_Database.rem
