@tool

extends Node
class_name SaL_UI

@onready var _dialogue_manager : DialogueManager = $"../.."#对话管理器主脚本

@onready var All_UI : PanelContainer = $"."#UI界面
@onready var title : Label = $Title#标题文本
@onready var close_button : Button = $Title/CloseButton#关闭按钮

#槽位1相关
@onready var file1_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer1/FilePanel1/FileMargin1/FileMarginV1/SlotAndDate1
@onready var file1_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer1/FilePanel1/FileMargin1/FileMarginV1/Chapter1
@onready var file1_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer1/FilePanel1/TriggerButton1
#槽位2相关
@onready var file2_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer2/FilePanel2/FileMargin2/FileMarginV2/SlotAndDate2
@onready var file2_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer2/FilePanel2/FileMargin2/FileMarginV2/Chapter2
@onready var file2_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer2/FilePanel2/TriggerButton2
#槽位3相关
@onready var file3_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer3/FilePanel3/FileMargin3/FileMarginV3/SlotAndDate3
@onready var file3_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer3/FilePanel3/FileMargin3/FileMarginV3/Chapter3
@onready var file3_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer3/FilePanel3/TriggerButton3
#槽位4相关
@onready var file4_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer4/FilePanel4/FileMargin4/FileMarginV4/SlotAndDate4
@onready var file4_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer4/FilePanel4/FileMargin4/FileMarginV4/Chapter4
@onready var file4_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer4/FilePanel4/TriggerButton4
#槽位5相关
@onready var file5_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer5/FilePanel5/FileMargin5/FileMarginV5/SlotAndDate5
@onready var file5_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer5/FilePanel5/FileMargin5/FileMarginV5/Chapter5
@onready var file5_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer5/FilePanel5/TriggerButton5
#槽位6相关
@onready var file6_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer6/FilePanel6/FileMargin6/FileMarginV6/SlotAndDate6
@onready var file6_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer6/FilePanel6/FileMargin6/FileMarginV6/Chapter6
@onready var file6_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer6/FilePanel6/TriggerButton6
#槽位7相关
@onready var file7_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer7/FilePanel7/FileMargin7/FileMarginV7/SlotAndDate7
@onready var file7_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer7/FilePanel7/FileMargin7/FileMarginV7/Chapter7
@onready var file7_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer7/FilePanel7/TriggerButton7
#槽位8相关
@onready var file8_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer8/FilePanel8/FileMargin8/FileMarginV8/SlotAndDate8
@onready var file8_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer8/FilePanel8/FileMargin8/FileMarginV8/Chapter8
@onready var file8_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer8/FilePanel8/TriggerButton8
#槽位9相关
@onready var file9_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer9/FilePanel9/FileMargin9/FileMarginV9/SlotAndDate9
@onready var file9_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer9/FilePanel9/FileMargin9/FileMarginV9/Chapter9
@onready var file9_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer9/FilePanel9/TriggerButton9
#槽位10相关
@onready var file10_timestamp : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer10/FilePanel10/FileMargin10/FileMarginV10/SlotAndDate10
@onready var file10_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer10/FilePanel10/FileMargin10/FileMarginV10/Chapter10
@onready var file10_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer2/FileContainer10/FilePanel10/TriggerButton10

var input_for_trigger : int = 0#区分存读档状态用，0为基础值不做变动，1为保存，2为读取

func _ready() -> void:
	close_button.pressed.connect(_close_button_trigger)#关闭按钮
	
	#对应槽位触发按钮
	file1_trigger_button.pressed.connect(_file1_trigger)
	file2_trigger_button.pressed.connect(_file2_trigger)
	file3_trigger_button.pressed.connect(_file3_trigger)
	file4_trigger_button.pressed.connect(_file4_trigger)
	file5_trigger_button.pressed.connect(_file5_trigger)
	file6_trigger_button.pressed.connect(_file6_trigger)
	file7_trigger_button.pressed.connect(_file7_trigger)
	file8_trigger_button.pressed.connect(_file8_trigger)
	file9_trigger_button.pressed.connect(_file9_trigger)
	file10_trigger_button.pressed.connect(_file10_trigger)

