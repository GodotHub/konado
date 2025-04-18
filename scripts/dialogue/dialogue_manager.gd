#_____________________________________________________#
#   _  __                              _              #
#  | |/ /   ___    _ __     __ _    __| |   ___       #
#  | ' /   / _ \  | '_ \   / _` |  / _` |  / _ \      #
#  | . \  | (_) | | | | | | (_| | | (_| | | (_) |     #
#  |_|\_\  \___/  |_| |_|  \__,_|  \__,_|  \___/      #
#                                                     #
#____________________________________________________ #
#                                                     #
# Main Programmer: DSOE1024                           #
# Shaders Programmer: yxj                             #
# Version: 1.0.0                                      #
# Description: Visual Novel Game Engine               #
#_____________________________________________________#
#                                                     #
# License: MIT                                        #
# ____________________________________________________#
#                                                     #
# If you want to enjoy art,                           #
# then you must be a person with artistic cultivation #
#_____________________________________________________#


extends Control
class_name DialogueManager

## 对话当前行，同时也是用于读取对话列表的下标，在游戏中的初始值应该为0或者任何大于0的整数
var curline: int

## 是否第一进入当前句对话，由于一些方法只需要在首次进入当前行对话时调用一次，而一些方法需要循环调用（如检查打字动画是否完成的方法）
## 因此，需要判断是否第一次进入当前行对话
var justenter: bool
@export_group("播放设置")
@export var autoplay: bool
## 对话播放速度
@export var dialogspeed: float = 0.06
## 自动播放速度
@export var autoplayspeed: float = 2
## 正在调试（关闭控制）
@export var debug_mode: bool
## 对话状态（0:关闭，1:播放，2:播放完成下一个）
enum DialogState {OFF, PLAYING, PAUSED}
## 对话的状态
## 分别有以下状态：
## 0.关闭状态
## 1.播放对话状态
## 2.播放完成状态
var dialogueState: DialogState

## 对话界面接口类，包括对话人物姓名（RichTextLabel）和对话（RichTextLabel）
@onready var _dialog_interface: DialogueInterface = $DialogUI/DialogueInterface
## 背景和角色UI界面接口
@onready var _acting_interface: ActingInterface = $DialogUI/ActingInterface
## 音频接口
@onready var _audio_interface: DialogAudioInterface = $AudioInterface


## 对话的交互按钮，比如存档按钮，读档按钮，继续按钮
## 存档按钮
@onready var _saveButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/存档"
## 读档按钮
@onready var _loadButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/读档"
## 快速存档按钮
@onready var _qsButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/快速保存"
## 记录按钮
@onready var _logButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/记录"
## 退出按钮
@onready var _exitButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/退出"
## 自动按钮
@onready var _autoPlayButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/自动"
## 对话继续按钮
@onready var _continueButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/继续"
## 对话资源
var _dialog_data: DialogueData

## 对话
var _dialog: Dialogue

## 对话资源ID
var _dialog_data_id: int = 0

## 资源列表
@export_group("资源列表")
## 角色列表
@export var _chara_list: CharacterList
## 背景列表
@export var _background_list: BackgroundList
## 对话列表
@export var _dialog_data_list: DialogueDataList
## BGM列表
@export var _bgm_list: DialogBGMList
## 配音资源列表
@export var _voice_list: DialogVoiceList
## 音效列表
@export var _soundeffect_list: DialogSoundEffectList
## 调试
@export_group("调试")
## 调试控制台
@export var debug_console: DebugConsole

