#@tool
extends Node
### 主题生成器
#
#const UPDATE_ON_SAVE = true
#const transparent  :=Color(0,0,0,0)
#const trans_texture:= preload("uid://c160sij6d1xop") ## 透明图片
#
#
##region 变量
#var tabbar_close_texture:= preload("uid://crovcslajuick") ## 关闭按钮图片
#
## 常用变量
#
#var def_font_size       := 22                 ## 字体大小
#var button_font_size    := 20
#var def_line_spacing    := 10                 ## 行间距
##var def_font := "uid://bskhxqmfqwmm1"         ## 字体路径
#
#var def_icon_width      := 40                 ## 图标宽度
#
#var def_corner_radiu    := 8                  ## 面板倒角半径
#var def_border_width    := 2                  ## 面板描边粗细
#var def_content_margins := 5                  ## 面板间距
#var def_corer_detail    := 4                  ## 倒角细分
#
## graphedit 相关变量
#var graph_corner_radiu  := 20 
#
#
## 前景色
#
#var main_color                                ## 主题色 高亮显示
#var select_color                              ## 选中对象颜色 高亮显示
#var focus_color                               ## 文字|高亮显示
#var def_color                                 ## 正常颜色
#var line_color                                ## 分割线|滑块 颜色
## 背景色
#var button_bg
#var bg_color_1                                ## 最浅的深色
#var bg_color_2                              
#var bg_color_3                                ## 最深的颜色
#
## 样式盒
#var style_box_empty =  stylebox_empty({       ## 空样式盒
	#content_margins_ = content_margins(12,5,12,5)
	#})
#
#var def_box_style        ## 基础面板样式盒，
#var popup_box_style      
#var outline_no_bg_style  ## 轮廓线面板样式盒 无背景色 
#var outline_box_style    ## 轮廓线面板样式盒，
#
#var ks_button_style
#var def_v_line_style     ## 横线
#var def_h_line_style     ## 竖线
#var window_stylebox      ## 窗口面板样式盒，
#
##endregion
#
#func setup_dark_them():                      ## 保存主题
#
	#main_color   = Color(0.6, 1.0, 0.5)      ## 主题色 高亮显示
	#select_color = Color.PALE_GREEN
	#focus_color  = Color.GRAY                ## 文字|高亮显示
	#def_color    = Color(1,1,1,0.8)          ## 正常颜色
	#line_color   = Color(0.25, 0.25, 0.25)   ## 分割线|滑块 颜色
#
	#button_bg    = transparent
	#bg_color_1   = Color(0.18, 0.18, 0.20)   ## 最浅的深色
	#bg_color_2   = Color(0.12, 0.12, 0.13) 
	#bg_color_3   = Color(0.09, 0.09, 0.09)   ## 最深的颜色
	#set_save_path("uid://cao2ht3baecs8")
#
#func setup_light_them():                     ## 保存主题
	#
	#main_color   = Color(0.17, 0.7, 0.4)     ## 主题色 高亮显示
	#select_color = Color(0.17, 0.7, 0.4)
	#def_color    = Color(0,0,0,0.8)          ## 正常颜色
	#focus_color  = Color(0.3, 0.3, 0.3)      ## 文字   | 正常显示
	#line_color   = Color(0.75, 0.75, 0.75)
	#
	#button_bg    = Color(0.95, 0.95, 0.95)  
	#bg_color_1   = Color(0.95, 0.95, 0.95)    
	#bg_color_2   = Color(0.85, 0.85, 0.85) 
	#bg_color_3   = Color(0.75, 0.75, 0.75)  
	#set_save_path("uid://dy4cs3bqk267w")
#
#func setup_konado_them():                      ## 保存主题
#
	#main_color   = Color(0.778, 0.565, 0.889, 1.0)      ## 主题色 高亮显示
	#select_color = Color(0.778, 0.565, 0.889, 1.0) 
	#focus_color  = Color.GRAY                ## 文字|高亮显示
	#def_color    = Color(1,1,1,0.8)          ## 正常颜色
	#line_color   = Color(0.25, 0.25, 0.25)   ## 分割线|滑块 颜色
