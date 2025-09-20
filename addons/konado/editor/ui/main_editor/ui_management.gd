@tool
extends Node
## ui主操作层，菜单栏，信息栏，切换不同面板
## 子节点分别控制不同面板的ui操作

enum Modiles{DATA,SHOT,SYSTEM}   ## 模块
@export var cur_modules := Modiles.DATA
@onready var modules_container: TabContainer = %modules_container

func _ready() -> void:
	KND_Database.cur_shot_change.connect(edit_shot)
 
## TODO 切换到镜头编辑器，刷新镜头编辑器
func edit_shot():
	modules_container.current_tab = 1

func _on_modules_bar_tab_clicked(tab: int) -> void:
	modules_container.current_tab = tab
	cur_modules = tab
	print(cur_modules)