func _ready() -> void:
	# 读取玩家的设置
	var config = ConfigFile.new()
	var error = config.load("user://settings.cfg")
	if error == OK:
		if not debug_mode:
			if config.get_value("advanced_settings", "console") == 0:
				debug_mode = true
			else:
				debug_mode = false
	# 连接按钮信号
	# Continue
	if not _continueButton.button_up.is_connected(_continue):
		_continueButton.button_up.connect(_continue)
	# QS
	if not _qsButton.button_up.is_connected(_on_qsbutton_press):
		_qsButton.button_up.connect(_on_qsbutton_press)
	# Save
	if not _saveButton.button_up.is_connected(_on_savebutton_press):
			_saveButton.button_up.connect(_on_savebutton_press)
	# Load
	if not _loadButton.button_up.is_connected(_on_loadbutton_press):
		_loadButton.button_up.connect(_on_loadbutton_press)
	# Auto
	if not _autoPlayButton.toggled.is_connected(start_autoplay):
		_autoPlayButton.toggled.connect(start_autoplay)
	## 添加~控制台按键映射（如果不使用_input方法或者手动添加按键映射）
		#if not InputMap.has_action("toggle_console_action"):
		#InputMap.add_action("toggle_console_action")
		#var default_toggle_console_event = InputEventKey.new()
		#default_toggle_console_event.physical_keycode = KEY_QUOTELEFT
		#InputMap.action_add_event("toggle_console_action", default_toggle_console_event)

	# 初始化对话
	_init_dialogue(func():
		await get_tree().create_timer(0.1).timeout
		_start_dialogue()
		)
	# 开始对话
	#_start_dialogue()

## 初始化对话的方法
func _init_dialogue(callback: Callable = Callable()) -> void:
	_dialog_data = DialogueData.new()
	
	if _dialog_data_list == null:
		_dialog_data_list = DialogueDataList.new()
	if _dialog_data_list.dialog_data_list.size() <= 0:
		print("对话列表为空")
		return
	var path = _dialog_data_list.dialog_data_list[_dialog_data_id]._dialog_data_file_path
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("6666666666")
	
	var lines = file.get_as_text().split("\n")
	file.close()

	# 解析元数据
	var metadata_result = KS._parse_metadata(lines, path)
	if not metadata_result:
		_dialog_data = null
		printerr("666")
		return
	
	_dialog_data.chapter_id = metadata_result[0]
	_dialog_data.chapter_name = metadata_result[1]
	var content_lines = lines.slice(2)
	# 将角色表传给acting_interface
	_acting_interface.chara_list = _chara_list
	justenter = true
	dialogueState == DialogState.OFF
	curline = 0
	print_rich("[color=yellow]初始化对话 [/color]" + "justenter: " + str(justenter) +
	" 对话下标: " + str(curline) + " 当前状态: " + str(dialogueState))
	print("---------------------------------------------")

## 开始对话的方法
func _start_dialogue() -> void:
	# 显示
	if !_dialog_interface:
		_dialog_interface.show()
	if !_acting_interface:
		_acting_interface.show()
	# 切换到播放状态
	_dialogue_goto_state(DialogState.PLAYING)
	print_rich("[color=yellow]开始对话 [/color]")


