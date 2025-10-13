@tool
extends KND_Command
class_name KND_Timer_Command

## 计时器等待秒数
@export var wait_seconds: float = 0.0

func execute(dialogue_manager: KND_DialogueManager, callback: Callable) -> void:
	var timer =  dialogue_manager.get_tree().create_timer(wait_seconds, false)
	if timer:
		await timer.timeout
		if callback:
			callback.call(true)
		return
	if callback:
		callback.call(false)
