shader_type canvas_item;

// 切换进度 [0,1]：0=完全显示当前纹理，1=完全显示目标纹理
uniform float progress : hint_range(0.0, 1.0) = 0.0;
// 目标切换纹理（要切换到的图片）
uniform sampler2D target_texture : hint_default_black;
// 当前纹理（初始显示的图片）
uniform sampler2D current_texture : hint_default_black;
// 擦除过渡的平滑宽度 [0,0.1]：值越大过渡越柔和，0=硬切
uniform float transition_smoothness : hint_range(0.0, 0.1) = 0.05;
// 擦除线角度 [0,360]：0°=水平从左到右，90°=垂直从上到下，45°=斜向等
uniform float wipe_angle : hint_range(0.0, 360.0) = 0.0;

// 计算UV在指定角度方向上的归一化投影（核心修复逻辑）
float get_normalized_projection(vec2 uv, float angle_rad) {
    // 将UV转换为以纹理中心为原点的坐标（范围[-0.5, 0.5]）
    vec2 centered_uv = uv - vec2(0.5);
    
    // 计算擦除方向的单位向量
    vec2 wipe_dir = normalize(vec2(cos(angle_rad), sin(angle_rad)));
    
    // 计算中心化UV在擦除方向上的投影值
    float projection = dot(centered_uv, wipe_dir);
    
    // 归一化投影值到[0,1]
    float max_projection = sqrt(2.0) / 2.0; // 对角线最大投影值
    projection = (projection / max_projection) * 0.5 + 0.5; // 转换到[0,1]范围
    
    return projection;
}

// 任意角度完整擦除切换核心逻辑
vec4 AngleWipeEffect(vec2 uv) {
    // 将角度从度数转换为弧度
    float angle_rad = radians(wipe_angle);
    
    // 计算UV在擦除角度方向上的归一化投影
    float proj = get_normalized_projection(uv, angle_rad);
    
    // 计算平滑过渡的区间
    float edge_low = progress - transition_smoothness * 0.5;
    float edge_high = progress + transition_smoothness * 0.5;
    // 混合因子：基于归一化投影计算，确保全角度覆盖
    float mix_factor = smoothstep(edge_low, edge_high, proj);
    
    // 采样两个纹理的颜色
    vec4 current_color = texture(current_texture, uv);
    vec4 target_color = texture(target_texture, uv);
    
    // 按混合因子混合颜色
    return mix(target_color, current_color, mix_factor);
}

void fragment() {
    COLOR = AngleWipeEffect(UV);
}