#
	#button_bg    = transparent
	#bg_color_1   = Color(0.18, 0.18, 0.2, 0.6)   ## 最浅的深色
	#bg_color_2   = Color(0.12, 0.12, 0.13, 0.384) 
	#bg_color_3   = Color(0.09, 0.09, 0.09)   ## 最深的颜色
	#set_save_path("uid://xb40j2mc624h")
#
#func define_theme(): ## 设置主题
	##define_default_font(ResourceLoader.load(def_font)) ## 设置默认字体
	#define_default_font_size(24)
	#
	#stylebox_setting()
	#
	#container_style()
	#
	#panel_style()
	#button_style()
	#window_style()
	#
	#separator_style()
	#
	#tree_style_box()
	#label_style_box()
	#
	#graph_style()
	#
#
#
#func stylebox_setting():
	#def_box_style = stylebox_flat({
		#bg_color         = bg_color_2      ,  ## 背景色
		#corner_detail    = def_corer_detail,  ## 倒角细分
		#corner_radius_   = corner_radius(def_corner_radiu)  ,
		#content_margins_ = content_margins(def_content_margins)
		#})
	#popup_box_style = stylebox_flat({
		#bg_color         = bg_color_1     ,  ## 背景色
		#corner_detail    = def_corer_detail ,  ## 倒角细分
		#corner_radius_   = corner_radius(def_corner_radiu) ,
		#border_color     = line_color,
		#border_width_    = border_width(1),
		#content_margins_ = content_margins(20,5,20,10)
		#})
	#outline_no_bg_style =  stylebox_flat({    
		#bg_color         = transparent    ,  ## 背景色
		#corner_detail    = def_corer_detail ,  ## 倒角细分
		#corner_radius_   = corner_radius(def_corner_radiu) ,
		#border_color     = line_color,
		#border_width_    = border_width(1),
		#content_margins_ = content_margins(20,5,20,10)
		#})
	#outline_box_style = stylebox_flat({
		#bg_color         = bg_color_1     ,  ## 背景色
		#corner_detail    = def_corer_detail ,  ## 倒角细分
		#corner_radius_   = corner_radius(def_corner_radiu) ,
		#border_color     = line_color,
		#border_width_    = border_width(1),
		#content_margins_ = content_margins(20,5,20,10)
		#})
	#def_v_line_style = stylebox_line({
		#color = line_color,
		#vertical = true,
		#grow_begin = -5,
		#grow_end   = -5,
		#thickness  = 2 ,
		#})
	#def_h_line_style = stylebox_line({
		#color = line_color,
		#grow_begin = -5,
		#grow_end   = -5,
		#thickness  = 2 ,
		#})
	#window_stylebox  = stylebox_flat({
		#bg_color         = bg_color_3    ,        ## 背景色
		#corner_detail    = 8             ,        ## 倒角
		#content_margins_ = content_margins(def_content_margins),##
		#corner_radius_   = corner_radius(12)  ,
		#expand_margins_  = expand_margins(10,50,10,10),
		#shadow_color     = Color(0, 0, 0, 0.47451),
		#shadow_size      = 15,
		#shadow_offset    = Vector2(0, 10)
		#})
#
	#ks_button_style = stylebox_flat({
		#bg_color         = bg_color_2      ,  ## 背景色
		#corner_detail    = def_corer_detail,  ## 倒角细分
		#corner_radius_   = corner_radius(0,12,12,0)  ,
		#border_color     = main_color,
		#border_width_    = border_width(3,0,0,0),
		#content_margins_ = content_margins(def_content_margins)
		#})
	#
### 容器类设置
#func container_style():
	#pass
