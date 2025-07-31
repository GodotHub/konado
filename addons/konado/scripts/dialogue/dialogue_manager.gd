################################################################################
# Project: Konado
# File: dialogue_manager.gd
# Author: DSOE1024
# Created: 2025-06-27
# Last Modified: 2025-07-13
# Description:
#   对话管理器
################################################################################

@tool

extends Control
class_name DialogueManager

## 对话配置

@export_group("对话配置")

## 是否在游戏开始时自动初始化对话，如果为true，则在游戏开始时自动初始化对话，否则需要手动初始化对话
## 手动初始化对话的方法为：在游戏开始时，调用`init_dialogue`方法
@export var init_onstart: bool = true

## 是否自动开始对话，如果为true，则在游戏开始时自动开始对话，否则需要手动开始对话
## 手动开始对话的方法为：在游戏开始时，调用`start_dialogue`方法
@export var autostart: bool = true

## 是否开启演员自动高亮，如果为true，则根据对话中的角色姓名自动高亮对应的演员，否则不自动高亮
@export var actor_auto_highlight: bool = true


## 对话当前行，同时也是用于读取对话列表的下标，在游戏中的初始值应该为0或者任何大于0的整数
var curline: int

## 是否第一进入当前句对话，由于一些方法只需要在首次进入当前行对话时调用一次，而一些方法需要循环调用（如检查打字动画是否完成的方法）
## 因此，需要判断是否第一次进入当前行对话
var justenter: bool
@export_group("播放设置")
@export var autoplay: bool
## 对话播放速度
@export var dialogspeed: float = 0.03
## 自动播放速度
@export var autoplayspeed: float = 2

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
#存档UI界面接口
@onready var _SaL_UI: SaL_UI = $DialogUI/SaLUI

## 对话的交互按钮，比如存档按钮，读档按钮，继续按钮
## 存档按钮
@onready var _saveButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/存档"
## 读档按钮
@onready var _loadButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/读档"

## 记录按钮
@onready var _logButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/记录"
## 退出按钮
@onready var _exitButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/退出"
## 自动按钮
@onready var _autoPlayButton: Button = $"DialogUI/DialogueInterface/DialogueBox/MarginContainer/DialogContent/ActionsContainer/自动"
## 选项容器（用于实现点击事件屏蔽）
@onready var _choicesContainer: VBoxContainer = $DialogUI/DialogueInterface/ChoicesBox/ChoicesContainer

	
## 对话资源
var dialog_data: DialogueShot = null


## 对话资源ID
var _dialog_data_id: int = 0

#存档用变量
var se_id: String

var option_triggered: bool = false





## 资源列表
@export_group("资源列表")
## 角色列表
@export var chara_list: CharacterList
## 背景列表
@export var background_list: BackgroundList
## 对话列表
@export var dialogue_chapter: DialogueChapter
## BGM列表
@export var bgm_list: DialogBGMList
## 配音资源列表
@export var voice_list: DialogVoiceList
## 音效列表
@export var soundeffect_list: DialogSoundEffectList

## 调试模式
@export var debug_mode = false


func _ready() -> void:
	# 连接按钮信号
	# Save
	if not _saveButton.button_up.is_connected(_on_savebutton_press):
			_saveButton.button_up.connect(_on_savebutton_press)
	# Load
	if not _loadButton.button_up.is_connected(_on_loadbutton_press):
		_loadButton.button_up.connect(_on_loadbutton_press)
	# Auto
	if not _autoPlayButton.toggled.is_connected(start_autoplay):
		_autoPlayButton.toggled.connect(start_autoplay)

	# 为了适应Snowflake编辑器，在编辑器中不自动初始化对话，防止直接在编辑器场景自动播放
	# 这个tool特性设计真的非常难蚌...
	if is_in_editor_and_idle():
		return

	if not debug_mode:
		# 自动初始化和开始对话
		if init_onstart:
			print("自动初始化对话")
			# 初始化对话
			if not autostart:
				_init_dialogue(func():
					print("请手动开始对话")
					)
			else:
				_init_dialogue(func():
					print("自动开始对话")
					await get_tree().create_timer(0.1).timeout
					if dialog_data.dialogs[0].dialog_type == Dialogue.Type.START:
						_start_dialogue()
					else: 
						print("第一句应该是START，请在脚本中修改")
						# 暂停引擎
						get_tree().paused = true
						# _start_dialogue()
					)
		else:
			print("请手动初始化对话")


