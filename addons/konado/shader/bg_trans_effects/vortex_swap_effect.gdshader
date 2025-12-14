shader_type canvas_item;

// 转场进度 0-1：0=仅current，1=仅target
uniform float progress : hint_range(0, 1) = 0.0;
uniform sampler2D current_texture : hint_default_black;
uniform sampler2D target_texture : hint_default_black;

// 扭曲参数（可分别控制current/target的扭曲强度）
uniform float radius_strength : hint_range(0.0, 5.0) = 2.0;    // 半径拉伸强度
uniform float angle_strength : hint_range(0.0, 3.0) = 1.0;     // 角度偏移强度
uniform float angle_frequency : hint_range(1.0, 20.0) = 8.0;   // 角度波纹数量（可选扩展）
uniform vec2 distort_center = vec2(0.5);                       // 扭曲中心（0.5为纹理中心）

void fragment() {
    vec2 uv_current = UV;
    vec2 uv_target = UV;

    // 计算current和target的扭曲UV
    if (progress > 0.0 && progress < 1.0) {
        // 计算互补的扭曲强度
        float current_distort = pow(progress, 2.0);    // current：扭曲随进度递增（0→1）
        float target_distort = pow(1.0 - progress, 2.0);// target：扭曲随进度递减（1→0）
        
        // 极坐标基础计算（共用中心和原始极坐标）
        vec2 centered = UV - distort_center;
        float radius = length(centered);
        float angle = atan(centered.y, centered.x);

        // 处理current的UV：平整→扭曲 
        float curr_new_radius = radius * (1.0 + current_distort * radius_strength);
        float curr_new_angle = angle + current_distort * angle_strength * sin(angle * angle_frequency);
        uv_current = vec2(cos(curr_new_angle), sin(curr_new_angle)) * curr_new_radius + distort_center;
        uv_current = clamp(uv_current, 0.0, 1.0); // 防止UV越界

        // 处理target的UV：扭曲→平整
        float targ_new_radius = radius * (1.0 + target_distort * radius_strength);
        float targ_new_angle = angle + target_distort * angle_strength * sin(angle * angle_frequency);
        uv_target = vec2(cos(targ_new_angle), sin(targ_new_angle)) * targ_new_radius + distort_center;
        uv_target = clamp(uv_target, 0.0, 1.0); // 防止UV越界
    }

    // 混合
    vec4 col_current = texture(current_texture, uv_current);
    vec4 col_target = texture(target_texture, uv_target);
    
    float mix_factor = progress;
    if (progress <= 0.001) mix_factor = 0.0;
    if (progress >= 0.999) mix_factor = 1.0;
    
    COLOR = mix(col_current, col_target, mix_factor);
}