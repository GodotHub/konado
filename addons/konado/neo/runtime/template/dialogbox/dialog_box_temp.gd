@tool
extends Control
class_name KND_DialogueBox
## 对话框模板
## 可以自定义设置画面显示内容、位置、尺寸

## 点击对话框
signal on_dialogue_click 
signal on_button_pressed
signal on_character_name_click

## 打字完成
signal typing_completed

## 角色对象
@export_group("名字")
@export var character_name : String = "" :
	set(value):
		character_name = value
		update_dialogue()
			
@export var name_size :int=32              ## 名字字体大小
@export var name_bg :Texture2D              ## 名字标签背景
@export var name_color :Color = Color.BLACK ## 名字颜色
## 对话内容
## 进度 

@export_group("对话文本设置")
@export var dialogue_text : String= "":
	set(value):
		dialogue_text = value
		update_dialogue_content()

## 打字间隔
@export var typing_interval: float = 0.05:
	set(value):
		typing_interval = value
		update_dialogue_content()


@export_group("对话框设置")
@export var dialogue_margins :int = 100     ## 对话框到底部距离
@export var dialogue_bg :Texture2D          ## 对话框背景
@export var dialogue_color :Color = Color.BLACK ## 对话文字颜色

@export var dialogue_hight_max :int = 300  ## 对话文本框最大高度

@export_group("按钮")
@export var button_show :bool =false
@export var button_text:String =""
@export var button_texture :Texture2D

#@export_group("进度条")
#@export var progress_value : float = 0
#@export var progress_show :bool =false
#@export var progress_under_texture :Texture2D
#@export var progress_texture :Texture2D

## 加载节点
@onready var character_name_label: Label = %character_name_label
@onready var dialogue_label: RichTextLabel = %dialogue_label
@onready var progress_bar: TextureProgressBar = %ProgressBar
@onready var button: Button = %Button
@onready var dialogue_box_bg: NinePatchRect = %dialogue_box_bg

var typing_tween: Tween = null

## 更新对话框
func update_dialogue():
	# 必须加这个否则获取不到节点
	if not is_inside_tree():
		return
	update_character_name()
	update_dialogue_content()
	# 角色名字
	#character_name_label.text = character_name
	#character_name_label.label_settings.font_size = name_size
	#character_name_label.label_settings.font_color = name_color
	
	# 设置对话框
	#dialogue_label.text = dialogue_text
	#await dialogue_label.finished
	#await get_tree().process_frame
	#var text_hight:int = dialogue_label.get_content_height()
	#dialogue_label.size.y = min(text_hight,300)
	#dialogue_label.position.y = size.y - dialogue_label.size.y - dialogue_margins
	#
	#dialogue_box_bg.position.y = dialogue_label.position.y-150
	#dialogue_box_bg.size.y = dialogue_label.size.y + 200
	
func update_character_name() -> void:
	# 必须加这个否则获取不到节点
	if not is_inside_tree():
		return
	character_name_label.text = character_name
	character_name_label.label_settings.font_size = name_size
	character_name_label.label_settings.font_color = name_color
	
func update_dialogue_content() -> void:
	# 必须加这个否则获取不到节点
	if not is_inside_tree():
		return
	dialogue_label.visible_ratio = 0
	dialogue_label.text = dialogue_text
	# 需要删掉这一行，要不没法执行
	#await dialogue_label.finished
	await get_tree().process_frame
	var text_hight:int = dialogue_label.get_content_height()
	dialogue_label.size.y = min(text_hight,300)
	dialogue_label.position.y = size.y - dialogue_label.size.y - dialogue_margins
	
	dialogue_box_bg.position.y = dialogue_label.position.y - 150
	dialogue_box_bg.size.y = dialogue_label.size.y + 200
	
	if typing_tween != null:
		if typing_tween.is_running():
			typing_tween.kill()
	typing_tween = get_tree().create_tween()
	typing_tween.finished.connect(typing_completed.emit)
	typing_tween.tween_property(dialogue_label, "visible_ratio", 1.0, dialogue_text.split().size() * typing_interval).set_trans(Tween.TRANS_LINEAR)



func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		on_dialogue_click.emit()

func _on_button_pressed() -> void:
	on_button_pressed.emit()


func _on_character_name_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		on_character_name_click.emit()
