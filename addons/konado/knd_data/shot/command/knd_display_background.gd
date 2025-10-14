## 显示背景指令
@tool
extends KND_Command
class_name KND_Display_Background


func _init() -> void:
	self.type = Type.DISPLAY_BACKGROUND
    wait_trigger = false

func execute(dialogue_manager: KND_DialogueManager, callback: Callable) -> void:
	pass
