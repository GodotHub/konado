@tool
extends BoxContainer



# 自动重命名所有子节点（Label 或 Button）
func _ready():
	if Engine.is_editor_hint():  # 只在编辑器模式下运行
		rename_children_by_text()

# 按子节点的 text 属性重命名
func rename_children_by_text():
	for child in get_children():
		if child is Label or child is Button:
			var text = child.text
			if text and text != "":
				var new_name = text.to_lower().replace(" ", "_")
				child.name = new_name
				print("重命名子节点: %s -> %s" % [child.get_path(), new_name])
