shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D target_texture : hint_default_black;
uniform sampler2D current_texture : hint_default_black;
uniform int chunk_count : hint_range(1, 64) = 16;

uniform float edge_smooth_width : hint_range(0.001, 0.1) = 0.02;
uniform float chunk_smooth : hint_range(0.0, 1.0) = 0.8;

const float PI_HALF = 1.57079632679;

void fragment() {
    float chunk_count_f = float(chunk_count);
    
    vec4 base_curr = texture(current_texture, UV);
    vec4 base_target = texture(target_texture, UV);
    vec4 base_color = mix(base_curr, base_target, progress);

    // 块索引平滑化
    float chunk_float = UV.y * chunk_count_f;
    int chunk_idx = int(floor(chunk_float));
    // 计算块的小数部分，用于块间平滑过渡
    float chunk_fract = fract(chunk_float);
    float chunk_blend = smoothstep(0.0, 1.0, chunk_fract * chunk_smooth + (1.0 - chunk_smooth));
    
    // 计算当前块和下一块的过渡参数
    float resc_curr = clamp(progress * 2.0 - float(chunk_idx)/chunk_count_f, 0.0, 1.0);
    float resc_next = clamp(progress * 2.0 - float(chunk_idx + 1)/chunk_count_f, 0.0, 1.0);
    // 块间平滑混合resc值
    float resc = mix(resc_curr, resc_next, chunk_blend);

    // 波浪偏移保持原有逻辑
    float x_offset = sin(resc * PI_HALF);
    float uv_x = x_offset + UV.x;
    
    // 边缘平滑切换
    // 原step(1.0, uv_x)改为平滑过渡，避免硬边缘
    float mix_factor = smoothstep(1.0 - edge_smooth_width, 1.0 + edge_smooth_width, uv_x);
    vec4 curr_color = texture(current_texture, vec2(uv_x, UV.y));
    vec4 target_color = texture(target_texture, vec2(uv_x - 1.0, UV.y));
    // 平滑混合当前和目标纹理颜色
    vec4 mid_color = mix(curr_color, target_color, mix_factor);
    
    // 过渡阶段的平滑进入/退出 
    float use_mid = smoothstep(0.0, edge_smooth_width * 5.0, progress) 
                  * (1.0 - smoothstep(1.0 - edge_smooth_width * 5.0, 1.0, progress));
    
    // 最终颜色混合
    COLOR = mix(base_color, mid_color, use_mid);
}