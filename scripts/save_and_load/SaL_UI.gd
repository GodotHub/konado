extends Node
class_name SaL_UI

@onready var _dialogue_manager : DialogueManager = $"../.."#对话管理器主脚本

@onready var All_UI : PanelContainer = $"."#UI界面
@onready var title : Label = $Title#标题文本
@onready var close_button : Button = $Title/CloseButton#关闭按钮

#槽位1日期
@onready var file_timestamp_1 : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer1/FilePanel1/FileMargin1/FileMarginV1/SlotAndDate1
#槽位1章节ID
@onready var file1_chap_ID : Label = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer1/FilePanel1/FileMargin1/FileMarginV1/Chapter1
#槽位1触发按钮
@onready var file1_trigger_button : Button = $FilesContainer/FilesHContainer/FilesVContainer/FileContainer1/FilePanel1/TriggerButton1

var input_for_trigger : int = 0#区分存读档状态用，0为基础值不做变动，1为保存，2为读取

func _ready() -> void:
	close_button.pressed.connect(_close_button_trigger)
	file1_trigger_button.pressed.connect(_file1_trigger)

func check_UI(input : int) -> void:
	match input:
		0:#仅查看
			title.text = "查看"
		1:#保存
			title.text = "保存"
			input_for_trigger = 1
			All_UI.visible = true
			update_file_text_all()
		2:#加载
			title.text = "读取"#更新标题状态
			input_for_trigger = 2
			All_UI.visible = true#打开界面
			update_file_text_all()#更新槽位状态
		4:#关闭
			All_UI.visible = false

func update_file_text(slot_id : int):#更新指定槽位状态
	if KS_SAVE_AND_LOAD._load_game(slot_id) == false:#如果不存在存档就空过且提示
		print("槽位 " + str(slot_id) + "不存在存档")
		return

	#获取并更新文件信息
	match slot_id:
		1:
			file_timestamp_1.text = "记录1 " + "时间：" + KS_SAVE_AND_LOAD._get_file_inf(1)["timestamp"]
			file1_chap_ID.text = "章节 " + KS_SAVE_AND_LOAD._get_file_inf(1)["chapter_id"]
			print("槽位1状态已更新——" + str(KS_SAVE_AND_LOAD._get_file_inf(1)))

func update_file_text_all():#更新所有槽位状态
	update_file_text(1)

func _close_button_trigger():#关闭按钮
	All_UI.visible = false

func _file_trigger(input : int):
	match input_for_trigger:
		0:#仅查看
			return
		1:#存档
			_dialogue_manager._get_file_data(input)#获取数据并存档
			update_file_text_all()#更新文本
		2:#读档
			_dialogue_manager._load_file_data(input)#加载数据
			_close_button_trigger()#读档后自动关闭界面

func _file1_trigger():
	_file_trigger(1)