func _physics_process(delta) -> void:
	match dialogueState:
		# 关闭状态
		DialogState.OFF:
			if justenter:
				print_rich("[color=cyan][b]当前状态：[/b][/color][color=orange]关闭状态[/color]")
				justenter = false
		# 播放状态
		DialogState.PLAYING:
			if justenter:
				print_rich("[color=cyan][b]当前状态：[/b][/color][color=orange]播放状态[/color]")
				if _dialog_data == null:
					print_rich("[color=red]对话为空[/color]")
					return
				if _dialog_data.dialogs.size() <= 0:
					print_rich("[color=red]对话为空[/color]")
					_dialogue_goto_state(DialogState.OFF)
					return
				_dialog = _dialog_data.dialogs[curline]
				# 对话类型
				var dialog_type = _dialog_data.dialogs[curline].dialog_type
				# 对话当前句
				var dialog = _dialog_data.dialogs[curline]
				# 隐藏选项
				_dialog_interface._choice_container.hide()
				# 判断对话类型
				# 如果是普通对话
				if dialog_type == Dialogue.Type.Ordinary_Dialog:
					# 播放对话
					var chara_id
					var content
					var voice_id
					if (dialog.character_id != null):
							chara_id = dialog.character_id
					if (dialog.dialog_content != null):
						content = dialog.dialog_content
					if dialog.voice_id:
						voice_id = dialog.voice_id
					var speed = dialogspeed
					var playvoice
					if voice_id:
						playvoice = true
					else:
						playvoice = false
					if not _dialog_interface.finish_typing.is_connected(isfinishtyping):
						_dialog_interface.finish_typing.connect(isfinishtyping.bind(playvoice))
					# 显示UI
					_dialog_interface.show()
					# 播放对话
					_display_dialogue(chara_id, content, speed)
					# 如果有配音播放配音
					if voice_id:
						_play_voice(voice_id)
					pass
				# 如果是切换背景
				elif dialog_type == Dialogue.Type.Switch_Background:
					# 显示背景
					var bg_name = dialog.background_image_name
					var bg_effect = dialog.background_toggle_effects
					var s = _acting_interface.background_change_finished
					s.connect(_process_next.bind(s))
					_acting_interface.show()
					_display_background(bg_name, bg_effect)
					pass
				# 如果是显示演员
				elif dialog_type == Dialogue.Type.Display_Actor:
					# 显示演员
					var actor = dialog.show_actor
					var s = _acting_interface.character_created
					s.connect(_process_next.bind(s))
					_acting_interface.show()
					_display_character(actor)
					pass
				# 如果修改演员状态
				elif dialog_type == Dialogue.Type.Actor_Change_State:
					var actor = dialog.change_state_actor
					var target_state = dialog.change_state
					var s = _acting_interface.character_state_changed
					s.connect(_process_next.bind(s))
					_actor_change_state(actor, target_state)
					pass
				# 如果是删除演员
				elif dialog_type == Dialogue.Type.Exit_Actor:
					# 删除演员
					var actor = dialog.exit_actor
					var s = _acting_interface.character_deleted
					s.connect(_process_next.bind(s))
					_exit_actor(actor)
					_acting_interface.show()
					pass
				# 如果是选项
				elif dialog_type == Dialogue.Type.Show_Choice:
					var dialog_choices = dialog.choices
					# 生成并显示选项
					_display_options(dialog_choices)
					_acting_interface.show()
					_dialog_interface.show()
					_dialog_interface._choice_container.show()
					pass
				# 如果是播放BGM
				elif dialog_type == Dialogue.Type.Play_BGM:
					var s = _audio_interface.finish_playbgm
					s.connect(_process_next.bind(s))
					var bgm_name = dialog.bgm_name
					_play_bgm(bgm_name)
					pass
				# 如果是停止BGM
				elif dialog_type == Dialogue.Type.Stop_BGM:
					_stop_bgm()
					_process_next()
					pass
				# 如果是播放音效
				elif dialog_type == Dialogue.Type.Play_SoundEffect:
					var s = _audio_interface.finish_playsoundeffect
					s.connect(_process_next.bind(s))
					var se_name = dialog.soundeffect_name
					_play_soundeffect(se_name)
					pass
				# 如果是剧情跳转
				elif dialog_type == Dialogue.Type.JUMP:
					var data_name = dialog.jump_data_name
					_jump_dialog_data(data_name)
					pass
				# 如果是解锁成就
				elif dialog_type == Dialogue.Type.UNLOCK_ACHIEVEMENTS:
					var achievement_id = dialog.achievement_id
					_process_achievement(achievement_id)
				# 如果剧终
				elif dialog_type == Dialogue.Type.THE_END:
					# 停止对话
					_stop_dialogue()
					pass
				justenter = false
		# 完成下一个状态
		DialogState.PAUSED:
			if justenter:
				print_rich("[color=cyan][b]状态：[/b][/color][color=orange]播放完成状态[/color]")
				justenter = false
		
		
