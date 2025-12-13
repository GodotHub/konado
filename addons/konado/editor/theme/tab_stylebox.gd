#@tool
#class_name TabStylebox
extends StyleBox
#
#@export var line_width:= 0:
	#set(value):
		#line_width =  clamp(value,0,80)
		#changed.emit()
#
#@export var line_color:= Color(0.2,0.2,0.2)
#@export var bg_color      := Color(0.2,0.2,0.2):
	#set(value):
		#bg_color = value
		#changed.emit()
#@export var radius_top    := 15: ## 上倒角半径
	#set(value):
		#radius_top =  clamp(value,0,80)
		#changed.emit()
#@export var radius_bottom := 30: ## 下倒角半径
	#set(value):
		#radius_bottom =  clamp(value,0,80)
		#changed.emit()
#@export var content_top   := 8 : ## 顶部间隙
	#set(value):
		#content_top =  clamp(value,0,80)
		#changed.emit()
#func _init() -> void:
	#content_margin_left  = radius_top + radius_bottom
	#content_margin_right = radius_top + radius_bottom
#
#func _draw(rid: RID, rect: Rect2) -> void:
	#var points : PackedVector2Array # 点集合
	#var curve  := Curve2D.new()
	#var pos    := rect.position
	#var size   := rect.size 
	#var _radius_bottom = radius_bottom 
	#var _radius_top = radius_top
	#var _content_top = content_top 
	#
	#var b_width = radius_bottom + radius_top + content_top
	#if b_width > size.y:
		#_radius_bottom  = radius_bottom * rect.size.y /b_width 
		#_radius_top  = radius_top  * rect.size.y /b_width 
		#_content_top = content_top * rect.size.y /b_width
	#
	## 第一段
	#curve.bake_interval=8
#
	#curve.add_point(Vector2(pos.x,size.y), Vector2.ZERO, Vector2(_radius_bottom,0))
	#curve.add_point(Vector2(pos.x+_radius_bottom,size.y-_radius_bottom),
		#Vector2(0,_radius_bottom),
		#Vector2.ZERO
		#)
	#points = curve.get_baked_points()
	#curve.clear_points()
	## 第二段
	#curve.add_point(Vector2(pos.x+_radius_bottom ,_content_top+_radius_top),
		#Vector2.ZERO,
		#Vector2(0,-_radius_top))
	#curve.add_point(Vector2(pos.x+_radius_bottom + _radius_top , _content_top),Vector2(-_radius_top,0))
	#points.append_array(curve.get_baked_points())
	#curve.clear_points()
	## 第三段
	#curve.add_point(Vector2(pos.x+size.x - _radius_bottom - _radius_top ,_content_top),
		#Vector2.ZERO,
		#Vector2(_radius_top,0))
	#curve.add_point(Vector2(pos.x+size.x - _radius_bottom ,_content_top+_radius_top),Vector2(0,-_radius_top))
	#points.append_array(curve.get_baked_points())
	#curve.clear_points()
	## 第四段
	#curve.add_point(Vector2(pos.x+size.x - _radius_bottom ,size.y - _radius_bottom),Vector2.ZERO,Vector2(0,_radius_bottom))
	#curve.add_point(pos+size,Vector2(-_radius_bottom,0))
	#points.append_array(curve.get_baked_points())
	#curve.clear_points()
	##for point in points:
		##RenderingServer.canvas_item_add_circle(rid,point,2,Color.ALICE_BLUE)
	#RenderingServer.canvas_item_add_polygon(rid,points,PackedColorArray([bg_color]))
	#if line_width != 0:
		#RenderingServer.canvas_item_add_polyline(rid,points,PackedColorArray([line_color]),line_width)
