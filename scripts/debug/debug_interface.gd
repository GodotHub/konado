extends Control
class_name DebugConsole

var command_history = []

@export var input_box: LineEdit
@export var history_box: RichTextLabel
# 对话管理器
@export var dialog_manager: DialogueManager
# 对话接口
@export var dialog_interface: DialogueInterface
# 音频管理器
@export var audio_interface: DialogAudioInterface
# 文件加载器
@onready var ks_file_loader: FileDialog = $LoadKSFileDialog
func _ready():
	input_box.text_submitted.connect(_on_input_text_entered)
	_update_output("[color=CYAN]控制台输入：help 查看命令列表[/color]")
	
func _on_input_text_entered(text):
	# 处理用户输入
	var input_command = text.strip_edges() # 去除首尾空格
	_update_output("[color=CYAN]>> [/color]" + input_command) # 将用户输入添加到输出区域
	match input_command.split(" ")[0]:
		"next":
			_execute_next_command()
		"stop":
			_execute_stop_command()
		"start":
			_execute_start_command()
		"jump_cur":
			var id = input_command.split(" ")[1].to_int()
			print(id)
			_execute_jump_cur_command(id)
		"jump_data":
			var id = str(input_command.split(" ")[1])
			_execute_jump_data_command(id)
		"set_name":
			var name = String(input_command.split(" ")[1])
			_execute_set_name_command(name)
		"set_content":
			var content = String(input_command.split(" ")[1])
			_execute_set_content_command(content)
		"info":
			_execute_info_command()
		"help":
			_execute_help_command()
		"clean":
			_execute_clean_command()
		"history":
			_execute_history_command()
		"clean_history":
			_execute_clean_history_command()
		"list_dialog_datas":
			_execute_list_dialog_datas_command()
		"load_ks":
			_execute_load_ks_command()
		"":
			pass
		_:
			_update_output("[color=ORANGE]命令没有找到🫠: [/color]" + input_command)

	command_history.append(input_command) # 将命令添加到历史记录

func _update_output(text):
	# 清空输入内容
	input_box.clear()
	# 更新输出区域
	history_box.text += text + "\n" # 在文本显示区域末尾添加新内容
	history_box.scroll_to_line(history_box.get_line_count()) # 滚动到最后一行

func _execute_next_command():
	# 执行下一句指令
	dialog_manager._continue()

func _execute_stop_command():
	# 执行stop指令
	dialog_manager._stop_dialogue()
	_update_output("[color=SEASHELL]停止对话...[/color]")

func _execute_start_command():
	# 执行start指令
	dialog_manager._start_dialogue()
	_update_output("[color=SEASHELL]开启对话...[/color]")

func _execute_jump_cur_command(id):
	# 执行jump_cur指令
	var error = dialog_manager._jump_curline(id)
	if error:
		_update_output("[color=SNOW]跳转到第" + str(id) + "句对话")
	else:
		_update_output("[color=ORANGE]没有这句对话: [/color]")

func _execute_jump_data_command(id: String):
	# 执行jump_data指令
	_update_output("[color=SNOW]跳转到[/color]" + str(id) + "[color=SNOW]剧情[/color]")
	dialog_manager.debug_jump_data(id)

func _execute_info_command():
	# 执行info指令
	var info = dialog_manager.debug_get_info()
	_update_output("[color=BEIGE]游戏信息：[/color]" + info)

func _execute_set_name_command(name: String):
	dialog_interface.set_character_name(name)
	_update_output("设置对话人物姓名：" + name)
	pass
	
func _execute_set_content_command(content: String):
	dialog_interface.set_content(content, 0.06)
	_update_output("设置对话内容：" + content)
	pass
	
func _execute_list_dialog_datas_command():
	# 显示章节ID列表
	var list = dialog_manager.debug_get_dialog_data_list()
	var list_string: String
	_update_output("剧情列表： \n" + ", \n".join(list))
	pass
	
func _execute_help_command():
	# 执行help指令
	_update_output("控制台可用指令: \n \
	help - 查看可用指令帮助\n \
	next - 对话下一个 \n \
	stop - 停止对话 \n \
	start - 开始对话 \n \
	jump_cur <id> - 跳转到指定对话句\n \
	jump_data <id> - 跳转到指定章节\n \
	set_name <name> - 设置对话人物姓名\n \
	set_content <content> - 设置对话内容\n \
	load_ks - 打开文件对话框加载Konado脚本\n \
	info - 打印游戏信息\n \
	list_dialog_datas - 查看剧情文件列表\n \
	history - 历史指令
	clean - 清屏\n \
	clean_history - 清空历史指令")

func _execute_clean_command():
	# 清屏指令
	history_box.set_text("")

func _execute_history_command():
	for command in command_history:
		_update_output("[color=CYAN]history: [/color]" + command)
		
func _execute_clean_history_command():
	# 清空历史
	command_history.clear()

func _execute_load_ks_command():
	ks_file_loader.popup()
	pass

# 加载Pluliter脚本
func _on_ks_file_sel(path: String):
	_update_output("加载路径：" + path)
	var load_data = KS.process_scripts_to_data(path)
	var error = await dialog_manager.debug_load_dialog_data(load_data)
	if error:
		_update_output("加载成功！")
	elif !error:
		_update_output("加载失败")
