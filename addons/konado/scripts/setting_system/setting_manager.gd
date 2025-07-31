extends Node
var config = ConfigFile.new()
## 关于硬件的适配看https://store.steampowered.com/hwsurvey/

@export_group("音频设置")
# BGM音量滑动条
@export var bgm_slider: HSlider
# 音效音量滑动条
@export var soundeffect_slider: HSlider
# 语音音量滑动条
@export var voice_slider: HSlider
@export_group("视频设置")
## 显示选项
@export var display_options : OptionButton
## 分辨率选项
@export var resolution_options: OptionButton
## 垂直同步选项
@export var vsync_options: OptionButton
@export_group("对话设置")
# 对话播放速度
@export var dialogspeed_slider: Slider
@export_group("高级设置")
# 控制台文本
@export var c_lable: Label
# 控制台开关
@export var c_options: OptionButton
# 选项重置按钮
@export var reset_btn: Button
@export_group("预设")
## 分辨率（这里适配的都是Steam大于百分之3的硬件）
@export var resolutions: Dictionary = {
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1920x1080": Vector2i(1920, 1080),
	"1920x1200": Vector2i(1920, 1200),
	"2560x1440": Vector2i(2560, 1440),
	"2560x1600": Vector2i(2560, 1600)}

func _ready():
	# 检查设置文件是否存在，如果存在就
	var error = config.load("user://settings.cfg")
	if not error == OK:
		print("没有配置文件，新建配置文件")
		reset_all_settings()
		save_settings()
		config.save("user://settings.cfg")
		config.load("user://settings.cfg")
	#load_settings()
	# 绑定值改变的信号
	reset_btn.pressed.connect(reset_all_settings)
	# 音频部分
	bgm_slider.value_changed.connect(_on_bgm_slider_value_changed)
	soundeffect_slider.value_changed.connect(_on_se_slider_value_changed)
	voice_slider.value_changed.connect(_on_voice_slider_value_changed)
	# 视频部分
	display_options.item_selected.connect(_on_full_screen_check_box_toggled)
	resolution_options.item_selected.connect(_on_resolution_check_box_toggled)
	vsync_options.item_selected.connect(_on_vsync_item_selected)
	# 对话设置
	dialogspeed_slider.value_changed.connect(_on_typing_speed_changed)
	# 高级设置
	c_options.item_selected.connect(_on_console_mode_selected)
	config.save("user://settings.cfg")
	load_settings()
	pass
	
# 控制台彩蛋触发
# 30命秘籍
var knm_sequence = ["Up", "Up", "Down", "Down", "Left", "Right", "Left", "Right", "B", "A", "Enter"]

var knm_current_index = 0
var ewano = 0

func _input(event):
	if event is InputEventKey and event.is_pressed():
		var key_string = event.as_text_keycode()
		if key_string == knm_sequence[knm_current_index]:  
			print(knm_current_index)
			knm_current_index += 1  
			if knm_current_index == knm_sequence.size():  
				print("彩蛋已触发!")  
				c_lable.set_visible(true)
				c_options.set_visible(true)
				knm_current_index = 0 # 重置索引以便再次触发  
		else:  
			knm_current_index = 0 # 重置索引，因为输入序列被打断了
## 加载设置
func load_settings():
	var error = config.load("user://settings.cfg")
	if not error == OK:
		print("无法加载设置！")
		return
	# 加载BGM音量
	var bgm_volume = config.get_value("volume_settings", "bgm_volume")
	if bgm_volume:
		if bgm_volume >= -60.0 and bgm_volume <= 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), bgm_volume)
			bgm_slider.value = bgm_volume
		else:
			print("BGM音量配置值错误，重置音量")
			config.set_value("volume_settings", "bgm_volume", 0.0)
			save_settings()
	# 加载配音音量
	var voice_volume = config.get_value("volume_settings", "voice_volume")
	if voice_volume:
		if voice_volume >= -60.0 and voice_volume <= 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), voice_volume)
			voice_slider.value = voice_volume
		else:
			print("Voice音量配置值错误，重置音量")
			config.set_value("volume_settings", "voice_volume", 0.0)
			save_settings()
	# 加载音效音量
	var se_volume = config.get_value("volume_settings", "se_volume")
	if se_volume:
		if se_volume >= -60.0 and se_volume <= 0.0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SE"), se_volume)
			soundeffect_slider.value = se_volume
		else:
			print("SE音量配置值错误，重置音量")
			config.set_value("volume_settings", "se_volume", 0.0)
			save_settings()
	# 加载窗口模式设置
	var window_mode = config.get_value("video_settings", "windows_mode")
	if window_mode:
		if window_mode >= 0 and window_mode <=2:
			print("读取设置")
			display_options.select(window_mode)
			_on_full_screen_check_box_toggled(window_mode)
		else:
			print("视频窗口设置错误，重置设置")
			config.set_value("video_settings", "windows_mode", 0)
			_on_full_screen_check_box_toggled(0)
			save_settings()
	# 加载分辨率设置（如果设置全屏和全屏无边框忽略）
	var resolution_mode = config.get_value("video_settings", "windows_resolution")
	if resolution_mode:
		if resolution_mode >= 0 and  resolution_mode <= resolutions.size() - 1:
			if window_mode == 0:
				_on_resolution_check_box_toggled(resolution_mode)
				resolution_options.select(resolution_mode)
			elif window_mode == 1 || window_mode == 2:
				print("已设置全屏，忽略分辨率设置")
				pass
		else:
			print("分辨率设置错误，重置设置")
			config.set_value("video_settings", "windows_resolution", 0)
			save_settings()
	# 加载垂直同步设置
	var windows_vsync = config.get_value("video_settings", "windows_vsync")
	if windows_vsync:
		if windows_vsync >= 0 && windows_vsync <= 1:
			_on_vsync_item_selected(windows_vsync)
			vsync_options.select(windows_vsync)
		else:
			print("垂直同步设置错误，重置设置")
			# 如果支持垂直同步就开启
			if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
				config.set_value("video_settings", "windows_vsync", 0)
				_on_vsync_item_selected(0)
			else:
				config.set_value("video_settings", "windows_vsync", 1)
				_on_vsync_item_selected(1)
			save_settings()
	# 加载控制台设置
	var console_mode = config.get_value("advanced_settings", "console")
	if console_mode:
		if console_mode >= 0 and console_mode <= 1:
			print(console_mode)
			#_on_console_mode_selected(console_mode)
			c_options.select(console_mode)
		else:
			print("控制台设置错误，重置设置")
			config.set_value("advanced_settings", "console", 1)
			c_options.select(1)
			#_on_console_mode_selected(1)
			save_settings()
	
	# 加载打字速度设置
	var typing_speed = config.get_value("dialog_settings", "typing_speed")
	if typing_speed:
		if typing_speed >= 0.02 and typing_speed <= 0.09:
			dialogspeed_slider.value = typing_speed*100
		else:
			print("打字速度设置错误，重置设置")
			config.set_value("dialog_settings", "typing_speed", 0.06)
			dialogspeed_slider.value = 0.06*100
			save_settings()

