shader_type canvas_item;

// 转场进度 [0=仅current, 1=仅target]
uniform float progress : hint_range(0, 1) = 0.0;
// 当前纹理
uniform sampler2D current_texture : hint_default_black;
// 目标纹理
uniform sampler2D target_texture : hint_default_black;
// 风车叶片数量
uniform int blade_count : hint_range(3, 20) = 4;
// 边缘柔化程度（0=硬边，1=最柔）
uniform float edge_softness : hint_range(0.0, 1.0) = 0.1;
// 风车旋转偏移
uniform float rotation_offset = 0.0;

void fragment() {
    vec4 current_color = texture(current_texture, UV);
    vec4 target_color = texture(target_texture, UV);
    
    float p = clamp(progress, 0.0, 1.0);
    if (p <= 0.0) {
        COLOR = current_color;
    } else if (p >= 1.0) {
        COLOR = target_color;
    } else {
	    // UV修正：中心原点 + 宽高比适配
	    vec2 center_uv = UV - vec2(0.5);
	    center_uv.y = -center_uv.y; // 修正Godot Y轴向下的视觉旋转方向
	    vec2 aspect_ratio = vec2(1.0, SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y);
	    center_uv *= aspect_ratio;

	    // 极坐标角度计算
	    float angle = atan(center_uv.y, center_uv.x); // 原始角度(-π, π)
	    angle = mod(angle + rotation_offset + TAU, TAU); // 归一化到(0, TAU)，TAU=2π（Godot内置）

	    // 风车叶片核心参数
	    float blade_step = TAU / max(float(blade_count), 3.0); // 单叶片角度步长（防除0）
	    float soft_range = blade_step * clamp(edge_softness, 0.0, 1.0); // 柔化角度范围
	    float expand_angle = p * blade_step; // 叶片展开角度（进度直接控制）

	    // 计算像素在叶片内的相对角度
	    float relative_angle = mod(angle, blade_step);

	    // 混合因子计算（移除冗余Clamp，smoothstep输出本身是0~1）
	    float mix_factor = 1.0 - smoothstep(
	        expand_angle - soft_range,
	        expand_angle + soft_range,
	        relative_angle
	    );

	    // 最终纹理混合
	    COLOR = mix(current_color, target_color, mix_factor);
	}
}