extends EditorInspectorPlugin

var ShotsEditorProperty = preload("res://addons/konado/editor/inspector/shots_editor_property.gd")


func _can_handle(object):		
	return object.has_method("get") and object.get("preset_shots") != null


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# We handle properties of type integer.
	if type == TYPE_DICTIONARY:
		# Create an instance of the custom property editor and register
		# it to a specific property path.
		add_property_editor(name, ShotsEditorProperty.new())
		# Inform the editor to remove the default property editor for
		# this property type.
		return true
	else:
		return false
