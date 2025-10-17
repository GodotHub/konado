## 显示角色指令
@tool
extends KND_Command
class_name KND_DisplayCharacterCommand


func _init() -> void:
    type = Type.DISPLAY_CHARACTER
    wait_trigger = false

func execute(dialogue_manager: KND_DialogueManager, callback: Callable) -> void:
    pass
