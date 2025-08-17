extends Control

var choices_ID : int

func _masklayer():
	var masklayer : ColorRect = ColorRect.new()
	
	masklayer.name = "IDMS"
	masklayer.size_flags_horizontal = Control.SIZE_EXPAND_FILL#使其填满上级容器
	masklayer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	masklayer.custom_minimum_size.x = DisplayServer.window_get_size().x#将大小设置为当前屏幕大小
	masklayer.custom_minimum_size.y = DisplayServer.window_get_size().y - 60#留出按钮
	masklayer.color = Color.GRAY
	
	get_node(".").add_child(masklayer)

#滚动容器相关
func _scroll_container():
	
	var scroll_container : ScrollContainer = ScrollContainer.new()#新建节点
	
	scroll_container.name = "IDS"#命名，这是整个回顾系统的可滚动容器，ID唯一
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL#使其填满上级容器
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.custom_minimum_size.x = DisplayServer.window_get_size().x#将大小设置为当前屏幕大小
	scroll_container.custom_minimum_size.y = DisplayServer.window_get_size().y - 60#留出按钮空间
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED#调整手柄可见性
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
	
	if get_node("."):#判定父节点是否存在
		get_node(".").add_child(scroll_container)
		print("IDS:ScrollContainer 已创建")#创建节点
	else:
		_masklayer()
		#printerr("父节点已丢失，进程已停止")#报错

#二级vbox相关
func _vbox_container():
	var vbox_container : VBoxContainer = VBoxContainer.new()#新建节点
	
	vbox_container.name = "IDV"#命名，滚动容器内的vbox，同样唯一
	vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL #使其填满
	vbox_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if not get_node("./IDS"):#若父节点返空则报错
		printerr("父节点IDV丢失，进程已停止")
		return
	else :#新建节点
		get_node("./IDS").add_child(vbox_container)
		if get_node("./IDS/IDV"):
			print("IDV:VboxContainer 已创建")

#设置对话组，从DialogueManager获取数据
func _dialog_set(dialog_id : int , name : String , content : String):
	if get_node("./IDS") and get_node("./IDS/IDV"):
		pass
	else:
		_masklayer()
		_scroll_container()
		_vbox_container()#如果上级容器不存在就新建
	
	var dialog_set_vboxcontainer : VBoxContainer = VBoxContainer.new()
	var dialog_set_hboxcontainer : HBoxContainer = HBoxContainer.new()
	var dialog_set_name_label : Label = Label.new()
	var dialog_set_content_label : Label = Label.new()#新建节点
	
	var dialog_set_id : String = "ID" + str(dialog_id)#本对话组的ID
	
	var dialog_set_v1_id : String = dialog_set_id + "_1"#最外层的vboxcontainer
	var v1_route : String = "./IDS/IDV/" + dialog_set_v1_id#它的路径
	
	var dialog_set_h2_id : String = dialog_set_id + "_2"#装两个Label的hboxcontainer
	var h2_route : String = "./IDS/IDV/" + dialog_set_v1_id +"/" + dialog_set_h2_id#它的路径
	
	var dialog_set_l1_id : String = dialog_set_id + "_3"#第一个文本框，名字
	var l1_route : String = "./IDS/IDV/" + dialog_set_v1_id +"/" + dialog_set_h2_id + "/" + dialog_set_l1_id#它的路径
	
	var dialog_set_l2_id : String = dialog_set_id + "_4"#第二个文本框，内容
	var l2_route : String = "./IDS/IDV/" + dialog_set_v1_id +"/" + dialog_set_h2_id + "/" + dialog_set_l2_id#它的路径
	
	dialog_set_vboxcontainer.name = dialog_set_v1_id
	dialog_set_vboxcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL#命名并更改尺寸
	
	## 这部分和之后所有的-1+1，是因为在已有子级节点的情况下，add_child会报错，需要用add_siblings；
	## 但是curline并不是每一行都是对话，所以时有报错。
	## TODO：可以优化，但这部分我不是很熟。
	if get_node("./IDS/IDV/ID" + str(dialog_id - 1) + "_1"):
		if not get_node("./IDS/IDV"):
			printerr("父节点IDV丢失，进程已停止")
			return
		else:
			get_node("./IDS/IDV/ID" + str(dialog_id - 1) + "_1").add_sibling(dialog_set_vboxcontainer)
			if get_node(v1_route):
				print(dialog_set_v1_id + "：VboxContainer 已创建" )#创建一级vbox
	else :
		if not get_node("./IDS/IDV"):
			printerr("父节点IDV丢失，进程已停止")
			return
		else:
			get_node("./IDS/IDV").add_child(dialog_set_vboxcontainer)
			if get_node(v1_route):
				print(dialog_set_v1_id + "：VboxContainer 已创建" )
	#创建一级vbox
	
	dialog_set_hboxcontainer.name = dialog_set_h2_id
	dialog_set_hboxcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
	if not get_node(v1_route):
		printerr("父节点" + dialog_set_v1_id + "已丢失，进程已停止")
		return
	else :
		get_node(v1_route).add_child(dialog_set_hboxcontainer)
		if get_node(h2_route):
			print(dialog_set_h2_id + "：HboxContainer 已创建" )
	#创建二级hbox
	
	dialog_set_name_label.name = dialog_set_l1_id
	dialog_set_name_label.custom_minimum_size.x = 100
	dialog_set_name_label.custom_minimum_size.y = 60
	dialog_set_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialog_set_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	dialog_set_name_label.text = name
	if not get_node(h2_route) :
		printerr("父节点" + dialog_set_h2_id + "已丢失，进程已停止")
		return
	else :
		get_node(h2_route).add_child(dialog_set_name_label)
		if get_node(l1_route):
			print(dialog_set_l1_id + "：Label 已创建" )
