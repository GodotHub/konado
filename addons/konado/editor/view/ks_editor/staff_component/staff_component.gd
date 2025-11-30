# @tool
extends BoxContainer
# ## 角色 演员 对照组件

# signal delete_request(arctor)
# signal actor_renamed()
# signal character_selected()

# ## TODO : 实现功能按钮
# ## 角色标签
# @onready var delect         : Button   = $delect         ## 删除按钮
# @onready var actor_name     : LineEdit = %actor_name
# @onready var character_label: OptionButton = %CharacterLabel

# ## 导出数据
# @export var actor:String ="":  ## 演员名称
# 	set(value):
# 		if actor != value:
# 			actor = value
# 			if actor_name:
# 				actor_name.text = value
# @export var character:int      ## 角色id
# var character_lise

# func _on_delect_pressed() -> void:
# 	delete_request.emit(self)

# ## 刷新
# func _on_character_label_pressed() -> void:
# 	character_label.clear()
# 	character_lise = KND_Database.get_data_list("KND_Character")
# 	for i in character_lise.size():
# 		character = character_lise[i]
# 		var charactor_name = KND_Database.get_data_property(character,"name")
# 		character_label.add_item(charactor_name)

# ## 选择角色
# func _on_character_label_item_selected(id: int) -> void:
# 	character = character_lise[id]
	