#
### panel样式
#func panel_style():
	#
	#define_style("Panel",{ # 常规
		#panel = def_box_style
		#})
	#
	#define_variant_style("Background","Panel",{ # 背景
		#panel = stylebox_flat({
			#bg_color = bg_color_3
			#})
		#})
	#
	#define_style("PanelContainer",{
		#panel=stylebox_flat({
			#bg_color = transparent,
			#border_width_  = border_width(3)    ,
			#corner_radius_ = corner_radius(graph_corner_radiu )  ,
			#expand_margins_= expand_margins(2),
			#border_color   = Color.WHITE
			#}),
		#})
#
### 按钮样式
#func button_style():
	#define_style("Button",{
		#font_color          = focus_color   ,
		#font_focus_color    = focus_color   ,
		#font_hover_color    = main_color    ,
		#font_pressed_color  = main_color    ,
		#font_disabled_color = focus_color*0.6 ,
		#font_hover_pressed_color =main_color,
		#
		#icon_normal_color   = focus_color   ,
		#icon_focus_color    = focus_color   ,
		#icon_hover_color    = main_color    ,
		#icon_pressed_color  = main_color    ,
		#icon_hover_pressed_color =main_color,
#
		## 常量
		#icon_max_width = def_icon_width,
		#align_to_largest_stylebox = 1,
		#h_separation = 4,
		#font_size    = button_font_size,
		## 样式盒
		#disabled = style_box_empty,
		#focus    = style_box_empty,
		#hover    = style_box_empty,
		#normal   = style_box_empty,
		#pressed  = inherit(def_box_style,{
			#bg_color = button_bg
			#}),
		#})
#
	#define_style("OptionButton",{
		## 常量
			#align_to_largest_stylebox = 1,
			#arrow_margin = 18,
			#h_separation = 15,
			#icon_max_width = 80,
			#
			#disabled = outline_no_bg_style,
			#focus    = outline_no_bg_style,
			#hover    = outline_no_bg_style,
			#normal   = outline_no_bg_style,
			#pressed  = outline_no_bg_style,
#
			#
		#})
#
	#define_variant_style("KSButton",    
		#"Button",{ 	
			#hover    = ks_button_style,
			#normal   = ks_button_style,
			#hover_pressed  = inherit(ks_button_style,{
				#bg_color = bg_color_1
			#}),  
			#pressed  = inherit(ks_button_style,{
				#bg_color = bg_color_1
			#}), 
		#})
#
	#define_style("TabBar",{
		#drop_mark_color = main_color,
		#font_disabled_color = focus_color*0.6,
		#font_hovered_color = main_color,
		#font_selected_color = focus_color,
		#font_unselected_color = focus_color,
		#
		#h_separation = 20,
		#icon_max_width = 0,
		#outline_size = 0,
		#
		#font_size = button_font_size,
		#
		#close = tabbar_close_texture,
		#
		#button_highlight = def_box_style,
		#button_pressed = inherit(def_box_style,{
			#bg_color = main_color
			#}),
		#tab_disabled = style_box_empty,
		#tab_focus =  style_box_empty,
		#tab_hovered = style_box_empty,
		##tab_selected = stylebox_texture({
			###texture = tabbar_texture ,
			##content_margin_left = 45.0,
			##content_margin_right = 25.0,
			##texture_margin_left = 72.0,
			##texture_margin_right = 52.0,
			##expand_margin_right = 22.0,
			##axis_stretch_horizontal = 2,
			##axis_stretch_vertical = 1,
			##region_rect = Rect2(0, 0, 280, 58),
			##modulate_color = bg_color_1
			##}),
		#tab_unselected =  style_box_empty,
		#})
#
	#define_style("TabContainer",{
		#panel = style_box_empty,
		#})
#
	#define_variant_style("ButtonContainer",     # 按钮背景
		#"Panel",{ 
			#panel = inherit(def_box_style,{
				#bg_color         = bg_color_3*0.2    ,  
				#corner_radius_   = corner_radius(12)  ,
				#content_margins_ = content_margins(8),
				#})
		#})