## 检查是否在编辑器中并且处于空闲状态
## 编辑器中“未播放”状态的本质是场景树未激活，如果场景树未激活，则认为处于空闲状态
func is_in_editor_and_idle() -> bool:
	# 没招，Godot根本没设计运行时和编辑器的区分，只能用这种很傻的方式~
	# 目前想不到什么优化的方法...
	if not Engine.is_editor_hint():
		return false
	var root = get_tree().get_root()
	return root != null and !root.is_processing_internal()

## 这是一个测试方法，用于测试对话管理器
func print_hello() -> bool:
	_display_dialogue("Kona", "Hello, World!", 0.01)
	return true


## 初始化对话的方法
func _init_dialogue(callback: Callable = Callable()) -> void:
	if not debug_mode:
		if dialogue_chapter == null:
			printerr("对话列表资源为空")
			return
		if dialogue_chapter.dialogue_shots.size() <= 0:
			printerr("对话列表没有对话")
			return

		dialog_data = dialogue_chapter.dialogue_shots[_dialog_data_id]
	
		# 将角色表传给acting_interface
		_acting_interface.chara_list = chara_list

	justenter = true
	dialogueState == DialogState.OFF
	curline = 0
	print_rich("[color=yellow]初始化对话 [/color]" + "justenter: " + str(justenter) +
	" 对话下标: " + str(curline) + " 当前状态: " + str(dialogueState))
	print("---------------------------------------------")
	if callback:
		callback.call()

## 设置对话数据的方法
func set_dialogue_data(dialogue_data: DialogueShot) -> void:
	if dialogue_data == null:
		printerr("对话数据为空")
		return
	print(dialogue_data.to_string())
	self.dialog_data = dialogue_data

## 设置角色表的方法
func set_chara_list(chara_list: CharacterList) -> void:
	if chara_list == null:
		printerr("角色列表为空")
		return
	print(chara_list.to_string())
	self.chara_list = chara_list

func set_background_list(background_list: BackgroundList) -> void:
	if background_list == null:
		printerr("背景列表为空")
		return
	print(background_list.to_string())
	self.background_list = background_list

func set_bgm_list(bgm_list: DialogBGMList) -> void:
	if bgm_list == null:
		printerr("BGM列表为空")
		return
	print(bgm_list.to_string())
	self.bgm_list = bgm_list

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
				justenter = false
				print_rich("[color=cyan][b]当前状态：[/b][/color][color=orange]播放状态[/color]")
				if dialog_data == null:
					print_rich("[color=red]对话为空[/color]")
					return
				if dialog_data.dialogs.size() <= 0:
					print_rich("[color=red]对话为空[/color]")
					_dialogue_goto_state(DialogState.OFF)
					return

				# 对话类型
				var dialog_type = dialog_data.dialogs[curline].dialog_type
				# 对话当前句
				var dialog = dialog_data.dialogs[curline]
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
					# 设置角色高亮
					if actor_auto_highlight:
						if chara_id:
							_acting_interface.highlight_actor(chara_id)
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
				# 如果是移动演员
				elif dialog_type == Dialogue.Type.Move_Actor:
					var actor = dialog.target_move_chara
					var pos = dialog.target_move_pos
					var s = _acting_interface.character_moved
					s.connect(_process_next.bind(s))
					_acting_interface.move_actor(actor, pos)
					
					pass
				# 如果是删除演员
				elif dialog_type == Dialogue.Type.Exit_Actor:
					# 删除演员
					var actor = dialog.exit_actor
					var s = _acting_interface.character_deleted
					s.connect(_process_next.bind(s))
					_exit_actor(actor)
					
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
				# 如果是分支对话
				elif dialog_type == Dialogue.Type.Tag:
					print_rich("[color=orange]分支对话[/color]")
					var tag_dialogues: Array[Dialogue] = dialog.branch_dialogue
					var insert_position = curline + 1
					for i in range(tag_dialogues.size()):
						# 检查是否已经存在
						if tag_dialogues[i].dialog_type == Dialogue.Type.Tag:
							print_rich("[color=red]标签对话中不能包含标签对话[/color]")
							continue
						dialog_data.dialogs.insert(insert_position + i, tag_dialogues[i])
					await get_tree().create_timer(0.001).timeout
					
					print("添加了 %d 个标签对话" % tag_dialogues.size())
					print("当前对话总数: " + str(dialog_data.dialogs.size()))

					await get_tree().create_timer(0.01).timeout
					_process_next()
					pass
				# 如果开始对话
				elif dialog_type == Dialogue.Type.START:
					if dialogueState != DialogState.PLAYING:
						_start_dialogue()
					_process_next()
					pass
				# 如果剧终
				elif dialog_type == Dialogue.Type.THE_END:
					# 停止对话
					_stop_dialogue()
					pass
					
		# 完成下一个状态
		DialogState.PAUSED:
			if justenter:
				justenter = false
				print_rich("[color=cyan][b]状态：[/b][/color][color=orange]播放完成状态[/color]")

