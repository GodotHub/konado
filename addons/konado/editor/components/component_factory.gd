extends Node
## 节点工厂
var node_menu:=PopupMenu.new() # 添加列表弹窗
var EDITOR_CONFIG := {  ## 编辑器配置 
	"component_editor": { ## 节点编辑器
		"演员": {
			"scene": "uid://tgcygvvajaui",
		},
		"场景": {
			"scene": "",
		},
		"跳转到": {
			"scene": "",
		},
	},
	"data_new": {
		
	}
}

## 添加角色
func add_character(template_id:int,character_id:int,status_id:int,avatar:bool=false):
	pass
