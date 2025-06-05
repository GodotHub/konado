extends Control

class_name ItemInterface

#TODO：测试用路径，应该改成从接口那边获取文件信息。
##并且，改完后要删掉文件夹里的测试文件！
var item_datas : ItemDatas = load("res://addons/konado/scripts/items/test_item.tres")

#管理用节点
@onready var item_controller := $ItemControl

#储存用词典
var item_inf_dic : Dictionary = {
	"item_id" : "ID",
	"item_texture" : TextureRect,
	"item_origin_position" : Vector2(0,0),
	"item_stay_position" : Vector2(0,1),
	"item_target_position" : Vector2(0,1),
	"item_origin_trans" : 1,
	"item_stay_trans" : 1,
	"item_target_trans" : 1,
	"item_anime_time_in" : 1,
	"item_anime_time_out" : 1,
	"item_zoom" : Vector2(1,1)
}

func _ready() -> void:
	#get_information()#更新信息
	#summon_item()
	#以上两句是测试用
	pass

#TODO：从资源中获取信息，后续需要调整成从接口那边获取指定道具的资源文件
func get_information():
	item_inf_dic.item_id = item_datas.item_id
	item_inf_dic.item_texture = item_datas.item_texture
	item_inf_dic.item_zoom = item_datas.item_zoom
	
	item_inf_dic.item_origin_position = item_datas.item_origin_position
	item_inf_dic.item_stay_position = item_datas.item_stay_position
	item_inf_dic.item_target_position = item_datas.item_target_position
	
	item_inf_dic.item_origin_trans = item_datas.item_origin_transparency
	item_inf_dic.item_stay_trans = item_datas.item_stay_transpasrency
	item_inf_dic.item_target_trans = item_datas.item_target_transparency
	
	item_inf_dic.item_anime_time_in = item_datas.item_anime_time_in
	item_inf_dic.item_anime_time_out = item_datas.item_anime_time_out


#生成道具
func summon_item():
	#准备创建节点
	var item_spirit := TextureRect.new()
	#节点信息
	item_spirit.name = item_inf_dic.item_id
	item_spirit.texture = item_inf_dic.item_texture
	item_spirit.scale = item_inf_dic.item_zoom
	item_spirit.position = item_inf_dic.item_origin_position
	item_spirit.modulate.a= item_inf_dic.item_origin_trans

	#创建节点
	item_controller.add_child(item_spirit)
	#测试用：提供需要移动的道具id就可以
	#moving_in_tween(item_inf_dic.item_id)

#从初始位置移动到停留位置
func moving_in_tween(target_item : String):
	var moving_in_tween = get_tree().create_tween()#创建tween
	var target_object := get_node("ItemControl/" + target_item)#寻找指定道具路径
	#移动
	moving_in_tween.tween_property(target_object, "position", item_inf_dic.item_stay_position, item_inf_dic.item_anime_time_in)

#从停留位置移动到退场位置，并删除节点
func moving_out_tween(target_item : String):
	var moving_out_tween = get_tree().create_tween()#创建tween
	var target_object := get_node("ItemControl/" + target_item)#寻找指定道具路径
	#移动
	moving_out_tween.tween_property(target_object, "position", item_inf_dic.item_target_position, item_inf_dic.item_anime_time_out)
	#动画后删除节点
	moving_out_tween.tween_callback(queue_free)

#淡入
func trans_in(target_item : String):
	var trans_in_tween = get_tree().create_tween()
	var target_object := get_node("ItemControl/" + target_item)#寻找指定道具路径
	#淡入
	trans_in_tween.tween_property(target_object,"modulate:a",item_inf_dic.item_stay_trans,item_inf_dic.item_anime_time_in)

#淡出，并删除节点
func trans_out(target_item : String):
	var trans_out_tween = get_tree().create_tween()
	var target_object := get_node("ItemControl/" + target_item)#寻找指定道具路径
	#淡出
	trans_out_tween.tween_property(target_object,"modulate:a",item_inf_dic.item_target_trans,item_inf_dic.item_anime_time_out)
	#动画后删除节点
	trans_out_tween.tween_callback(queue_free)
