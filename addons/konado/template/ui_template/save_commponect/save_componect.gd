@tool
extends Button
class_name SaveComponent

@onready var name_label      : Label = %name_label
@onready var save_time_label : Label = %save_time_label
@onready var game_time_label : Label = %game_time_label
@onready var autosave_sign   : Label = $autosave_sign
## 存档ID
@export var save_id: int = -1;

@export var save_name := "存档":  ## 存档名称
	set(value):
		if save_name  != value:
			save_name = value
			if name_label:
				name_label.text=value

@export var save_time := "2025/8/25/12:02":
	set(value):
		if save_time  != value:
			save_time = value
			if save_time_label:
				save_time_label.text=value

@export var game_time := " 3h 2min":
	set(value):
		if game_time  != value:
			game_time = value
			if game_time_label:
				game_time_label.text=value

@export var auto_save := false:
	set(value):
		auto_save = value
		if autosave_sign:
			autosave_sign.visible = value
			
func _ready() -> void:
	name_label.text = save_name
	save_time_label.text  = save_time
	game_time_label.text = game_time  # 补充原有遗漏的游戏时长标签初始化
	autosave_sign.visible = auto_save

# 新增：初始化空存档位的方法
func init_empty_save_slot() -> void:
	# 1. 重置存档ID为默认值（-1标识空存档）
	save_id = -1
	
	# 2. 设置空存档默认名称（占位符）
	save_name = "空存档"  # 触发save_name的setter，自动更新name_label
	
	# 3. 设置存档时间占位符（无实际存档时间）
	save_time = "--/--/-- --:--"  # 触发save_time的setter，自动更新save_time_label
	
	# 4. 设置游戏时长占位符（无游戏时长记录）
	game_time = "0h 0min"  # 触发game_time的setter，自动更新game_time_label
	
	# 5. 隐藏自动存档标记（空存档无自动存档属性）
	auto_save = false  # 触发auto_save的setter，自动隐藏autosave_sign
	