func save_settings():
	config.save("user://settings.cfg")
	

func _on_bgm_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), value)
	config.set_value("volume_settings", "bgm_volume", value)
	save_settings()
	pass

func _on_se_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SE"), value)
	config.set_value("volume_settings", "se_volume", value)
	save_settings()
	
func _on_voice_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), value)
	config.set_value("volume_settings", "voice_volume", value)
	save_settings()

func _on_full_screen_check_box_toggled(value) -> void:
	print("设置窗口"+str(value))
	if value == 0:
		get_window().set_mode(Window.MODE_WINDOWED)
		resolution_options.set_disabled(false)
		centre_the_window()
		get_tree().create_timer(0.05).timeout.connect(_set_resolution_text)
	if value == 1:
		get_window().set_mode(Window.MODE_FULLSCREEN)
		resolution_options.set_disabled(true)
		get_tree().create_timer(0.05).timeout.connect(_set_resolution_text)
	if value == 2:
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
		resolution_options.set_disabled(true)
		print("全屏无边框")
		get_tree().create_timer(0.05).timeout.connect(_set_resolution_text)
	await get_tree().create_timer(0.05).timeout
	config.set_value("video_settings", "windows_mode", value)
	save_settings()
## 当分辨率设置改变
func _on_resolution_check_box_toggled(value) -> void:
	var id = resolution_options.get_item_text(value)
	get_window().set_size(resolutions[id])
	_set_resolution_text()
	centre_the_window()
	config.set_value("video_settings", "windows_resolution", value)
	save_settings()
	pass
## 窗口居中显示
func centre_the_window() -> void:
	var Centre_Screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)

## 设置分辨率文字
func _set_resolution_text() -> void:
	var x = str(get_window().get_size().x)
	var y = str(get_window().get_size().y)
	var resolution_text = x + "x" + y
	resolution_options.set_text(resolution_text)


## 设置垂直同步
func _on_vsync_item_selected(value) -> void:
	match value:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	config.set_value("video_settings", "windows_vsync", value)
	save_settings()

## 设置对话打字机速度（打字间隔）
func _on_typing_speed_changed(value):
	config.set_value("dialog_settings", "typing_speed", value / 100)
	save_settings()
	
## 设置开发者控制台
func _on_console_mode_selected(value):
	config.set_value("advanced_settings", "console", value)
	save_settings()
	
## 设置掌机模式
func _on_handheld_mode_selected(value):
	if value == 0:
		OS.set_low_processor_usage_mode(false)
	if value == 1:
		OS.set_low_processor_usage_mode(true)

# 重置所有设置
func reset_all_settings():
	print("重置所有设置")
	config.set_value("volume_settings", "bgm_volume", 0.0)
	config.set_value("volume_settings", "voice_volume", 0.0)
	config.set_value("volume_settings", "se_volume", 0.0)
	config.set_value("video_settings", "windows_mode", 0)
	config.set_value("video_settings", "windows_resolution", 0)
	# 如果支持垂直同步就开启
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		_on_vsync_item_selected(0)
		config.set_value("video_settings", "windows_vsync", 0)
	else:
		_on_vsync_item_selected(1)
		config.set_value("video_settings", "windows_vsync", 1)
	# 默认对话速度0.06
	config.set_value("dialog_settings", "typing_speed", 0.06)
	# 默认自动播放速度
	config.set_value("dialog_settings", "autoplay_speed", 3)
	# 默认设置控制台关闭
	config.set_value("advanced_settings", "console", 1)
	# 默认掌机模式关闭
	config.set_value("advanced_settings", "handheld_mode", 1)
	c_options.select(1)
	save_settings()
	load_settings()
