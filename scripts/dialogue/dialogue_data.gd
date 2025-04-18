extends Resource
class_name DialogueData

## 对话数据类，包含章节名称和对话列表
# 章节ID
@export var chapter_id: String
# 章节名称
@export var chapter_name: String
# 对话列表
@export var dialogs: Array[Dialogue] = []
