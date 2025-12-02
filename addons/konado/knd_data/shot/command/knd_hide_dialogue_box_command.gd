@tool
extends KND_Command
class_name KND_HideDialogueBoxCommand

## 隐藏对话框指令

func _init() -> void:
	type = Type.HIDE_DIALOGUE_BOX
	wait_trigger = false

func execute(dialogue_manager: NeoKonadoDialogueManager, callback: Callable) -> void:
	dialogue_manager.process_hide_dialogue_box(callback, true)
	pass
