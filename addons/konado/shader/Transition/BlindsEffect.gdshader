/*
* @作者：lgyxj
*/
// 百叶窗效果
shader_type canvas_item;

uniform vec2 resolution = vec2(1920, 1080);
uniform float switch_progress : hint_range(0.5, 1.5);

// 从current_texture切换到target_switch_texture
// 要切换的图片
uniform sampler2D target_switch_texture : hint_default_black;
// 被切换的图片
uniform sampler2D current_texture : hint_default_black;

//块长
const float K = 128.0;

//0.5-1.5
vec4 EraseEffect(vec2 uv) {
    //分块
    vec2 pos = mod(uv, K) / K * 2.0 - 1.0;
    //switch_progress \in (0, 0.5]时，刷上当前纹理（所以其实用不到这个区间），\in (0.5, 1]时，消去当前纹理，
    //\in (1, 1.5]时，刷上新的纹理，\in (1.5, 2]时，消去新的纹理（所以其实也用不到）
    float resc = sin(clamp(switch_progress >= 1.0 ? switch_progress - 1.0 : 1.0 - switch_progress, 0.0, 1.0) * PI);
    float resw = step(abs(pos.x), abs(resc));
    if (abs(resw) < 0.0001) return vec4(0.0);
    else if (switch_progress >= 1.0) return texture(target_switch_texture, vec2(((floor(uv.x / K) - 0.5) * K + K / 2.0 * (pos.x / resc)) / resolution.x, uv.y / resolution.y));
    else return texture(current_texture, vec2(((floor(uv.x / K) - 0.5) * K + K / 2.0 * (pos.x / resc)) / resolution.x, uv.y / resolution.y));

}

void fragment() {
	COLOR = EraseEffect(UV * resolution);
}
