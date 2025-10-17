extends KonadoScript

func _ready() -> void:
    print("br", choice_coffee)
    print("cs", commands)

## 分支对话区

var choice_coffee: Array = [
    display_text("Test shot script", "Test shot script"),
    display_text("Test shot script", "Test shot script")
]

var choice_tea: Array = [
    display_text("Test shot script", "Test shot script"),
    display_text("Test shot script", "Test shot script")
]

## 分支对话区

## 主命令区
func _main_commands() -> void:
    display_text("Test shot script", "Test shot script")
    display_text("Test shot script", "Test shot script")
    show_background("background")
    option_branch({
        "选项1": choice_coffee,
        "选项2": choice_tea
        })
    

    