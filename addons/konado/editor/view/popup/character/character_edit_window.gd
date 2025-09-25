@tool
extends DataEditWindow
## 角色编辑器

@onready var name_label: LineEdit = %name
@onready var birthday_label: LineEdit = %birthday
@onready var age_label: LineEdit = %age
@onready var tip_label: TextEdit = %tip

@onready var gender_label: OptionButton = %gender
@onready var race_label: OptionButton = %race
@onready var status_setting: Window = $status_setting


func load_data() -> void:
	print("sjda: " ,data)
	name_label.text = KND_Database.get_data_property(data,"name")
	#birthday_label.text = KND_Database.get_data_property(data,"birthday")
	#age_label.text = KND_Database.get_data_property(data,"age")
	tip_label.text = KND_Database.get_data_property(data,"tip")
	
	#gender_label.text = KND_Database.get_data_property(data,"gender")
	#race_label.text = KND_Database.get_data_property(data,"race")
		
func save_data() -> void:
	KND_Database.rename_data(data, name_label.text)
	#KND_Database.set_data(data,"birthday",birthday_label.text )
	#KND_Database.set_data(data,"age",age_label.text )
	KND_Database.set_data(data,"tip",tip_label.text )
	#
	#KND_Database.set_data(data,"gender",gender_label.text )
	#KND_Database.set_data(data,"race",race_label.text )
	
## 弹出性别弹窗
func _on_gender_pressed() -> void:
	var gender = gender_label.text
	gender_label.clear()
	
	for i in KND_Database.gender_type.size():
		var type = KND_Database.gender_type[i]
		gender_label.add_item(type)
		if type ==gender:
			gender_label.selected = i

## 选择性别
func _on_gender_item_selected(index: int) -> void:
	gender_label.text = KND_Database.gender_type[index]


func _on_race_pressed() -> void:
	var race = race_label.text
	race_label.clear()
	
	for i in KND_Database.race_type.size():
		var type = KND_Database.race_type[i]
		race_label.add_item(type)
		if type ==race:
			race_label.selected = i


func _on_race_item_selected(index: int) -> void:
	race_label.text = KND_Database.race_type[index]

## 添加状态
func _on_add_status_pressed() -> void:
	status_setting.show()