## 检查是否没有点击到按钮
func is_click_valid(event):
	var excluded_buttons: Array[Button] = [
		_saveButton,
		_loadButton,
		_autoPlayButton,
		_logButton,
		_exitButton
	]
	# 对话选项
	for cbtn in _choicesContainer.get_children():
		var tcbtn = cbtn as Button
		if tcbtn:
			excluded_buttons.append(tcbtn)
	var mouse_pos = event.global_position
	for btn in excluded_buttons:
		var rect = btn.get_global_rect()
		if btn.visible && rect.has_point(mouse_pos):
			# 向下传递
			btn.emit_signal("button_up")
			return false
	return true

## 处理输入
func _input(event):
	if _check_opening() == false:
		_audio_interface.stop_voice()
		return
	if not debug_mode:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				# 全屏点击下一句
				if is_click_valid(event):
					_continue()
		if event is InputEventKey:
			## 对话继续
			if event.pressed and event.keycode == KEY_ENTER:
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
			if curline + 1 >= dialog_data.dialogs.size():
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
	# 打印时间 日期+时间
	print("当前时间：" + str(Time.get_date_string_from_system()) + " " + str(Time.get_time_string_from_system()))
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
			if curline + 1 >= dialog_data.dialogs.size():
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
	_continue()
	pass
	
## 显示对话的方法
func _display_dialogue(chara_id: String, content: String, speed: float) -> void:
	var chara_name: String = "旁白"
	#if chara_id:
		#for chara in chara_list.characters:
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
	var bg_list = background_list.background_list
	var bg_tex: Texture
	for bg in bg_list:
		if bg.background_name == bg_name:
			bg_tex = bg.background_image
			_acting_interface.change_background_image(bg_tex, bg_name, effect)
		else:
			print("背景图片没有找到")
		

## 演员状态切换的方法
func _actor_change_state(chara_id: String, state_id: String):
	var target_chara: Character
	var state_tex: Texture
	for chara in chara_list.characters:
		if chara.chara_name == chara_id:
			target_chara = chara
			for state in chara.chara_status:
				if state.status_name == state_id:
					state_tex = state.status_texture
	_acting_interface.change_actor_state(target_chara.chara_name, state_id, state_tex)

## 从角色列表创建并显示角色
func _display_character(actor: DialogueActor) -> void:
	if actor == null:
		return
	var target_chara: Character
	var target_chara_name = actor.character_name
	for chara in chara_list.characters:
		if chara.chara_name == target_chara_name:
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
	
	# 角色立绘镜像翻转
	var mirror = actor.actor_mirror
	# 创建角色
	_acting_interface.create_new_character(target_chara_name, pos, target_state_name, target_state_tex, a_scale, mirror)
		
## 演员退场
func _exit_actor(actor_name: String) -> void:
	_acting_interface.delete_character(actor_name)

## 播放BGM
func _play_bgm(bgm_name: String) -> void:
	if bgm_name == null:
		return
	var target_bgm: AudioStream
	if bgm_list == null or bgm_list.bgms == null:
		return # 判空
	for bgm in bgm_list.bgms:
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
	if voice_list == null or voice_list.voices == null:
		return # 判空
	for voice in voice_list.voices:
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
	if soundeffect_list == null or soundeffect_list.soundeffects == null:
		return # 判空
	for soundeffect in soundeffect_list.soundeffects:
		if soundeffect.se_name == se_name:
			target_soundeffect = soundeffect.se
			break
	_audio_interface.play_sound_effect(target_soundeffect)
	#同步存档用变量
	se_id = se_name
	pass
## 显示对话选项的方法
func _display_options(choices: Array[DialogueChoice]) -> void:
	_dialog_interface.display_options(choices, null, 22)
	pass

## 选项触发方法
func on_option_triggered(choice: DialogueChoice) -> void:
	_dialogue_goto_state(DialogState.PAUSED)
	_dialog_interface._choice_container.hide()

	print("玩家选择按钮： " + str(choice.choice_text))
	_jump_tag(choice.jump_tag)
	
