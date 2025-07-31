extends BoxContainer

@onready var componet_container:BoxContainer = %componet_label_container ## 组件标签栏
@onready var componet_edit: BoxContainer = %componet_edit

const COMPONENT = preload("uid://bekbl1hthapcy") ## 组件标签
var add_component :=PopupMenu.new()

func _ready() -> void:
	# 添加节点弹窗
	add_component = ComponentFactory.add_node_menu("component_editor")
	add_component.close_requested.connect(_on_add_component_close)
	add_component.id_pressed.connect(_on_add_component_id_pressed)

	add_child(add_component)
	add_component.hide()

func _on_add_component_pressed() -> void:
	add_component.position = position 
	add_component.position.y += size.y - add_component.size.y/2 -50
	add_component.show()

func _on_add_component_id_pressed(id):
	var node_config = ComponentFactory.EDITOR_CONFIG["component_editor"]
	var selected_item = add_component.get_item_text(id)
	if node_config.has(selected_item):
		# 添加 组件标签
		var componet_label = COMPONENT.instantiate()
		componet_container.add_child(componet_label)
		componet_label.text = selected_item
		# 添加 组件
		var node_info = node_config[selected_item]
		var scene_path = node_info["scene"]  # 获取场景地址
		var scene = ResourceLoader.load(scene_path)
		if !scene:
			push_error("加载失败: ", scene_path)
		else:
			var node = scene.instantiate()
			componet_edit.add_child(node)
			


func _on_add_component_close() -> void:
	add_component.hide()
