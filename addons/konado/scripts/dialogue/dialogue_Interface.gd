@tool
extends Node
class_name DialogueInterface
# 对话UI控制脚本
## 对话框背景
@onready var _dialog_box_bg: TextureRect = $"../DialogueInterface/DialogueBox/Background"
## 对话文本
@onready var _content_lable: RichTextLabel = $DialogueBox/MarginContainer/DialogContent/VBoxContainer/MarginContainer/ContentLable
## 人物姓名（待修改）
@onready var _name_lable: RichTextLabel = $DialogueBox/MarginContainer/DialogContent/VBoxContainer/Name
## 对话选项按钮容器
@onready var _choice_container: Container = $ChoicesBox/ChoicesContainer
@onready var _dialog_manager: DialogueManager = $"../.."
var writertween: Tween
## 完成打字的信号
signal finish_typing
## 完成创建选项的信号
signal finish_display_options

func _ready() -> void:
	# 如果在编辑器模式下
	
	_name_lable.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	_name_lable.add_theme_stylebox_override("background", StyleBoxEmpty.new())
	_content_lable.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	_content_lable.add_theme_stylebox_override("background", StyleBoxEmpty.new())
		

## 修改对话框背景的方法
func change_dialog_box(tex: Texture):
	if tex:
		_dialog_box_bg.texture = tex
	else:
		print_rich("[color=red]对话框背景为空[/color]")
		return
		

## 显示对话的方法，使用Tween实现打字机
func set_content(content: String, speed: float) -> void:
	_content = content
	_speed = speed
	_time = 0
	_current = 0
	_content_lable.visible_characters = -1

var _content:String = ""
var _speed: float = 0.1
var _time:float = 0
var _current:int = 0

func _process(_delta: float) -> void:
	if _current < _content.length():
		var text:String = _content.substr(0, _current) # 内容截取
		_time += _delta
		
		if _time > _speed:
			text += _content[_current]
			_time = 0
			_current += 1
		else:
			# 设置半透明字体
			var alpha:float = _time / _speed
			text += "[color=#ffffff%02X]%s[/color]" % [alpha * 255, _content[_current]]
		# 文本覆盖
		_content_lable.text = text
	else:
		#归为
		finish_typing.emit()
		_content = ""

## 显示角色姓名的方法
func set_character_name(name: String) -> void:
	_name_lable.text = str(name)


## 显示对话选项的方法
func display_options(choices: Array[DialogueChoice], choices_tex: Texture = null, choices_font_size: int = 22) -> void:
	# 隐藏选项容器
	_choice_container.hide()
	# 删除原有选项
	if _choice_container.get_child_count() != 0:
		for child in _choice_container.get_children():
			child.queue_free()
	# 生成新选项
	for choice in choices:
		var choiceButton := Button.new()
		choiceButton.custom_minimum_size.y = 75
		# 选项文字大小
		#choiceButton.font_size = int(22)
		# 选项文本内容
		choiceButton.set_text(choice.choice_text)
		# 选项icon主题，图标居中
		choiceButton.set_button_icon(choices_tex)
		choiceButton.set_icon_alignment(1)
		choiceButton.remove_theme_font_size_override("normal")
		choiceButton.add_theme_font_size_override("font_size", int(choices_font_size))
		choiceButton.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		# 选项触发
		choiceButton.button_up.connect(
			func():
				await get_tree().create_timer(0.001).timeout
				print_rich("[color=green]选项被触发: [/color]"+str(choice))
				_dialog_manager.on_option_triggered(choice)
				choiceButton.set_disabled(true))
		# 添加到选项容器
		_choice_container.add_child(choiceButton)
		print_rich("[color=cyan]生成选项按钮: [/color]"+str(choiceButton))
	# 显示选项容器
	_choice_container.show()