## 跳转到对话标签的方法
## TODO：应该需要性能优化
func _jump_tag(tag: String) -> void:
	print_rich("跳转到标签： " + str(tag))
	var target_dialogue: Dialogue = dialog_data.branchs[tag]
	if target_dialogue == null:
		print("无法完成跳转，没有这个标签")
		return

	"""
	PS：为啥这么写？因为全屏输入传递会导致选项按钮的信号被连续触发两次导致重复添加对话和跳转
		目前只能用这种很逆天的两次判断的方法来防止重复添加对话，希望以后能找到更好的方法
		如果你想尝试解决这个问题请查看该脚本的_input()函数和is_click_valid()函数，但我不确定问题在哪
	"""
	if not target_dialogue.is_tag_loaded:
		# _jump_cur_dialogue(target_dialogue)
		dialog_data.dialogs.insert(curline + 1, target_dialogue)
		print("插入标签，对话长度" + str(dialog_data.dialogs.size()))
		target_dialogue.is_tag_loaded = true
		_jump_curline(curline + 1)
	# else:
	# 	print("标签已加载和跳转")
		

## 跳转剧情的方法
func _jump_dialog_data(data_id: String) -> bool:
	var jumpdata: DialogueShot
	jumpdata = _get_dialog_data(data_id)
	if jumpdata == null:
		print("无法完成跳转，没有这个剧情")
		return false
	# 切换剧情
	_switch_data(jumpdata)
	print_rich("跳转到：" + str(jumpdata.chapter_name))
	return true

## 寻找指定剧情
func _get_dialog_data(data_id: String) -> DialogueShot:
	print(data_id)
	var target_data: DialogueShot
	for data in dialogue_chapter.dialogue_chapter:
		if data.chapter_id == data_id:
			target_data = data
	return target_data
	
## 切换剧情的方法
func _switch_data(data: DialogueShot) -> bool:
	if not data and data.dialogs.size() > 0:
		return false
	_stop_dialogue()
	print("切换到 " + data.chapter_name + " 剧情文件")
	dialog_data = data
	_init_dialogue()
	await get_tree().create_timer(0.01).timeout
	_start_dialogue()
	return true
	
## 按下存档按钮
func _on_savebutton_press():
	_SaL_UI.check_UI(1) # 打开UI，输入存档格式
	pass

func _get_file_data(slot_id: int):
	#用于获取变量
	var dialog = dialog_data.dialogs[curline]
	
	# 停止语音
	_audio_interface.stop_voice()
	
	#更新变量
	KS_SAVE_AND_LOAD.chara_disc = _acting_interface.actor_dict
	KS_SAVE_AND_LOAD.background_id = _acting_interface.background_id
	KS_SAVE_AND_LOAD.chapter_id = dialog_data.chapter_id
	KS_SAVE_AND_LOAD.bgm_id = _audio_interface.bgm_name
	KS_SAVE_AND_LOAD.bgm_progress = str("%.2f"%_audio_interface.get_bgm_progress()) # 保留两位小数
	KS_SAVE_AND_LOAD.voice_id = dialog.voice_id
	KS_SAVE_AND_LOAD.sound_effect_id = se_id
	KS_SAVE_AND_LOAD.curline = curline
	
	#触发函数
	KS_SAVE_AND_LOAD._save_game(slot_id)

## 按下读档按钮
func _on_loadbutton_press():
	_SaL_UI.check_UI(2) # 打开UI，输入读档格式
	pass

func _load_file_data(slot_id: int):
	#用于获取变量
	var dialog = dialog_data.dialogs[curline]
	
	if KS_SAVE_AND_LOAD._load_game(slot_id) == true: # 确认文件存在
		#更新变量
		_acting_interface.actor_dict = KS_SAVE_AND_LOAD.chara_disc
		_acting_interface.background_id = KS_SAVE_AND_LOAD.background_id
		dialog_data.chapter_id = KS_SAVE_AND_LOAD.chapter_id
		_audio_interface.bgm_name = KS_SAVE_AND_LOAD.bgm_id
		#音频进度在下列函数中直接调用，不在这里同步
		dialog.voice_id = KS_SAVE_AND_LOAD.voice_id
		se_id = KS_SAVE_AND_LOAD.sound_effect_id
		curline = KS_SAVE_AND_LOAD.curline
		
		#跳转剧情，更新背景
		jump_data_and_curline(dialog_data.chapter_id, curline, _audio_interface.bgm_name, _acting_interface.actor_dict)
		_display_background(_acting_interface.background_id, ActingInterface.EffectsType.None)
		
		#同步音乐播放进度
		_audio_interface.stop_bgm()
		_audio_interface.bgm_player.seek(float(KS_SAVE_AND_LOAD.bgm_progress))
		_audio_interface.bgm_player.play()
		
		# 停止并更新语音
		_audio_interface.stop_voice()
		_play_voice(dialog.voice_id)
		
		#播放音效（停止音效的方法包含在这个方法里了
		_play_soundeffect(se_id)
	else:
		pass
		print("文件不存在")