#
### window 样式
#func window_style():
	#define_style("Window", {
		#close_h_offset = 40 ,
		#resize_margin  = 6  ,
		#title_height   = 50,
#
		#embedded_border  = window_stylebox,
		#embedded_unfocused_border =  window_stylebox,
		#})
#
	#define_variant_style("WindowPanel","Panel",
		#{panel = stylebox_flat({
			 #bg_color= bg_color_2
			#})
		#})
	#
	### popup 样式
	#define_style("PopupMenu",{
		#font_accelerator_color = focus_color,
		#font_color = focus_color,
		#font_disabled_color = focus_color * 0.6,
		#font_hover_color = main_color,
		#font_separator_color = focus_color,
		#
		#h_separation = 30,
		#icon_max_width = 30,
		#indent = 15,
		#item_end_padding = 3,
		#item_start_padding = 8,
		#separator_outline_size = 0,
		#v_separation = 10,
		#font_size = 22,
#
		#hover = def_box_style,
		#labeled_separator_left = def_h_line_style,
		#labeled_separator_right = def_h_line_style,
		#panel = popup_box_style,
		#separator = def_h_line_style,
	#})
	#define_style("PopupPanel",{
		#
		#panel = style_box_empty,
	#})
#
#func separator_style():
	### 分割线
	#define_style("VSeparator",{
		#separator = def_v_line_style,
		#})
	#define_style("HSeparator",{
		#separator = def_h_line_style,
		#})
  	### 滚动条
	#define_style("VScrollBar",{
		#grabber = style_box_empty,
		#grabber_highlight = stylebox_flat({
			#bg_color = Color.WHITE*0.5,
			#corner_radius_   = corner_radius(def_corner_radiu)  ,
			#}),
		#grabber_pressed = stylebox_flat({
			#bg_color = Color.WHITE,
			#corner_radius_   = corner_radius(def_corner_radiu) ,
				#}),
		#scroll = stylebox_flat({
			#bg_color = Color.BLACK*0.1,
			#corner_radius_   = corner_radius(def_corner_radiu) ,
			#content_margins_ = content_margins(def_content_margins)
				#}),
		#scroll_focus = stylebox_flat({
			#bg_color = Color.BLACK*0.2,
			#corner_radius_   = corner_radius(def_corner_radiu) ,
			#content_margins_ = content_margins(6)
				#}),
		#})
	#define_style("HScrollBar",{
		#grabber = style_box_empty,
		#grabber_highlight = stylebox_flat({
			#bg_color = Color.WHITE*0.5,
			#corner_radius_   = corner_radius(def_corner_radiu)  ,
			#}),
		#grabber_pressed = stylebox_flat({
			#bg_color = Color.WHITE,
			#corner_radius_   = corner_radius(def_corner_radiu) ,
				#}),
		#scroll = stylebox_flat({
			#bg_color = Color.BLACK*0.1,
			#corner_radius_   = corner_radius(def_corner_radiu) ,
			#content_margins_ = content_margins(def_content_margins)
				#}),
		#scroll_focus = stylebox_flat({
			#bg_color = Color.BLACK*0.2,
			#corner_radius_   = corner_radius(def_corner_radiu) ,
			#content_margins_ = content_margins(def_content_margins)
				#}),
		#})
