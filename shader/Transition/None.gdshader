shader_type canvas_item;

uniform sampler2D target_switch_texture : hint_default_black;

void fragment() {
	COLOR = texture(target_switch_texture, UV);
}
