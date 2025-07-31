extends Button
class_name ArchiveBox

@export var archive_id: int = 0

@onready var chapter_text: Label = $MarginContainer/HBoxContainer/Label3
@onready var time_text: Label = $MarginContainer/HBoxContainer/Label2

# 当存档按钮被按下
signal archive_box_pressed(id: int, archive_box: ArchiveBox)

func _pressed():
	archive_box_pressed.emit(archive_id, self)

# 设置章节文本
func set_chapter_text(text: String):
	chapter_text.set_text(text)
	
# 设置时间文本
func set_time_text(text: String):
	time_text.set_text(text)