#
#func tree_style_box():
	### tree 样式
	#define_style("Tree",{
		#children_hl_line_color        = bg_color_1,
		#custom_button_font_highlight  = main_color,
		#drop_position_color           = main_color,
		#font_color                    = focus_color,
		#font_disabled_color           = focus_color * 0.5,
		#font_selected_color           = main_color,
		#parent_hl_line_color          = bg_color_1,
		#relationship_line_color       = bg_color_1,
		## 参数
		#draw_guides                   = 0,
		#draw_relationship_lines       = 1,
		#h_separation                  = 30,
		#icon_max_width                = def_icon_width,
		#inner_item_margin_left        = 12,
		#inner_item_margin_right       = 0,
		#inner_item_margin_top         = 0,
		#item_margin                   = 24,
		#outline_size                  = 0,
		#parent_hl_line_margin         = 0,
		#parent_hl_line_width          = 1,
		#relationship_line_width       = 1,
		#scroll_border                 = 6,
		#scroll_speed                  = 12,
		#scrollbar_h_separation        = 6,
		#scrollbar_margin_bottom       = -1,
		#scrollbar_margin_left         = -1,
		#scrollbar_margin_right        = -1,
		#scrollbar_margin_top          = -1,
		#scrollbar_v_separation        = 6,
		#v_separation                  = 6,
		#font_size                     = def_font_size,
		#title_button_font_size        = def_font_size,
		## 样式盒
		#cursor                        = style_box_empty,
		#cursor_unfocused              = style_box_empty,
		#focus                         = style_box_empty,
		#hovered                       = stylebox_flat({ bg_color = bg_color_1 }),
		#panel                         = style_box_empty,
		#selected                      = stylebox_flat({ bg_color = bg_color_1 }),
		#selected_focus                = stylebox_flat({ 
			#bg_color = bg_color_1,
			#border_color     = line_color,
			#border_width_    = border_width(1),
			#content_margins_ = content_margins(20,5,20,10) }),
			#})
#func label_style_box():
	### label 样式设置
	#define_style("Label", {
		#font_color                 = focus_color,
		#font_size = 24,
		#line_spacing = def_font_size / 4,
		#normal = style_box_empty
		#})
#
	### textedit 样式
	#define_style("TextEdit",{
		#
		#background_color           = transparent,
		#caret_background_color     = bg_color_3 ,
		#caret_color                = main_color ,
		#current_line_color         = bg_color_3*0.1 , 
		#font_color                 = focus_color,
		#font_placeholder_color     = focus_color*0.5,
		#font_readonly_color        = focus_color*0.5,
		#font_selected_color        = bg_color_3,
		#search_result_border_color = main_color,
		#search_result_color        = bg_color_1,
		#selection_color            = select_color,
		#word_highlighted_color     = main_color,
		#
		#caret_width = 2,
		#line_spacing= def_line_spacing,
		#font_size   = def_font_size  ,
		#
		#focus       = outline_no_bg_style,
		#normal      = outline_no_bg_style,
		#read_only   = outline_no_bg_style,
		#})
#
	#define_style("RichTextLabel",{
		#default_color = Color(1, 1, 1, 1),
		#font_outline_color = Color(0, 0, 0, 1),
		#font_selected_color = Color(0, 0, 0, 0),
		#font_shadow_color = Color(0, 0, 0, 0),
		#selection_color = Color(0.1, 0.1, 1, 0.8),
		#table_border = Color(0, 0, 0, 0),
		#table_even_row_bg = Color(0, 0, 0, 0),
		#table_odd_row_bg = Color(0, 0, 0, 0),
		#
		#line_separation = def_line_spacing,
		#table_h_separation = 6,
		#table_v_separation = 5,
		#text_highlight_h_padding = 5,
		#text_highlight_v_padding = 5,
		#
		#bold_font_size = 26,
		#bold_italics_font_size = 26,
		#italics_font_size = 24,
		#mono_font_size = 24,
		#normal_font_size = 24,
		#
		##bold_font = ExtResource("10_rdct0"),
		##bold_italics_font = ExtResource("10_rdct0"),
		##italics_font = ExtResource("11_vrkuf"),
		#
		#focus = style_box_empty,
		#normal = style_box_empty,
		#})
