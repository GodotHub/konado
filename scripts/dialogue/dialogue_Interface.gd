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

## 修改对话框背景的方法
func change_dialog_box(tex: Texture):
	if tex:
		_dialog_box_bg.texture = tex
	else:
		print_rich("[color=red]对话框背景为空[/color]")
		return
		

## 显示对话的方法，使用Tween实现打字机
func set_content(content: String, speed: float) -> void:
	if writertween:
		writertween.stop()
		writertween.kill()
	writertween = get_tree().create_tween()
	# 打字机tween
	_content_lable.visible_ratio = 0
	_content_lable.text = str(content)
	writertween.tween_property(_content_lable, "visible_ratio", 1, speed * content.length())
	await writertween.finished
	finish_typing.emit()
	

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
		choiceButton.button_up.connect(_dialog_manager._on_option_triggered.bind(choice))
		# 添加到选项容器
		_choice_container.add_child(choiceButton)
		print_rich("[color=cyan]生成选项按钮: [/color]"+str(choiceButton))
	# 显示选项容器
	_choice_container.show()
