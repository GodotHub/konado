extends Control
class_name ActingInterface
## 表演管理器

## 特效种类
enum EffectsType{
	None, ## 无效果
	EraseEffect, ## 擦除效果
	BlindsEffect, ## 百叶窗效果
	WaveEffect, ## 波浪效果
	FadeInAndOut ## 淡入淡出
	}
## 当前背景
var current_texture: Texture = Texture.new()
## 特效路径
var none_effect_shader: Shader = preload("res://addons/konado/shader/Transition/None.gdshader")
var erase_effect_shader: Shader = preload("res://addons/konado/shader/Transition/EraseEffect.gdshader")
var blinds_effect_shader: Shader = preload("res://addons/konado/shader/Transition/BlindsEffect.gdshader")
var wave_effect_shader: Shader = preload("res://addons/konado/shader/Transition/WaveEffect.gdshader")
var fade_in_and_out_shader: Shader = preload("res://addons/konado/shader/Transition/FadeInAndOut.gdshader")
## 演员字典
var actor_dict = {}
## 角色列表
var chara_list: CharacterList
## 背景图片
@onready var _background: ColorRect = $BackgroundLayer
## 角色容器
@onready var _chara_controler: Control = $BackgroundLayer/CharaControl
## 效果层
@onready var _effect_layer: ColorRect = $EffectLayer
## 完成背景切换的信号
signal background_change_finished
## 完成角色创建的信号
signal character_created
## 完成角色删除的信号
signal character_deleted
## 完成角色切换状态的信号
signal character_state_changed
## 完成角色移动的信号
signal character_moved
## 演员位置预设（左）
@export var LEFT_POS: Vector2 = Vector2(175, 113)
## 演员位置预设（中）
@export var CENTER_POS: Vector2 = Vector2(620, 113)
## 演员位置预设（右）
@export var RIGHT_POS: Vector2 = Vector2(1105, 113)
# Tween效果动画节点
var effect_tween: Tween
#存档用背景id
var background_id : String

func _ready():
	for child in _chara_controler.get_children():
		child.queue_free()

## 获取角色节点的方法
func get_chara_node(actor_id: String) -> Node:
	# 检查要删除的角色是否在容器和字典中
	for actor in actor_dict.values():
		# 如果在容器中
		if actor["id"] == actor_id:
			var chara_controler_node = _chara_controler
			# 获取角色节点
			var chara_node: Node = chara_controler_node.find_child(actor_id, true, false)
			return chara_node
	return null
			
# 显示背景图片的方法，有切换特效
func change_background_image(tex: Texture, name: String, effects_type: EffectsType = EffectsType.None) -> void:
	if tex:
		background_id = name
		print_rich("[color=cyan]切换背景为: [/color]"+str(name))
		# 无效果
		if effects_type == EffectsType.None:
			#var mat = ShaderMaterial.new()
			var mat = _background.material
			mat.shader = none_effect_shader
			_background.material = mat
			# 需要先初始化值
			mat.set_shader_parameter("target_switch_texture", tex)
			current_texture = tex
		# 消除过渡效果
		elif effects_type == EffectsType.EraseEffect:
			#var mat = ShaderMaterial.new()
			var mat = _background.material
			mat.shader = erase_effect_shader
			_background.material = mat
			# 需要先初始化值
			mat.set_shader_parameter("switch_progress", 0.0)
			mat.set_shader_parameter("current_texture", current_texture)
			mat.set_shader_parameter("target_switch_texture", tex)
			if effect_tween:
				effect_tween.kill()
			var effect_tween = get_tree().create_tween()
			effect_tween.tween_property(mat, "shader_parameter/switch_progress", 2.4, 1.2).set_trans(Tween.TRANS_LINEAR)			
			#effect_tween.tween_property(mat, "")
			effect_tween.play()
			effect_tween.finished.connect(func():
				print("背景过渡动画完成")
				current_texture = tex
				mat.set_shader_parameter("current_texture", current_texture)
				effect_tween.kill())
		# 百叶窗过渡效果
		elif effects_type == EffectsType.BlindsEffect:
			#var mat = ShaderMaterial.new()
			var mat = _background.material
			mat.shader = blinds_effect_shader
			_background.material = mat
			# 需要先初始化值
			mat.set_shader_parameter("switch_progress", 0.5)
			mat.set_shader_parameter("current_texture", current_texture)
			mat.set_shader_parameter("target_switch_texture", tex)
			if effect_tween:
				effect_tween.kill()
			var effect_tween = get_tree().create_tween()
			effect_tween.tween_property(mat, "shader_parameter/switch_progress", 1.5, 1.2).set_trans(Tween.TRANS_LINEAR)			
			#effect_tween.tween_property(mat, "")
			effect_tween.play()
			effect_tween.finished.connect(func():
				print("背景过渡动画完成")
				current_texture = tex
				mat.set_shader_parameter("current_texture", current_texture)
				effect_tween.kill())
		# 波浪过渡效果
		elif effects_type == EffectsType.WaveEffect:
			#var mat = ShaderMaterial.new()
			var mat = _background.material
			mat.shader = wave_effect_shader
			_background.material = mat
			# 需要先初始化值
			mat.set_shader_parameter("switch_progress", 0.0)
			mat.set_shader_parameter("current_texture", current_texture)
			mat.set_shader_parameter("target_switch_texture", tex)
			if effect_tween:
				effect_tween.kill()
			var effect_tween = get_tree().create_tween()
			effect_tween.tween_property(mat, "shader_parameter/switch_progress", 1.8, 1.0).set_trans(Tween.TRANS_LINEAR)			
			#effect_tween.tween_property(mat, "")
			effect_tween.play()
			effect_tween.finished.connect(func():
				print("背景过渡动画完成")
				current_texture = tex
				mat.set_shader_parameter("current_texture", current_texture)
				effect_tween.kill())
		# 淡入淡出
		elif effects_type == EffectsType.FadeInAndOut:
			var mat = _background.material
			mat.shader = fade_in_and_out_shader
			_background.material = mat
			# 需要先初始化值
			mat.set_shader_parameter("switch_progress", 0.0)
			mat.set_shader_parameter("current_texture", current_texture)
			mat.set_shader_parameter("target_switch_texture", tex)
			if effect_tween:
				effect_tween.kill()
			var effect_tween = get_tree().create_tween()
			effect_tween.tween_property(mat, "shader_parameter/switch_progress", 1.0, 1.0).set_trans(Tween.TRANS_LINEAR)			
			#effect_tween.tween_property(mat, "")
			effect_tween.play()
			effect_tween.finished.connect(func():
				print("背景过渡动画完成")
				current_texture = tex
				mat.set_shader_parameter("current_texture", current_texture)
				effect_tween.kill())
		#_background.texture = Texture.new()
		background_change_finished.emit()
	else:
		print_rich("[color=red]切换背景失败，空Texture，请检查资源图片[/color]")
		background_change_finished.emit()
	