func check_UI(input : int) -> void:
	match input:
		0:#仅查看
			title.text = "查看"
		1:#保存
			title.text = "保存"#更新标题状态
			input_for_trigger = 1#更新变量
			All_UI.visible = true#打开界面
			update_file_text_all()#更新槽位状态
		2:#读取
			title.text = "读取"#更新标题状态
			input_for_trigger = 2#更新变量
			All_UI.visible = true#打开界面
			update_file_text_all()#更新槽位状态
		4:#关闭
			All_UI.visible = false

#TODO: 他妈的，我这段写的属实有点傻逼，感觉能优化，但之后再说吧
func update_file_text(slot_id : int):#更新指定槽位状态
	if KS_SAVE_AND_LOAD._load_game(slot_id) == false:#如果不存在存档就空过且提示
		print_rich("槽位" + str(slot_id) + "[color=green][b] 不存在存档[/b][/color]")
		return
	
	#获取并更新文件信息
	match slot_id:
		1:
			file1_timestamp.text = "记录1 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(1)["timestamp"]
			file1_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(1)["chapter_id"]
			print_rich("槽位1 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(1)))
		2:
			file2_timestamp.text = "记录2 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(2)["timestamp"]
			file2_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(2)["chapter_id"]
			print_rich("槽位2 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(2)))
		3:
			file3_timestamp.text = "记录3 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(3)["timestamp"]
			file3_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(3)["chapter_id"]
			print_rich("槽位3 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(3)))
		4:
			file4_timestamp.text = "记录4 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(4)["timestamp"]
			file4_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(4)["chapter_id"]
			print_rich("槽位4 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(4)))
		5:
			file5_timestamp.text = "记录5 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(5)["timestamp"]
			file5_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(5)["chapter_id"]
			print_rich("槽位5 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(5)))
		6:
			file6_timestamp.text = "记录6 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(6)["timestamp"]
			file6_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(6)["chapter_id"]
			print_rich("槽位6 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(6)))
		7:
			file7_timestamp.text = "记录7 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(7)["timestamp"]
			file7_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(7)["chapter_id"]
			print_rich("槽位7 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(7)))
		8:
			file8_timestamp.text = "记录8 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(8)["timestamp"]
			file8_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(8)["chapter_id"]
			print_rich("槽位8 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(8)))
		9:
			file9_timestamp.text = "记录9 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(9)["timestamp"]
			file9_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(9)["chapter_id"]
			print_rich("槽位9 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(9)))
		10:
			file10_timestamp.text = "记录10 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(10)["timestamp"]
			file10_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(10)["chapter_id"]
			print_rich("槽位10 [color=gold][b]状态已更新——[/b][/color]" + str(KS_SAVE_AND_LOAD._get_file_inf(10)))

func update_file_text_all():#更新所有槽位状态
	update_file_text(1)
	update_file_text(2)
	update_file_text(3)
	update_file_text(4)
	update_file_text(5)
	update_file_text(6)
	update_file_text(7)
	update_file_text(8)
	update_file_text(9)
	update_file_text(10)

func _close_button_trigger():#关闭按钮
	All_UI.visible = false

func _file_trigger(slot_input : int):#根据状态触发操作
	match input_for_trigger:#根据目前所需状态匹配操作
		0:#仅查看
			return
		1:#保存
			_dialogue_manager._get_file_data(slot_input)#获取数据并存档
			update_file_text(slot_input)#更新文本
		2:#读取
			_dialogue_manager._load_file_data(slot_input)#加载数据
			_close_button_trigger()#读档后自动关闭界面

#以下：封装好的触发槽位ID的函数
func _file1_trigger():
	_file_trigger(1)
func _file2_trigger():
	_file_trigger(2)
func _file3_trigger():
	_file_trigger(3)
func _file4_trigger():
	_file_trigger(4)
func _file5_trigger():
	_file_trigger(5)
func _file6_trigger():
	_file_trigger(6)
func _file7_trigger():
	_file_trigger(7)
func _file8_trigger():
	_file_trigger(8)
func _file9_trigger():
	_file_trigger(9)
func _file10_trigger():
	_file_trigger(10)
