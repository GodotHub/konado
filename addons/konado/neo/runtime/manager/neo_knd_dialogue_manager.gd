extends Control
class_name NeoKonadoDialogueManager

## Konado对话管理器，用于播放指定的KND_Shot镜头数据，并执行镜头中的指令

## 当前对话执行完成的回调
signal current_command_executed(success: bool)

## 对话角色模板
const CHARACTER_TEMPLATE: PackedScene = preload("uid://dcwk5so2ohcc2")

@onready var character_parent_node: Node = $"../character"

@onready var dialogue_box: KND_DialogueBox = $"../​DialogBox/​DialogBox2"

@export_group("对话配置")
## 是否自动开始对话
@export var auto_start: bool = true

## 是否跳过错误
@export var skip_error: bool = false

## 是否等待
@export var awaiting: bool = false

@export_group("镜头数据")

## 预设镜头
@export var preset_shots: Dictionary[String, KND_Shot]


## 当前镜头
@export var current_shot: KND_Shot = null

@export_group("信息")
## 当前指令索引下标
@export var current_command_index: int = 0

## 当前指令
@export var current_command: KND_Command


## 当前角色字典，key为角色ID，value为角色实例
@export var current_characters_map: Dictionary[String, KonadoDialogueCharacter] = {}


## 对话状态
enum State {
	## 关闭，什么都不做
	STOP,
	## 播放中
	PLAYING,
	## 暂停，当前指令播放完成后应该切换到该状态
	PAUSED
}

## 状态
@export var state: State = State.STOP

## 有个坑，必须重新加载tools脚本
#@export_tool_button("初始化对话", "Callable")
var init_action = self.init_dialogue

func _ready() -> void:
	if current_shot == null:
		return
	if current_shot.commands.size() <= 0:
		printerr("对话指令为空")
		return
	init_dialogue()
	if auto_start:
		start_dialogue()
	pass


func _process(delta: float) -> void:
	if awaiting:
		return
	awaiting = true
	match state:
		State.STOP:
			return
		State.PLAYING:
			current_command = current_shot.commands[current_command_index]
			if current_command:
				# 执行对话命令
				current_command.execute(self, execution_completed)
			return
		State.PAUSED:
			return
			
			
## 初始化对话，重置所有变量
func init_dialogue() -> void:
	current_command = null
	state = State.STOP
	current_command_index = 0
	pass
			
## 开始播放对话
func start_dialogue() -> void:
	switch_state(State.PLAYING)
	awaiting = false
	
func stop_dialogue() -> void:
	switch_state(State.STOP)
	awaiting = false
	
## 重播，从当前指令开始重播
func replay() -> void:
	if current_command:
		current_command.execute(self, execution_completed)
	pass

## 切换状态
## STOP -> PLAYING -> PAUSED
## PAUSED -> PLAYING
## PLAYING -> PAUSED
## PAUSED -> STOP
func switch_state(new_state: State) -> void:
	if state == new_state:
		printerr("状态相同，无需切换状态")
		return
	if state == State.STOP:
		if new_state == State.PAUSED:
			printerr("不允许从STOP状态切换至PAUSED状态，请先切换至PLAYING状态")
			return
	if state == State.PLAYING:
		if new_state == State.STOP:
			printerr("不允许从PLAYING状态切换到STOP状态，请先等待切换到PAUSED状态")
			return
	state = new_state
	
	print("状态切换为 " + str(State.keys()[state]))
	
	
## 执行完毕
func execution_completed(success: bool) -> void:
	switch_state(State.PAUSED)
	current_command_executed.emit(success)
	
	if not success and not skip_error:
		push_error("当前指令执行失败")
		return
	
	if not current_command_index + 1 < current_shot.commands.size():
		switch_state(State.STOP)
		return
	current_command_index += 1
	## 如果不需要等待触发
	if current_command.wait_trigger == false:
		start_dialogue()
	pass

#region 角色相关

## 显示角色
## name: 角色名称
## division: 分区数
## pos: 角色位置，[0, division]
## callback: 回调
func process_display_character(name: String, texture: Texture, division: int, pos: int, scale: float, callback: Callable) -> void:
	print("显示角色 " + name + " " + str(pos))
	## 从模板中克隆一个角色
	var character = CHARACTER_TEMPLATE.instantiate() as KonadoDialogueCharacter
	character.visible = false
	character.use_tween = false
	character.set_character_texture(texture)
	character.set_texture_scale(scale)
	character.division = division
	character.character_position = pos
	character_parent_node.add_child(character)
	# 必须先设置位置，否则位置会不对
	character._on_resized()
	character.visible = true

	if callback:
		callback.call(true)

## 隐藏角色
func process_exit_character(name: String, callback: Callable) -> void:
	print("隐藏角色 " + name)
	var character = get_node("KonadoDialogueCharacter") as KonadoDialogueCharacter
	if character:
		character.visible = false
		if callback:
			callback.call(true)
	pass


## 移动角色
func process_move_character(name: String, division: int, pos: int, callback: Callable) -> void:
	print("移动角色 " + name + " " + str(pos))
	var character = get_node("KonadoDialogueCharacter") as KonadoDialogueCharacter
	if character:
		character.character_position = pos
		character.division = division
		if callback:
			callback.call(true)
	pass
	
#endregion

#region 对话框相关

## 显示对话框
func process_show_dialogue_box(callback: Callable, anim: bool = false) -> void:
	print("显示对话框")
	
	if anim:
		# 初始状态
		dialogue_box.modulate = Color(1, 1, 1, 0)  # 完全透明
		dialogue_box.show()
		
		# 创建动画补间
		var tween = create_tween()
		# 淡入 + 缩放
		tween.tween_property(dialogue_box, "modulate", Color(1, 1, 1, 1), 2.3)
		# 动画完成后调用回调
		tween.finished.connect(func():
			callback.call(true)
		)
	else:
		dialogue_box.show()
		callback.call(true)
	
## 隐藏对话框
func process_hide_dialogue_box(callback: Callable, anim: bool = false) -> void:
	print("隐藏对话框")
	
	if anim:
		# 创建动画补间
		var tween = create_tween()
		# 淡出 + 缩放缩小
		tween.tween_property(dialogue_box, "modulate", Color(1, 1, 1, 0), 0.2)
	
		# 动画完成后隐藏并调用回调
		tween.finished.connect(func():
			dialogue_box.hide()
			# 重置状态（避免下次显示时状态不对）
			dialogue_box.modulate = Color(1, 1, 1, 1)
			callback.call(true)
		)
	else:
		dialogue_box.hide()
		callback.call(true)
	
#endregion
