/*
* @作者：lgyxj
*/
shader_type canvas_item;

varying vec2 resolution;
uniform float switch_progress : hint_range(0.0, 1.8);
//被切换的图片
uniform sampler2D target_switch_texture : hint_default_black;
// 要切换的图片
uniform sampler2D current_texture : hint_default_black;

//varying vec2 v_texcoord;

const float pi = acos(-1.0);
//小块长
uniform float Chunk = 8.0;
//我喜欢由乃OI（因为有很多分块题）！
vec4 WaveEffect(vec2 uv) {
    //先分块
    int pos = int(floor(uv.y / (resolution.y / Chunk)));
    //周期
    float resc = clamp(fract(switch_progress / 2.0) * 2.0 - float(pos) / Chunk, 0.0, 1.0);
    //resc == 0.0时，第一个长条开始移动，resc == 1.0时，第一个长条移动完毕，最后一个长条开始移动，其他长条开始移动的时间点在(0.0, 1.0)之间（平分）
    //因为一个周期要移动resolution.x那么多个像素，所以当前移动了周期 * ()那么多个像素
    float resw = sin(resc / 2.0 * pi) + uv.x / resolution.x;
    if (resw >= 1.0) return texture(target_switch_texture, vec2(resw - 1.0, uv.y / resolution.y));
    else return texture(current_texture, vec2(resw, uv.y / resolution.y));
}

void fragment() {
	resolution = SCREEN_PIXEL_SIZE;
	COLOR = WaveEffect(UV * resolution);
}
