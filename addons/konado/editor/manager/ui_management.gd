@tool
extends Node
## ui主操作层，菜单栏，信息栏，切换不同面板
## 子节点分别控制不同面板的ui操作

enum Modiles{DATA,SHOT,SYSTEM}   ## 模块
@export var cur_modules := Modiles.DATA
@onready var modules_container: TabContainer = %modules_container
@onready var modules_bar: TabBar = %modules_bar

func _ready() -> void:
	pass
	#KND_Database.cur_shot_change.connect(edit_shot)
 
## TODO 切换到镜头编辑器
## BUG 切换后，标签显示还是原来的

func edit_shot():
	modules_container.current_tab = 1
	modules_bar.current_tab = 1

func _on_modules_bar_tab_clicked(tab: int) -> void:
	modules_container.current_tab = tab
	cur_modules = tab
	print(cur_modules)

## 置顶
func _on_top_button_toggled(toggled_on: bool) -> void:
	var window = get_window()
	# 设置窗口置顶
	print("置顶窗口")
	window.transient = false  # 先取消临时窗口属性
	window.always_on_top = toggled_on
