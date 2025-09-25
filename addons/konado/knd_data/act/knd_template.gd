@tool
extends KND_Data
class_name KND_Template
## 模板数据

## 模板类型
enum TEMPLATE_TYPE{CHARACRER,BACKGROUND,DIALOGUE}
@export var name := "新模板"

@export var template_type : = TEMPLATE_TYPE.CHARACRER

## 模板文件路径
@export var path :String = ""
