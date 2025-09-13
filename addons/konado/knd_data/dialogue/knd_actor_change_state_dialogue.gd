@tool
extends KND_Dialogue
class_name KND_Actor_Change_State_Dialogue


## 要修改的演员
@export var change_state_actor: String:
    set(value):
        if change_state_actor != value:
            change_state_actor = value
            emit_changed()
            gen_source_data()

## 目标状态
@export var change_state: String:
    set(value):
        if change_state != value:
            change_state = value
            emit_changed()
            gen_source_data()