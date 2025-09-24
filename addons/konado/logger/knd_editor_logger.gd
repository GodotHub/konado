extends Node
class_name KNDEditorLogger

func _ready() -> void:
	var knd_logger: KND_Logger = KND_Logger.new()
	knd_logger.error_caught.connect(show_error, ConnectFlags.CONNECT_DEFERRED)
	OS.add_logger(knd_logger)
	

func show_error(msg: String) -> void:
	print("KND" + msg)
