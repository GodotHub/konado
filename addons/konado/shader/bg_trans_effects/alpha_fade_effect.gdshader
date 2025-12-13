shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform sampler2D target_texture : hint_default_black;
uniform sampler2D current_texture : hint_default_black;

void fragment() {
    // 取样两个纹理的颜色
    vec4 col1 = texture(current_texture, UV);
    vec4 col2 = texture(target_texture, UV);

    COLOR = mix(col1, col2, progress);
}