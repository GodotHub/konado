## Konado对话指令
@tool
extends Resource
class_name KND_Command

enum Type {
# 对话框
	DISPLAY_DIALOGUE_BOX,
	HIDE_DIALOGUE_BOX,
# 文字
	DISPLAY_TEXT,
# 角色
	DISPLAY_CHARACTER,
	CHANGE_CHARACTER_STATE,
	MOVE_CHARACTER,
	EXIT_CHARACTER,
# 背景
	DISPLAY_BACKGROUND,
	EXIT_BACKGROUND,
	CHANGE_BACKGROUND,
	MOVE_BACKGROUND,
# 音频
	PLAY_BGM,
	STOP_BGM,
	PLAY_SFX,
# 分支
	OPTION_BRANCH,
	CONDITIONAL_BRANCH,
# 变量操作
	OPERATE_VARIABLE,
# 定时器
	TIMER
}

## 指令类型
@export var type: Type

## 是否等待触发
@export var wait_trigger: bool = true

# 演员快照
@export var actor_snapshots: Dictionary = {}

# 背景快照
@export var background_snapshots: Dictionary = {}

## 执行，执行完毕会调用callback并传入执行结果，true或者是false
func execute(dialogue_manager: KonadoDialogueManager, callback: Callable) -> void:
	push_error("子类必须实现 execute()")
	if callback:
		callback.call(false)
