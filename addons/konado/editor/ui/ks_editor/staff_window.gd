extends Window
## 角色演员对照表弹窗


const STAFF_COMPONENT = preload("uid://bybbh76d07hoo")       ## 角色演员对照组件
@onready var staff_container: BoxContainer = %StaffContainer ## 角色演员表容器

@export var char_arctor_list:CharacterList  ## 角色表

## 添加演员标签
func _on_add_act_pressed() -> void:
	var staff = STAFF_COMPONENT.instantiate()
	staff_container.add_child(staff)
	staff.delete_request.connect(staff_container_delete_request)
	print("添加演员")

## 删除演员
func staff_container_delete_request(actor):
	_actor_remove(actor)

## TODO 删除演员,删除当前ks文件的演员数据
## 检测演员是否被使用，弹出警告窗口
func _actor_remove(actor):
	pass

func _on_close_requested() -> void:
	self.hide()
