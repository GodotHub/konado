shader_type canvas_item;

uniform sampler2D target_switch_texture : hint_default_black;
uniform sampler2D current_texture : hint_default_black;
uniform float switch_progress : hint_range(0, 1);

void fragment() {
    // 取样两个纹理的颜色
    vec4 col1 = texture(current_texture, UV);
    vec4 col2 = texture(target_switch_texture, UV);
    // 最终的颜色根据switch_progress的值混合col1和fade_color
    COLOR = mix(col1, col2, switch_progress);
}