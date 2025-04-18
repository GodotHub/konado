@tool
extends Resource
class_name PreloadDialogData

# 备注名称
@export var note_name: String
# 文件路径
@export_file("*.txt") var _dialog_data_file_path : String
