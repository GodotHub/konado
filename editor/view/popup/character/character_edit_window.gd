@tool
extends KndDataEditWindow
## 角色编辑器
@onready var name_edit: LineEdit = %name
@onready var tip_edit: TextEdit = %tip

@onready var status_container: BoxContainer = %StatusContainer
@onready var status_texture: TextureRect = %status_texture

const STATUS_COMPONENT = preload("uid://bbos35lnhvbn2")

func load_data() -> void:
	pass
	#if data != -1:
		#name_edit.text = KND_Database.get_data_property(data,"name")
		#tip_edit.text = KND_Database.get_data_property(data,"tip")

func save_data() -> void:
	pass
	#if data != -1:
		#KND_Database.rename_data(data, name_edit.text)
		#print(KND_Database.get_data_property(data,"name"))
		#KND_Database.set_data(data,"tip",tip_edit.text )

## 添加状态
func _on_add_status_pressed() -> void:
	var status_component = STATUS_COMPONENT.instantiate()
	status_container.add_child(status_component)
	status_component.preview_status.connect(_on_preview_status)

func _on_preview_status(node):
	status_texture.texture = load(node.illustration_path)
