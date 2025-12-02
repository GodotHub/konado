extends Control

# var choices_ID : int

# func _masklayer():
# 	var masklayer : ColorRect = ColorRect.new()
	
# 	masklayer.name = "IDMS"
# 	masklayer.size_flags_horizontal = Control.SIZE_EXPAND_FILL#使其填满上级容器
# 	masklayer.size_flags_vertical = Control.SIZE_EXPAND_FILL
# 	masklayer.custom_minimum_size.x = DisplayServer.window_get_size().x#将大小设置为当前屏幕大小
# 	masklayer.custom_minimum_size.y = DisplayServer.window_get_size().y - 60#留出按钮
# 	masklayer.color = Color.BLACK
	
# 	get_node(".").add_child(masklayer)
# 	print("背景图层已创建")

# #滚动容器相关
# func _scroll_container():
	
# 	var scroll_container : ScrollContainer = ScrollContainer.new()#新建节点
	
# 	scroll_container.name = "IDS"#命名，这是整个回顾系统的可滚动容器，ID唯一
# 	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL#使其填满上级容器
# 	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
# 	scroll_container.custom_minimum_size.x = DisplayServer.window_get_size().x#将大小设置为当前屏幕大小
# 	scroll_container.custom_minimum_size.y = DisplayServer.window_get_size().y - 60#留出按钮空间
# 	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED#调整手柄可见性
# 	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	
# 	if get_node("."):#判定父节点是否存在
# 		get_node(".").add_child(scroll_container)
# 		print("IDS:ScrollContainer 已创建")#创建节点
# 	else:
# 		_masklayer()

# #二级vbox相关
# func _vbox_container():
# 	var vbox_container : VBoxContainer = VBoxContainer.new()#新建节点
	
# 	vbox_container.name = "IDV"#命名，滚动容器内的vbox，同样唯一
# 	vbox_container.custom_minimum_size.y = 720
# 	vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL #使其填满
# 	vbox_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
# 	if not get_node("./IDS"):#若父节点返空则报错
# 		printerr("父节点IDV丢失，进程已停止")
# 		return
# 	else :#新建节点
# 		get_node("./IDS").add_child(vbox_container)
# 		if get_node("./IDS/IDV"):
# 			print("IDV:VboxContainer 已创建")

# #设置对话组，从DialogueManager获取数据
	
# 	var choice_marginbox : MarginContainer = MarginContainer.new()
# 	var choice_vbox : VBoxContainer = VBoxContainer.new()
# 	var choice_box : Label = Label.new()
	
# 	var IDM_name : String = "IDM" + str(dialog_id)#相关ID与路径
# 	var IDA_name : String = "IDA" + str(dialog_id)
# 	var IDM_route : String = "./IDS/IDV/" + IDM_name
# 	var IDA_route : String = IDM_route + "/" + IDA_name
	
# 	choice_marginbox.name = IDM_name#使选项往右移的MarginContainer
# 	choice_marginbox.add_theme_constant_override("margin_left",150)
# 	if not get_node("./IDS/IDV"):
# 		printerr("父节点IDV丢失，进程已停止")
# 		return
# 	else:
# 		get_node("./IDS/IDV").add_child(choice_marginbox)
# 		if get_node(IDM_route):
# 			print("IDM：MarginContainer 已创建" )
	
# 	choice_vbox.name = IDA_name#容纳所有选项的vbox
# 	choice_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
# 	if not get_node(IDM_route):
# 		printerr("父节点IDV丢失，进程已停止")
# 		return
# 	else:
# 		get_node(IDM_route).add_child(choice_vbox)
# 		if get_node(IDA_route):
# 			print("IDA：VboxContainer 已创建" )
	
# 	for option in choices:#遍历选项，创建对应Label
# 		var option_label : Label = Label.new()
# 		option_label.custom_minimum_size.x = 100
# 		option_label.custom_minimum_size.y = 60
# 		option_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
# 		option_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
# 		option_label.name = option.choice_text
# 		option_label.text = option.choice_text
# 		option_label.add_theme_color_override("font_color" , Color.GRAY)
# 		get_node(IDA_route).add_child(option_label)
	
# 	choices_ID = dialog_id

# ## 因为在上述函数获取数据时不能获取text（会返回null），所以换到了DialogueManager获取text
# func find_choosen(text : String):
# 	var choosen_routes : String = "./IDS/IDV/IDM" + str(choices_ID) +"/IDA" + str(choices_ID) + "/" + text
# 	var choosen_node_route : Label = get_node(choosen_routes)
# 	#寻找选项
	
# 	choosen_node_route.add_theme_color_override("font_color" , Color.YELLOW)
# 	#调黑

# func change_visible():#修改可见性
# 	var ui : Node = get_node(".")
# 	ui.custom_minimum_size.y = DisplayServer.window_get_size().y - 60
# 	if _check_visible() == true :
# 		ui.z_index = 100
# 		ui.visible = true
# 	else :
# 		ui.z_index = 0
# 		ui.visible = false

# func _check_visible() -> bool:#检查可见性
# 	var ui : Node = get_node(".")
# 	if ui.z_index != 100 :
# 		return true
# 	else :
# 		return false

# func remove_records():#移除所有记录
# 	for child in get_node("./IDS/IDV").get_children():
# 		child.queue_free()
