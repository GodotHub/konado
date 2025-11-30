## 显示角色指令
@tool
extends KND_Command
class_name KND_DisplayCharacterCommand


@export var character_name: String = ""
@export var character_texture: Texture2D = null
@export var division: int = 3
@export var pos: int = 2
@export var scale: float = 1.0



func _init() -> void:
	type = Type.DISPLAY_CHARACTER
	wait_trigger = false

func execute(dialogue_manager: KonadoDialogueManager, callback: Callable) -> void:
	dialogue_manager.process_display_character(character_name, character_texture, division, pos, scale, callback)