# 新建角色图片的方法
func create_new_character(chara_id: String, pos: Vector2, state: String, tex: Texture, _scale: float) -> void:
	# 检查创建的是否为场景已有角色
	for chara_dict in actor_dict.values():
		if chara_dict["id"] == chara_id:
			print_rich("[color=red]创建新演员：错误，重复的角色[/color]")
			delete_character(chara_dict["id"])
	# 当前角色信息字典
	var chara_dict = {}
	chara_dict["id"] = chara_id
	chara_dict["x"] = pos.x
	chara_dict["y"] = pos.y
	chara_dict["state"] = state
	chara_dict["c_scale"] = _scale
	# 添加到角色字典
	actor_dict[chara_dict.id] = chara_dict
	var node_name : String = str(chara_dict["id"])
	var temp_node : Node2D = Node2D.new()
	temp_node.name = node_name
	temp_node.set_position(pos)
	# 创建角色的TextureRect
	var chara_tex = TextureRect.new()
	chara_tex.name = node_name
	chara_tex.set_texture(tex)
	chara_tex.scale = Vector2(_scale, _scale)
	temp_node.set_name(node_name)
	temp_node.add_child(chara_tex)
	# 添加到角色容器
	_chara_controler.add_child(temp_node)
	# _chara_controler.add_child(chara_tex)
	character_created.emit()
	print("在位置："+str(pos)+" 新建了演员："+str(chara_id)+" 演员状态："+str(state))
	
## 从角色字典新建角色
func create_character_from_dic(_actor_dic: Dictionary) -> void:
	actor_dict = _actor_dic
	for chara in _actor_dic:
		var chara_id = chara["id"]
		var pos = Vector2(chara["x"], chara["y"])
		var state = chara["state"]
		var c_scale = chara["c_scale"]
	pass
		
# 切换演员的状态
func change_actor_state(actor_id: String, state_id: String, state_tex: Texture) -> void:
	var chara_node: Node = get_chara_node(actor_id)
	var tex_node = chara_node.find_child(actor_id, true, false)
	if tex_node:
		# 修改字典中角色的状态
		actor_dict[actor_id]["state"] = state_id
		tex_node.set_texture(state_tex)
		character_state_changed.emit()
		print("切换"+actor_id+"到"+str(state_id)+"状态")
	else:
		character_state_changed.emit()
		print("切换角色状态失败"+actor_id+"到"+str(state_tex))

# 删除指定角色图片的方法
func delete_character(chara_id: String):
	# 检查要删除的角色是否在容器和字典中
	for actor in actor_dict.values():
		if actor["id"] == chara_id:
			# 删除容器和字典中的角色
			actor_dict.erase(chara_id)
			# 通过名称查找索引并删除
			var chara_controler_node = _chara_controler
			var chara_node: Node = chara_controler_node.find_child(chara_id, true, false)
			if chara_node:
				chara_node.queue_free()
				print("演员删除")
				character_deleted.emit()
			else:
				print("找不到要删除的演员")
				character_deleted.emit()
				return
				
## 删除所有演员
func delete_all_character() -> void:
	actor_dict.clear()
	for node in _chara_controler.get_children():
		node.queue_free()
	print("删除所有演员")
	pass

## 移动角色的方法
func move_chara(chara_id: String, target_pos: Vector2):
	var chara_node = get_chara_node(chara_id)
	var move_tween = chara_node.create_tween()
	move_tween.tween_property(chara_node, "position", Vector2(target_pos), 0.7)
	move_tween.play()
	await move_tween.finished
	move_tween.kill()
	character_moved.emit()
	pass