#检测是否有任何窗口打开
func _check_opening() -> bool:
	if _SaL_UI.All_UI.visible == true:
		return false
	else:
		return true

## 读取存档用的跳转
func jump_data_and_curline(data_id: String, _curline: int, bgm_id: String, actor_dict: Dictionary = {}):
	print("对话ID" + data_id + "   对话线" + str(_curline) + "   角色表：" + str(actor_dict))
	if debug_jump_data(data_id):
		_play_bgm(bgm_id)
		_jump_curline(_curline)
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
	dic["chapter_name"] = dialog_data.chapter_name
	dic["chapter_id"] = dialog_data.chapter_id
	dic["curline"] = curline
	return dic

## 跳转到对话
func _jump_curline(value: int) -> bool:
	if value >= 0:
		if not value >= dialog_data.dialogs.size():

			_acting_interface.delete_all_character()
			# 遍历演员操作相关的对话到当前行
			# 临时先这么写吧，以后再优化，目前不崩就行~

			for i in value:
				var dialog = dialog_data.dialogs[i]
				var dialog_type = dialog.dialog_type
				# if dialog.dialog_type == Dialogue.Type.Display_Actor:
				# 	_display_character(dialog.show_actor)
				# if dialog.dialog_type == Dialogue.Type.Move_Actor:
				# 	_acting_interface.move_actor(dialog.target_move_chara, dialog.target_move_pos)
				# if dialog.dialog_type == Dialogue.Type.Exit_Actor:
				# 	_exit_actor(dialog.exit_actor)
				# if dialog.dialog_type == Dialogue.Type.Actor_Change_State:
				# 	_actor_change_state(dialog.change_state_actor, dialog.change_state)
				
				# 如果是显示演员
				if dialog_type == Dialogue.Type.Display_Actor:
					# 显示演员
					var actor = dialog.show_actor
					_display_character(actor)
					# 创建定时器，不加这个给我来千手观音是吧
					# Godot没有同步真的很难蚌
					await get_tree().create_timer(0.01).timeout
					pass
				# 如果修改演员状态
				if dialog_type == Dialogue.Type.Actor_Change_State:
					var actor = dialog.change_state_actor
					var target_state = dialog.change_state
					_actor_change_state(actor, target_state)
					await get_tree().create_timer(0.01).timeout
					pass
				# 如果是移动演员
				if dialog_type == Dialogue.Type.Move_Actor:
					var actor = dialog.target_move_chara
					var pos = dialog.target_move_pos
					_acting_interface.move_actor(actor, pos)
					await get_tree().create_timer(0.01).timeout
					pass
				# 如果是删除演员
				if dialog_type == Dialogue.Type.Exit_Actor:
					# 删除演员
					var actor = dialog.exit_actor
					_exit_actor(actor)

					await get_tree().create_timer(0.01).timeout
					pass
			_dialogue_goto_state(DialogState.OFF)
			curline = value
			print_rich("跳转到：" + str(curline))
			_dialogue_goto_state(DialogState.PLAYING)
			return true
	return false

## 跳转到对话
func _jump_cur_dialogue(dialog: Dialogue) -> bool:
	if dialog != null:
		_dialogue_goto_state(DialogState.OFF)
		# 还没有实现
		_dialogue_goto_state(DialogState.PLAYING)
		return true
	return false

## 调试模式跳转到章节
func debug_jump_data(value: String) -> bool:
	var error = _jump_dialog_data(value)
	return error
	
## 调试模式获取信息
func debug_get_info() -> String:
	var info = "章节ID：" + str(dialog_data.chapter_id) \
	+"  章节：" + str(dialog_data.chapter_name) \
	+"  对话行：" + str(curline) \
	+"  状态：" + str(dialogueState)
	return info


## 获取当前对话帧信息
func debug_get_dialogue_frame_info() -> String:
	var chapter_id = dialog_data.chapter_id
	var dialogue_id = curline
	var dialogue_type = dialog_data.dialogs[curline].dialog_type
	
	var info = "当前对话帧" + str(dialogue_id) \
	+"  对话类型：" + str(dialogue_type) \
	+"  章节ID：" + str(chapter_id)
	return info
	
	
## 调试获取章节列表
func debug_get_dialog_data_list() -> Array[String]:
	var data_array: Array[String]
	for data in dialogue_chapter.dialogue_chapter:
		data_array.append(data._dialog_data.chapter_id)
	return data_array

## 调试加载外部剧情
func debug_load_dialog_data(data) -> bool:
	var error = await _switch_data(data)
	return error

## 退出节点
func _exit_tree():
	if not is_in_editor_and_idle():
		_stop_dialogue()
	pass
