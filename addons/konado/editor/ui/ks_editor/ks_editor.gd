@tool
extends Node

@onready var code_edit: CodeEdit = %CodeEdit

@onready var statement_tree: Tree = %StatementTree


var ks_statement: Dictionary = {}

func _ready() -> void:
	# ks_statement = load_csv()
	var kscsv := KsCsvDict.new()
	kscsv = ResourceLoader.load( "uid://dbf8118ftqyvc" ) 
	print(kscsv.csv_data)
	## 直接从资源加载
	ks_statement =kscsv.csv_data
	create_tree_from_dict()

## TODO：已经在ks_csv_importer中实现，这里不再需要，未来考虑删除
# func load_csv() -> Dictionary:
# 	var file = FileAccess.open(ks_statement_path, FileAccess.READ)
# 	var data: Dictionary = {}
	
# 	# 首先读取标题行
# 	var headers = file.get_csv_line()
# 	if headers.size() == 0:
# 		file.close()
# 		return data
	
# 	# 读取数据行
# 	while not file.eof_reached():
# 		var line = file.get_csv_line()
# 		if line.size() > 0 and line[0] != "": # 跳过空行和空键的行
# 			var key = line[0]
# 			var entry: Dictionary = {
# 				"按钮名称": line[1] if line.size() > 1 else "",
# 				"按钮图标": line[2] if line.size() > 2 else "",
# 				"插入语句": line[3] if line.size() > 3 else "",
# 				"按钮备注": line[4] if line.size() > 4 else ""
# 			}
			
# 			# 如果键已存在，创建或添加到嵌套字典中
# 			if data.has(key):
# 				if typeof(data[key]) == TYPE_DICTIONARY:
# 					# 如果已经是一个字典，转换为数组
# 					var existing_entry = data[key]
# 					data[key] = [existing_entry, entry]
# 				elif typeof(data[key]) == TYPE_ARRAY:
# 					# 如果已经是数组，添加新条目
# 					data[key].append(entry)
# 			else:
# 				# 键不存在，直接添加
# 				data[key] = entry
	
# 	file.close()
# 	print(data)
# 	return data

func create_tree_from_dict():
	# 清除现有树项（如果有）
	statement_tree.clear()
	
	var root = statement_tree.create_item()
	
	for label in ks_statement.keys():
		var label_item = statement_tree.create_item(root)
		label_item.set_text(0, label)
		
		# 检查当前标签的值是字典还是数组
		var label_data = ks_statement[label]
		
		if typeof(label_data) == TYPE_ARRAY:
			# 处理数组情况（多个相同标签的条目）
			for entry in label_data:
				var button_item = statement_tree.create_item(label_item)
				button_item.set_text(0, entry["按钮名称"])
				
				# 设置备注为tooltip
				if entry["按钮备注"] != "":
					button_item.set_tooltip_text(0, entry["按钮备注"])
				
				# 如果有图标路径，加载并设置图标
				if entry["按钮图标"] != "":
					var icon = load(entry["按钮图标"])
					if icon:
						button_item.set_icon(0, icon)
				
				# 存储所有数据到元数据
				button_item.set_metadata(0, str(entry["插入语句"]))
				button_item.set_selectable(0, true)
		elif typeof(label_data) == TYPE_DICTIONARY:
			# 处理字典情况（单个条目）
			var button_item = statement_tree.create_item(label_item)
			button_item.set_text(0, label_data["按钮名称"])
			
			# 设置备注为tooltip
			if label_data["按钮备注"] != "":
				button_item.set_tooltip_text(0, label_data["按钮备注"])
			
			# 如果有图标路径，加载并设置图标
			if label_data["按钮图标"] != "":
				var icon = load(label_data["按钮图标"])
				if icon:
					button_item.set_icon(0, icon)
			
			# 存储所有数据到元数据
			button_item.set_metadata(0, (label_data["插入语句"]))
			print(";;dksd;;", label_data["插入语句"])
			button_item.set_selectable(0, true)
	
	# 恢复为单列显示
	statement_tree.set_columns(1)
	
	# 连接信号（确保只连接一次）
	if not statement_tree.item_selected.is_connected(_on_Tree_item_selected):
		statement_tree.item_selected.connect(_on_Tree_item_selected)
		
func _on_Tree_item_selected():
	var selected_item = statement_tree.get_selected()
	if selected_item.get_parent() != statement_tree.get_root():
		var statement = selected_item.get_metadata(0)
		on_button_pressed(str(statement))
		# 清除选择以便可以再次选择同一项
		statement_tree.deselect_all()
		
func on_button_pressed(ks_statement: String) -> void:
	if not ks_statement:
		push_warning("未指定语句")
		return
	
	var current_line = code_edit.get_caret_line()
	var line_text: String = code_edit.get_line(current_line).strip_edges()
	var total_lines = code_edit.get_line_count()
	
	if line_text != "": # 如果当前行有文字（非空）
		# 自动回车换行，否则无法越界插入
		code_edit.text = code_edit.text + "\n"
		code_edit.insert_line_at(total_lines, ks_statement)
		code_edit.set_caret_line(total_lines + 1) # 将光标移动到新行
		print("插入语句: ", ks_statement, "在行: ", current_line + 1)
	else: # 如果当前行是空的
		code_edit.set_line(current_line, ks_statement)
		code_edit.set_caret_line(current_line)
	code_edit.grab_focus()
	print("插入语句: ", ks_statement)
