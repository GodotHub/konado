## Konado 宏定义脚本，可以通过修改macros.cfg文件来设置宏
@tool
extends Node

# 宏定义字典
var _macros: Dictionary[String, bool] = {}

func _init() -> void:
	_load_macros()

# 加载宏配置
func _load_macros() -> void:
	var config = ConfigFile.new()
	var config_path = "res://addons/konado/macros.cfg"
	# 加载配置文件
	var error: Error = config.load(config_path)
	if error != OK:
		_set_default_macros()
		return
	
	# 读取宏配置
	_macros.clear()
	
	# 调试相关宏
	_macros["DEBUG"] = config.get_value("debug", "debug_enabled", false)
	print(_macros)
	
# 设置默认宏值
func _set_default_macros() -> void:
	_macros = {
		"DEBUG": false
	}

## 检查宏是否启用
func is_enabled(macro_name: String) -> bool:
	return _macros.get(macro_name, false)