#
#
	### lineedit 样式
	#define_style("LineEdit",{
		#caret_color                = main_color ,
		#font_color                 = focus_color,
		#font_size                  = def_font_size  ,
		#font_placeholder_color     = focus_color*0.5, 
		#font_uneditable_color      = focus_color*0.5,
		#font_selected_color        = bg_color_3,
		#selection_color            = select_color,
		#
		#caret_width = 2,
		#
		#focus      = outline_box_style,
		#normal     = outline_no_bg_style,
		#read_only  = outline_no_bg_style,
		#})
	### spinbox
	#define_style("SpinBox",{
	#
		#buttons_width = 1,
		#field_and_buttons_separation = 1,
		#
		#down_background_hovered =outline_box_style,
		#down_background_pressed =outline_box_style,
		#up_background_hovered = outline_box_style,
		#up_background_pressed = outline_box_style,
		#})
#
#func graph_style():
	#define_style("GraphEdit",{
		#activity = Color(1, 0.0286458, 0.0286458, 1),
		#connection_hover_tint_color = Color(0, 0.655951, 1, 0.686275),
		#connection_rim_color = Color(0.17, 0.17, 0.17, 0.396078),
		#connection_valid_target_tint_color = Color(1, 1, 1, 0.4),
		#grid_major = Color(1, 1, 1, 0.407843),
		#grid_minor = Color(0.458824, 0.654902, 0.682353, 0.207843),
		#selection_fill = Color(0.74902, 0.772549, 0.811765, 0.105882),
		#selection_stroke = Color(0.6006, 0.76804, 0.78, 0.737255),
		#connection_hover_thickness = 100,
#
		#
		#menu_panel = style_box_empty,
		#panel = style_box_empty,
	#})
	#
	#define_style("GraphNode",{
		#resizer_color = transparent,
		#port_h_offset = -10,
		#panel =  stylebox_flat({    
			#corner_radius_   = corner_radius(graph_corner_radiu +5)  ,
			#}),
		#panel_selected = style_box_empty,
		#titlebar = style_box_empty,
		#titlebar_selected = style_box_empty,
	#})
	#
	#define_style("GraphFrame",{
		#resizer_color = Color(0.875, 0.875, 0.875, 1),
		#panel = stylebox_flat({
			#bg_color = bg_color_1 *0.1,
			#corner_detail    = def_corer_detail,  ## 倒角细分
			#corner_radius_   = corner_radius(graph_corner_radiu )  ,
			#border_color     = line_color,
			#border_width_    = border_width(1),
			#content_margins_ = content_margins(def_content_margins)
			#}),
		#panel_selected = stylebox_flat({
			#bg_color = bg_color_1 *0.1,
			#corner_detail    = def_corer_detail,  ## 倒角细分
			#corner_radius_   = corner_radius(graph_corner_radiu )  ,
			#border_color     = select_color*0.8,
			#border_width_    = border_width(2),
			#content_margins_ = content_margins(def_content_margins)
			#}),
	#})
	#
	#define_variant_style("GraphNodePanel","Panel",{
		#panel = inherit(def_box_style,{
			#bg_color = Color.WHITE,
			#corner_radius_ = corner_radius(graph_corner_radiu ) ,
			#expand_margins_= expand_margins(1,10,1,1),
			#}) 
		#})
#
	#define_variant_style("GraphNodeLine","PanelContainer",{
		#panel =stylebox_flat({
			#bg_color = transparent,
			#border_width_  = border_width(3)    ,
			#corner_radius_ = corner_radius(graph_corner_radiu )  ,
			#expand_margins_= expand_margins(3,13,3,3),
			#border_color   = Color.WHITE
			#}),
		#})
	#
	#define_variant_style("TransitionPoint","GraphNode",{
		#resizer_color = Color(0, 0, 0, 1),
		#
		#port_h_offset = 20,
		#separation = 0,
		#
		#port = trans_texture,
		#panel = style_box_empty,
		#panel_selected = style_box_empty,
		#slot = style_box_empty,
		#titlebar = style_box_empty,
		#titlebar_selected = stylebox_flat({
			#bg_color = main_color,
			#corner_radius_ = corner_radius(graph_corner_radiu )  ,
			#}),
	#})