## 处理输入
func _input(event):
	if event is InputEventKey:
		## 控制台~
		if event.pressed and event.keycode == KEY_QUOTELEFT:
			if debug_mode:
				if not debug_console.is_visible():
					debug_console.show()
				else:
					debug_console.hide()
		## 对话继续
		if event.pressed and event.keycode == KEY_ENTER:
			if not debug_console.is_visible():
				_continue()
		
## 打字完成
func isfinishtyping(wait_voice: bool) -> void:
	_dialog_interface.finish_typing.disconnect(isfinishtyping)
	_dialogue_goto_state(DialogState.PAUSED)
	print("触发打字完成信号")
	# 如果自动播放还要检查配音是否播放完毕
	if autoplay:
		# 如果有配音等待配音播放完成
		if wait_voice:
			await _audio_interface.voice_finish_playing
			# 旁白等待两秒
		else:
			await get_tree().create_timer(autoplayspeed).timeout
		_continue()

	
## 自动下一个
func _process_next(s: Signal = Signal()) -> void:
	if not s.is_null():
		s.disconnect(_process_next)
	print("触发自动下一个信号")
	_dialogue_goto_state(DialogState.PAUSED)
	# 暂时先用等待的方法，没找到更好的解决方法
	await get_tree().create_timer(0.001).timeout
	print_rich("[color=yellow]点击继续按钮，判断状态[/color]")
	match dialogueState:
		DialogState.OFF:
			print("对话关闭状态，无需做任何操作")
			return
		DialogState.PLAYING:
			print("对话播放状态，等待播放完成")
			return
		DialogState.PAUSED:
			print("对话播放完成，开始播放下一个")
			# 如果列表中所有对话播放完成了
			if curline + 1 >= _dialog_data.dialogs.size():
				# 切换到对话关闭状态
				_dialogue_goto_state(DialogState.OFF)
			# 如果列表中还有对话没有播放
			else:
				_nextline()
				# 切换到播放状态
				_dialogue_goto_state(DialogState.PLAYING)
			return

	
## 关闭对话的方法
func _stop_dialogue() -> void:
	print_rich("[color=yellow]关闭对话[/color]")
	# 切换到关闭状态
	_dialogue_goto_state(DialogState.OFF)
	
## 对话状态切换的方法
func _dialogue_goto_state(dialogstate: DialogState) -> void:
	# 重置justenter状态
	justenter = true
	# 切换状态到
	dialogueState = dialogstate
	# justenter=true
	print_rich("[color=yellow]切换状态到: [/color]" + str(dialogueState))

## 增加对话下标，下一句
func _nextline() -> void:
	curline += 1
	print_rich("---------------------------------------------")
	print("对话下标：" + str(curline))

## 继续，下一句按钮
func _continue() -> void:
	print_rich("[color=yellow]点击继续按钮，判断状态[/color]")
	match dialogueState:
		DialogState.OFF:
			print("对话关闭状态，无需做任何操作")
			return
		DialogState.PLAYING:
			print("对话播放状态，等待播放完成")
			return
		DialogState.PAUSED:
			_audio_interface.stop_voice()
			print("对话播放完成，开始播放下一个")
			# 如果列表中所有对话播放完成了
			if curline + 1 >= _dialog_data.dialogs.size():
				# 切换到对话关闭状态
				_dialogue_goto_state(DialogState.OFF)
			# 如果列表中还有对话没有播放
			else:
				_nextline()
				# 切换到播放状态
				_dialogue_goto_state(DialogState.PLAYING)
			return
			
## 开始自动播放的方法
func start_autoplay(value: bool):
	autoplay = value
	if value:
		_autoPlayButton.set_text("停止播放")
	else:
		_autoPlayButton.set_text("自动播放")
	_continueButton.set_disabled(value)
	_continue()
	pass
	
