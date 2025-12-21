shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // 切换进度（0-1）
uniform int column_count : hint_range(1, 100) = 16; // 百叶窗列数（分块数量）
uniform bool reverse = false; // 是否反向切换（从右到左）
uniform float edge_softness : hint_range(0.0, 0.2) = 0.08; // 边缘柔化度（0=无柔化，0.1=最大柔化）

uniform sampler2D target_texture : source_color;
uniform sampler2D current_texture : source_color;

// 百叶窗核心计算函数
vec4 louver_switch(vec2 uv) {
    float column_float = float(column_count);
    float uv_x_scaled = uv.x * column_float;

    // 拆分列内相对位置（0.0 ~ 1.0）
    float in_column_x = fract(uv_x_scaled);  // 列内X位置（0~1）

    // 处理反向切换逻辑
    float progress_threshold = reverse ? (1.0 - progress) : progress;

    // 边缘柔滑处理（核心修复：极值时关闭柔化，避免细条）
    float mix_factor;
    if (progress_threshold <= 0.0) {
        // 进度为0强制全显当前纹理
        mix_factor = 1.0;
    } else if (progress_threshold >= 1.0) {
        // 进度为1强制全显目标纹理
        mix_factor = 0.0;
    } else {
        // 非极值：柔化过渡（限制区间在0-1内）
        float soft_min = progress_threshold - edge_softness;
        float soft_max = progress_threshold + edge_softness;
        soft_min = clamp(soft_min, 0.0, 1.0);
        soft_max = clamp(soft_max, 0.0, 1.0);
        mix_factor = smoothstep(soft_min, soft_max, in_column_x);
    }

    // 采样纹理并混合
    vec4 current_color = texture(current_texture, uv);
    vec4 target_color = texture(target_texture, uv);

    // 按混合因子渐变混合两个纹理
    return mix(target_color, current_color, mix_factor);
}

void fragment() {
    COLOR = louver_switch(UV);
}