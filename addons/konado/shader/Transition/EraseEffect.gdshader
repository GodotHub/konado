/*
* @作者：lgyxj
*/
shader_type canvas_item;

varying vec2 resolution;
uniform float switch_progress : hint_range(0.0, 2.4);
uniform sampler2D target_switch_texture : hint_default_black;
uniform sampler2D current_texture : hint_default_black;

//如果要使用加权平均值，就换成下面的Gauss函数，同时，你需要以uniform形式传入Weight数组
//高斯模糊使用的Weight数组是正态分布函数，sigma值越低越模糊，但是我觉得效果不好
vec4 IwannaGotGoldMedal(vec2 uv, sampler2D tex, int len) {
    //不加权平均值
    vec4 res = vec4(0.0);
    for (int i = -len; i <= len; ++ i) {
        for (int j = -len; j <= len; ++ j) {
            vec2 w = uv + vec2(float(i), float(j));
            res += texture(tex, w / resolution);
        }
    }
    return res / pow(float(len) * 2.0 + 1.0, 2.0);
}

//模糊边界的比例
const float P = 0.2;

vec4 BlindsEffect(vec2 uv) {
    //switch_progress \in (0, 1.2]时，消去当前纹理，\in (1.2, 2.4]时，刷上新的纹理
    if (switch_progress > 1.0 + P) {
        float resw = smoothstep(switch_progress - 1.0 - P - P, switch_progress - 1.0, uv.x / resolution.x);
        if (resw == 0.0) return texture(target_switch_texture, uv / resolution);
        else if (resw == 1.0) return vec4(0.0);
        else return IwannaGotGoldMedal(uv, target_switch_texture, int(resw * 3.0)) * (1.0 - resw);
    } else {
        float resw = smoothstep(switch_progress - P, switch_progress, uv.x / resolution.x);
        if (resw == 0.0) return vec4(0.0);
        else if (resw == 1.0) return texture(current_texture, uv / resolution);
        else return IwannaGotGoldMedal(uv, current_texture, int((1.0 - resw) * 3.0)) * resw;
    }
}

void fragment() {
	resolution = SCREEN_PIXEL_SIZE;
	COLOR = BlindsEffect(UV * resolution);
}
