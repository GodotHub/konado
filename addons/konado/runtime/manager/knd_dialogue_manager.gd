### 对话管理器
@tool
extends Control
class_name KND_DialogueManager

signal current_command_executed(success: bool)

## 是否自动开始对话
@export var auto_start: bool = true

## 是否跳过错误
@export var skip_error: bool = false

## 是否等待
@export var awaiting: bool = false

## 当前镜头
@export var current_shot: KND_Shot = null

## 当前指令索引下标
@export var current_command_index: int = 0

## 当前指令
@export var current_command: KND_Command = null

## 对话框
@export var dialogue_box: KND_DialogueBox

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
@export_tool_button("初始化对话", "Callable")
var init_action = self.init_dialogue

func _ready() -> void:
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
