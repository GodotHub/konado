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

@onready var _review_UI := $"../DialogReview"

func _ready() -> void:
	# 如果在编辑器模式下
	
	_name_lable.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	_name_lable.add_theme_stylebox_override("background", StyleBoxEmpty.new())
	_content_lable.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	_content_lable.add_theme_stylebox_override("background", StyleBoxEmpty.new())


## 初始化对话框
func init_dialog_box() -> void:
	_name_lable.text = ""
	_content_lable.text = ""
	distroy_options()

		

## 修改对话框背景的方法
func change_dialog_box(tex: Texture):
	if tex:
		_dialog_box_bg.texture = tex
	else:
		print_rich("[color=red]对话框背景为空[/color]")
		return
		

## 显示对话的方法，使用Tween实现打字机
func set_content(content: String, speed: float) -> void:
	# 全字淡入效果，速度应该0.15-0.2之间，目前过快效果不好看
	_content = content
	_speed = speed
	_current = 0
	
	# 准备初始状态
	_content_lable.visible_characters = -1
	_content_lable.text = _content
	_start_character_tween()

# 私有变量
var _content: String = ""
var _speed: float = 0.1
var _current: int = 0
var _tween: Tween

# 开始字符动画
func _start_character_tween() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	for i in range(_content.length()):
		var char_index = i  # 需要本地变量避免闭包问题
		_tween.tween_callback(_update_character.bind(char_index))
		_tween.tween_interval(_speed)
	
	_tween.tween_callback(_on_typing_complete)

# 更新单个字符
func _update_character(index: int) -> void:
	_current = index + 1
	
	# 构建渐变文本
	var visible_text = _content.substr(0, _current)
	var next_char = _content[_current] if _current < _content.length() else ""
	
	# 添加渐变效果
	visible_text += "[color=#ffffff00]%s[/color]" % next_char
	_content_lable.text = visible_text
	
	# 创建字符渐变效果
	if next_char != "":
		var char_tween = create_tween()
		char_tween.tween_method(
			_set_char_alpha.bind(_current), 
			0.0, 
			1.0, 
			_speed
		)

# 设置字符透明度
func _set_char_alpha(alpha: float, char_index: int) -> void:
	if char_index >= _content.length(): 
		return
	
	var visible_text = _content.substr(0, char_index)
	visible_text += "[color=#ffffff%02X]%s[/color]" % [alpha * 255, _content[char_index]]
	
	# 添加未显示的字符
	if char_index < _content.length() - 1:
		visible_text += "[color=#ffffff00]%s[/color]" % _content.substr(char_index + 1)
	
	_content_lable.text = visible_text

# 打字完成回调
func _on_typing_complete() -> void:
	_content_lable.text = _content  # 确保完整显示
	finish_typing.emit()
	_content = ""

## 显示角色姓名的方法
func set_character_name(name: String) -> void:
	_name_lable.text = str(name)


func distroy_options() -> void:
	# 隐藏选项容器
	_choice_container.hide()
	# 删除原有选项
	if _choice_container.get_child_count() != 0:
		for child in _choice_container.get_children():
			child.queue_free()

## 显示对话选项的方法
func display_options(choices: Array[DialogueChoice], choices_tex: Texture = null, choices_font_size: int = 22) -> void:
	# # 隐藏选项容器
	# _choice_container.hide()
	# # 删除原有选项
	# if _choice_container.get_child_count() != 0:
	# 	for child in _choice_container.get_children():
	# 		child.queue_free()

	distroy_options()
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
				choiceButton.set_disabled(true)
				)
		# 添加到选项容器
		_choice_container.add_child(choiceButton)
		print_rich("[color=cyan]生成选项按钮: [/color]"+str(choiceButton))
	# 显示选项容器
	_choice_container.show()
	
	#为对话回顾提供的数据
	var curline : int = _dialog_manager.curline
	var options:Array=choices
	_review_UI._option_set(curline,choices)
