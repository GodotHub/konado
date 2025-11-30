@tool
@abstract
extends Window
class_name KndDataEditWindow
## 数据编辑弹窗基类,定义了一些基础方法和信号

var data :int=-1:  ## 数据id
	set(value):
		if value != data:
			data = value
			load_data()

func _ready() -> void: 
	# window 设置
	visible = false
	#visibility_changed.connect(_on_visibility_changed)
	close_requested.connect(_on_close_requested)
	load_data()

@abstract
 ## 加载数据到ui
func load_data() -> void ;

@abstract
## 保存数据 
func save_data() -> void;

### 更改弹窗尺寸
#func _on_visibility_changed() -> void:
	#size = get_parent().size*0.6

## 弹窗关闭 
func _on_close_requested() -> void:
	save_data()
	#KND_Database.update_data_tree.emit()
	hide()
