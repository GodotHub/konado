extends Resource

class_name ItemDatas

@export var item_id : String#道具ID，代码用
@export var item_texture : Texture#道具图片，大小自定
@export var item_zoom : Vector2 = Vector2(1,1)#道具缩放比例

@export var item_origin_position : Vector2 = Vector2(-45,300)#道具初始位置，你想要它生成的位置
@export var item_stay_position : Vector2#道具停留位置，结束入场动画时的位置
@export var item_target_position : Vector2#道具退场位置，从停留位置移动到这个位置后退场

@export var item_origin_transparency : float = 1#道具初始透明度
@export var item_stay_transpasrency : float = 1#道具停留透明度
@export var item_target_transparency: float = 1#道具目标透明度

@export var item_anime_time_in : float = 0#道具入场动画时间，结合你填的距离自己算速度
@export var item_anime_time_out : float = 0#道具离场动画时间


enum anime_styles{#动画类型
	none,#无
	fade_in_and_out,#淡入淡出
	from_left_to_right,#从左到右
	from_top_to_bottom#从上到下
}