#创建名字Label，文字上下全居中

	dialog_set_content_label.name = dialog_set_l2_id
	dialog_set_content_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialog_set_content_label.custom_minimum_size.y = 60
	dialog_set_content_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	dialog_set_content_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	dialog_set_content_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_set_content_label.text = content
	if not get_node(h2_route):
		printerr("父节点" + dialog_set_h2_id + "已丢失，进程已停止")
		return
	else :
		get_node(h2_route).add_child(dialog_set_content_label)
		if get_node(l2_route):
			print(dialog_set_l2_id + "：Label 已创建" )
	#创建内容Label，靠左，居中，修改自动换行

#设置选项组，从DialogueInterface获取数据
func _option_set(dialog_id : int , choices : Array):
	
	var choice_marginbox : MarginContainer = MarginContainer.new()
	var choice_vbox : VBoxContainer = VBoxContainer.new()
	var choice_box : Label = Label.new()
	
	var IDM_name : String = "IDM" + str(dialog_id)#相关ID与路径
	var IDA_name : String = "IDA" + str(dialog_id)
	var IDM_route : String = "./IDS/IDV/" + IDM_name
	var IDA_route : String = IDM_route + "/" + IDA_name
	
	choice_marginbox.name = IDM_name#使选项往右移的MarginContainer
	choice_marginbox.add_theme_constant_override("margin_left",150)
	if not get_node("./IDS/IDV"):
		printerr("父节点IDV丢失，进程已停止")
		return
	else:
		get_node("./IDS/IDV").add_child(choice_marginbox)
		if get_node(IDM_route):
			print("IDM：MarginContainer 已创建" )
	
	choice_vbox.name = IDA_name#容纳所有选项的vbox
	choice_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if not get_node(IDM_route):
		printerr("父节点IDV丢失，进程已停止")
		return
	else:
		get_node(IDM_route).add_child(choice_vbox)
		if get_node(IDA_route):
			print("IDA：VboxContainer 已创建" )
	
	for option in choices:#遍历选项，创建对应Label
		var option_label : Label = Label.new()
		option_label.custom_minimum_size.x = 100
		option_label.custom_minimum_size.y = 60
		option_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		option_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		option_label.name = option.choice_text
		option_label.text = option.choice_text
		option_label.add_theme_color_override("font_color" , Color.GRAY)
		get_node(IDA_route).add_child(option_label)
	
	choices_ID = dialog_id

## 因为在上述函数获取数据时不能获取text（会返回null），所以换到了DialogueManager获取text
func find_choosen(text : String):
	var choosen_routes : String = "./IDS/IDV/IDM" + str(choices_ID) +"/IDA" + str(choices_ID) + "/" + text
	var choosen_node_route : Label = get_node(choosen_routes)
	#寻找选项
	
	choosen_node_route.add_theme_color_override("font_color" , Color.BLACK)
	#调黑

func change_visible():
	var ui : Node = get_node(".")
	ui.custom_minimum_size.y = DisplayServer.window_get_size().y - 60
	if _check_visible() == true :
		ui.z_index = 100
		ui.visible = true
	else :
		ui.z_index = 0
		ui.visible = false

func _check_visible() -> bool:
	var ui : Node = get_node(".")
	if ui.z_index != 100 :
		return true
	else :
		return false
