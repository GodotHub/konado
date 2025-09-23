class_name KND_Logger
extends Logger

signal error_caught(msg: String)
signal message_caught(msg: String, error: bool)	

static var _mutex := Mutex.new()

static var _error_type_name := ClassDB.class_get_enum_constants("Logger", "ErrorType")	

func _log_error(
	function: String, 
	file: String, 
	line: int, 
	code: String, 
	rationale: String, 
	editor_notify: bool, 
	error_type: int, 
	script_backtraces: Array[ScriptBacktrace]
) -> void:
	_mutex.lock()
	
	var sb := PackedStringArray()
	sb.append("Caught an error:")
	sb.append("function: {0}".format([function]))
	sb.append("file: {0}".format([file]))
	sb.append("line: {0}".format([line]))
	sb.append("code: {0}".format([code]))
	sb.append("rationale: {0}".format([rationale]))
	sb.append("editor notify: {0}".format([editor_notify]))
	sb.append("error type: {0}".format([_error_type_name[error_type]]))
	if script_backtraces.size() > 0:
		sb.append("script backtraces:")
		for i in script_backtraces:
			sb.append(i.format())

	var msg = "\n".join(sb)
	var filestream = FileAccess.open("user://error_log.txt", FileAccess.WRITE)
	filestream.store_string(msg)
	filestream.close()

	error_caught.emit(msg)
	
	_mutex.unlock()

func _log_message(message: String, error: bool) -> void:
	_mutex.lock()
	
	message_caught.emit(message, error)
	
	_mutex.unlock()
