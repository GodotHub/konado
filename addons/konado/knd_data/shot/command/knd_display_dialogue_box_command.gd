@tool
extends KND_Command
class_name KND_DisplayDialogueBoxCommand

## 显示对话框指令

func _init() -> void:
	type = Type.DISPLAY_DIALOGUE_BOX
	wait_trigger = false

func execute(dialogue_manager: KonadoDialogueManager, callback: Callable) -> void:
	dialogue_manager.process_show_dialogue_box(callback, true)
	pass
