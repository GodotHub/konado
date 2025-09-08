extends Control
## 初始界面
@onready var popup_mask: ColorRect = %popup_mask

var save_path:=""
var dialog :FileDialog
# 新建工程按钮按下时的处理

func _on_new_project_pressed() -> void:
	dialog = FileDialog.new()
	dialog_setting(dialog)
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	dialog.title = "新建工程"
	add_child(dialog)  # 将对话框添加为子节点
	
	dialog.dir_selected.connect(_on_dir_selected)
	dialog.popup_centered()  # 居中显示

	print("新建工程")

# 打开工程按钮按下时的处理
func _on_open_project_pressed() -> void:
	dialog = FileDialog.new()
	dialog_setting(dialog)
	
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.filters = ["*.ks ; 工程文件"]
	dialog.title = "打开工程"
	add_child(dialog)  # 将对话框添加为子节点
	dialog.file_selected.connect(_on_file_selected)
	dialog.popup_centered()  # 居中显示

func dialog_setting(dialog):
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	# 使用原生系统对话框
	dialog.use_native_dialog = true
	dialog.size = Vector2(1200, 800)
	# 连接信号
	
	dialog.close_requested.connect(_close_requested)
	dialog.canceled.connect(_close_requested)  # 取消时释放
	popup_mask.show()

# 当文件选择后
func _on_file_selected(path: String):
	print("选择的文件路径: ", path)
	save_path = path.get_base_dir()  # 获取所在目录
	_close_requested()
	popup_mask.hide()

# 当目录选择后（用于新建工程）
func _on_dir_selected(dir: String):
	save_path = dir 
	print("选择的目录路径: ", dir)
	_close_requested()
	popup_mask.hide()
	
# 关闭或取消对话框时的处理
func _close_requested():
	print("关闭弹窗")
	if dialog:
		dialog.queue_free()  # 释放对话框
	popup_mask.hide()
	
func konado_creat():
	KonadoProjectBuilder.new()