## 显示对话的方法
func _display_dialogue(chara_id: String, content: String, speed: float) -> void:
	var chara_name: String = "旁白"
	#if chara_id:
		#for chara in _chara_list.characters:
			#if chara.chara_id == chara_id:
				#chara_name = str(chara.chara_name)
	if chara_id.length() > 0:
		chara_name = chara_id
	# 设置姓名
	_dialog_interface.set_character_name(chara_name)
	# 显示对话
	_dialog_interface.set_content(content, speed)

## 显示背景的方法
func _display_background(bg_name: String, effect: ActingInterface.EffectsType) -> void:
	if bg_name == null:
		return
	var bg_list = _background_list.background_list
	var bg_tex: Texture
	for bg in bg_list:
		if bg.background_name == bg_name:
			bg_tex = bg.background_image
		else:
			print("背景图片没有找到")
		_acting_interface.change_background_image(bg_tex, bg_name, effect)

## 演员状态切换的方法
func _actor_change_state(chara_id: String, state_id: String):
	var target_chara: Character
	var state_tex: Texture
	for chara in _chara_list.characters:
		if chara.chara_id == chara_id:
			target_chara = chara
			for state in chara.chara_status:
				if state.status_name == state_id:
					state_tex = state.status_texture
	_acting_interface.change_actor_state(target_chara.chara_id, state_id, state_tex)

## 从角色列表创建并显示角色
func _display_character(actor: DialogueActor) -> void:
	if actor == null:
		return
	var target_chara: Character
	var target_chara_name = actor.character_name
	for chara in _chara_list.characters:
		if chara.chara_id == target_chara_name:
			target_chara = chara
			break
	
	if target_chara == null:
		print("目标角色为空")
		return
		
	# 读取对话的角色状态图片ID
	var target_states = target_chara.chara_status
	var target_state_name = actor.character_state
	var target_state_tex
	for state in target_states:
		if state.status_name == target_state_name:
			target_state_tex = state.status_texture
			break
	# 角色位置
	var pos = actor.actor_position
	# 角色缩放
	var a_scale = actor.actor_scale
	# 创建角色
	_acting_interface.create_new_character(target_chara_name, pos, target_state_name, target_state_tex, a_scale)
		
## 演员退场
func _exit_actor(actor_name: String) -> void:
	_acting_interface.delete_character(actor_name)

## 播放BGM
func _play_bgm(bgm_name: String) -> void:
	if bgm_name == null:
		return
	var target_bgm: AudioStream
	for bgm in _bgm_list.bgms:
		if bgm.bgm_name == bgm_name:
			target_bgm = bgm.bgm
			break
	_audio_interface.play_bgm(target_bgm, bgm_name)

## 停止播放BGM
func _stop_bgm() -> void:
	_audio_interface.stop_bgm()
	pass
## 播放配音
func _play_voice(voice_name: String) -> void:
	if voice_name == null:
		return
	var target_voice: AudioStream
	for voice in _voice_list.voices:
		if voice.voice_name == voice_name:
			target_voice = voice.voice
			break
	_audio_interface.play_voice(target_voice)
	pass

## 播放音效
func _play_soundeffect(se_name: String) -> void:
	if se_name == null:
		return
	var target_soundeffect: AudioStream
	for soundeffect in _soundeffect_list.soundeffects:
		if soundeffect.se_name == se_name:
			target_soundeffect = soundeffect.se
			break
		_audio_interface.play_sound_effect(target_soundeffect)
		pass
	pass
## 显示对话选项的方法
func _display_options(choices: Array[DialogueChoice]) -> void:
	# _dialog_interface.display_options(choices, null, null)
	pass

## 选项触发方法
func _on_option_triggered(choice: DialogueChoice) -> void:
	var data_id = choice.jumpdata_id
	# 切换剧情
	_jump_dialog_data(data_id)
	print_rich("玩家选择按钮： " + str(choice.choice_text))
	
