## 计时器指令
@tool
extends KND_Command
class_name KND_TimerCommand

## 计时器等待秒数
@export var wait_seconds: float = 0.0

func _init() -> void:
	self.type = Type.TIMER
	wait_seconds = 1.0
	wait_trigger = false

func execute(dialogue_manager: NeoKonadoDialogueManager, callback: Callable) -> void:
	var timer =  dialogue_manager.get_tree().create_timer(wait_seconds, false)
	if timer:
		await timer.timeout
		if callback:
			callback.call(true)
		return
	if callback:
		callback.call(false)
