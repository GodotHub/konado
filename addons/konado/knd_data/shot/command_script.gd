@abstract
extends Node
class_name KonadoScript

var commands: Array = []


func _init() -> void:
    _main_commands()

func _ready() -> void:
    pass

## 主命令区
@abstract
func _main_commands() -> void;

func display_text(name: String, text: String) -> KND_DisplayTextCommand:
    var command = KND_DisplayTextCommand.new()
    command.character_name = name
    command.dialogue_text = text

    commands.append(command)
    return command

func show_background(background: String) -> KND_Display_Background:
    var command = KND_Display_Background.new()
    return command

func option_branch(options: Dictionary[String, Array]) -> KND_Command:
    var command = KND_Command.new()
    return command
    pass