## 跳转剧情的方法
func _jump_dialog_data(data_id: String) -> bool:
	var jumpdata: DialogueData
	jumpdata = _get_dialog_data(data_id)
	if jumpdata == null:
		print("无法完成跳转，没有这个剧情")
		return false
	# 切换剧情
	_switch_data(jumpdata)
	print_rich("跳转到：" + str(jumpdata.chapter_name))
	return true

## 寻找指定剧情
func _get_dialog_data(data_id: String) -> DialogueData:
	print(data_id)
	var target_data: DialogueData
	for data in _dialog_data_list.dialog_data_list:
		if data._dialog_data.chapter_id == data_id:
			target_data = data._dialog_data
	return target_data
	
## 切换剧情的方法
func _switch_data(data: DialogueData) -> bool:
	if not data and data.dialogs.size() > 0:
		return false
	_stop_dialogue()
	print("切换到 " + data.chapter_name + " 剧情文件")
	_dialog_data = data
	_init_dialogue()
	await get_tree().create_timer(0.01).timeout
	_start_dialogue()
	return true

## 解锁成就
func _process_achievement(id: String):
	# 这里可以添加成就解锁的接口
	_process_next()
	
## 按下快速存档按钮
func _on_qsbutton_press():
	pass
	
## 按下存档按钮
func _on_savebutton_press():
	# 停止语音
	_audio_interface.stop_voice()
	pass
	
## 按下读档按钮
func _on_loadbutton_press():
	# 停止语音
	_audio_interface.stop_voice()
	pass

## 读取存档用的跳转
func jump_data_and_curline(data_id: String, _curline: int, bgm_id: String, actor_dict: Dictionary = {}):
	print("对话ID" + data_id + "   对话线" + str(_curline) + "   角色表：" + str(actor_dict))
	if debug_jump_data(data_id):
		_play_bgm(bgm_id)
		debug_jump_curline(_curline)
	# 如果角色列表不为空
	if not actor_dict.is_empty():
		print("存档角色表不为空")
		for actor in actor_dict:
			var target_actor: DialogueActor = DialogueActor.new()
			var actor_dic = actor_dict[actor]
			target_actor.character_name = actor_dic["id"]
			target_actor.actor_position = Vector2(actor_dic["x"], actor_dic["y"])
			target_actor.character_state = actor_dic["state"]
			target_actor.actor_scale = actor_dic["c_scale"]
			_display_character(target_actor)

# 获取游戏进度，返回一个字典，包括章节名称，章节ID和对话下标
func get_game_progress() -> Dictionary:
	var dic = {}
	dic["chapter_name"] = _dialog_data.chapter_name
	dic["chapter_id"] = _dialog_data.chapter_id
	dic["curline"] = curline
	return dic

## 调试模式跳转到对话
func debug_jump_curline(value: int) -> bool:
	if value >= 0:
		if not value >= _dialog_data.dialogs.size():
			_dialogue_goto_state(DialogState.OFF)
			curline = value
			_dialogue_goto_state(DialogState.PLAYING)
			return true
	return false
## 调试模式跳转到章节
func debug_jump_data(value: String) -> bool:
	var error = _jump_dialog_data(value)
	return error
	
## 调试模式获取信息
func debug_get_info() -> String:
	var info = "章节ID：" + str(_dialog_data.chapter_id) \
	+"  章节：" + str(_dialog_data.chapter_name) \
	+"  对话行：" + str(curline) \
	+"  状态：" + str(dialogueState)
	return info
	
## 调试获取章节列表
func debug_get_dialog_data_list() -> Array[String]:
	var data_array: Array[String]
	for data in _dialog_data_list.dialog_data_list:
		data_array.append(data._dialog_data.chapter_id)
	return data_array

## 调试加载外部剧情
func debug_load_dialog_data(data) -> bool:
	var error = await _switch_data(data)
	return error

func _exit_tree():
	_stop_dialogue()
	pass
