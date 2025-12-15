shader_type canvas_item;

uniform float progress : hint_range(0, 1) = 0.0; // 转场进度 0=仅current 1=仅target
uniform sampler2D current_texture : hint_default_black; // 初始纹理
uniform sampler2D target_texture : hint_default_black; // 目标纹理

// 故障效果可调参数（赛博风格定制）
uniform float glitch_intensity : hint_range(0.0, 0.2) = 0.05; // 故障整体强度
uniform float rgb_split_amount : hint_range(0.0, 0.02) = 0.02; // RGB通道分离量
uniform float scanline_freq : hint_range(10.0, 200.0) = 80.0; // 扫描线噪点频率
uniform float pixelation_base : hint_range(0.0, 0.1) = 0.02; // 像素化基础强度（原pixelation）
uniform float random_seed : hint_range(0.0, 1000.0) = 42.0; // 随机种子（每次转场不同）
uniform float noise_strength : hint_range(0.0, 0.2) = 0.05; // 电子噪点强度

// 随机数生成函数（基于UV+种子，保证随机性）
float random(vec2 st) {
    return fract(sin(dot(st + random_seed, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	if (progress <= 0.0) {
		COLOR = texture(current_texture, UV);
	} else if (progress >= 1.0) {
		COLOR = texture(target_texture, UV);
	} else {
	    // 基础UV（全屏转场使用屏幕UV）
	    vec2 uv = UV;
	    // 时间因子（让故障动态变化）
	    float time = TIME * 6.0;
	    
	    // 随机UV扭曲（核心故障效果） 
	    // 基于进度的随机值（进度不同，故障区域不同）
	    float progress_rand = random(uv * 15.0 + progress * 200.0);
	    // 故障强度：进度0.5时最强（转场中间故障最明显）
	    float glitch_strength = glitch_intensity * progress * (1.0 - progress) * 3.0;
	    // 随机增强/削弱故障（每帧不同）
	    glitch_strength *= random(uv * scanline_freq + time);
	    
	    // 水平/垂直随机偏移（模拟电子信号错乱）
	    float h_offset = glitch_strength * (progress_rand - 0.5) * 2.0;
	    float v_offset = glitch_strength * (random(uv * 5.0 + time) - 0.5) * 2.0;
	    vec2 distorted_uv = uv + vec2(h_offset, v_offset);
	    
	    // 动态像素化（随progress先变大后变小）
	    // 动态像素化强度：二次曲线（progress=0.5时达到峰值）
	    // progress*(1-progress) 是二次函数，峰值在0.5，值域0~0.25；乘以4让峰值等于pixelation_base
	    float dynamic_pixelation = pixelation_base * progress * (1.0 - progress) * 4.0;
	    // 限制最小值（避免0，保证轻微像素化/防止计算异常）
	    dynamic_pixelation = max(dynamic_pixelation, 0.001);
	    
	    // 基于动态强度计算像素化UV
	    vec2 pixelated_uv = floor(distorted_uv / dynamic_pixelation) * dynamic_pixelation;
	    // 限制UV在0-1范围内，避免采样纹理外区域
	    pixelated_uv = clamp(pixelated_uv, 0.0, 1.0);
	    
	    // RGB通道分离
	    // 初始纹理RGB分离采样
	    vec3 current_color;
	    current_color.r = texture(current_texture, pixelated_uv + vec2(rgb_split_amount * random(uv), 0.0)).r;
	    current_color.g = texture(current_texture, pixelated_uv).g;
	    current_color.b = texture(current_texture, pixelated_uv - vec2(rgb_split_amount * random(uv), 0.0)).b;
	    
	    // 目标纹理RGB分离采样
	    vec3 target_color;
	    target_color.r = texture(target_texture, pixelated_uv + vec2(rgb_split_amount * (1.0 - random(uv)), 0.0)).r;
	    target_color.g = texture(target_texture, pixelated_uv).g;
	    target_color.b = texture(target_texture, pixelated_uv - vec2(rgb_split_amount * (1.0 - random(uv)), 0.0)).b;
	    
	    // 随机破碎混合，随机偏移混合阈值（避免线性插值的单调感）
	    float mix_threshold = progress + (random(uv * 20.0) - 0.5) * 0.25;
	    mix_threshold = clamp(mix_threshold, 0.0, 1.0);
	    float mix_factor = smoothstep(0.0, 1.0, mix_threshold);
	    
	    // 随机闪烁（部分区域提前/延迟切换纹理）
	    float flash_rand = random(uv * 30.0 + time * 2.0);
	    if (flash_rand < progress * 0.3) {
	        mix_factor = 1.0; // 随机显示目标纹理
	    } else if (flash_rand > 1.0 - (1.0 - progress) * 0.3) {
	        mix_factor = 0.0; // 随机显示初始纹理
	    }
	    
	    // 电子噪点+扫描线叠加
	    // 随机噪点（模拟信号干扰）
	    float noise = random(uv * 100.0 + time * 4.0) * noise_strength * glitch_strength;
	    // 扫描线效果（老式显示器风格）
	    float scanline = sin(uv.y * scanline_freq * 2.0 + time * 12.0) * 0.04 * glitch_strength;
	    
	    // 最终颜色合成
	    vec3 final_color = mix(current_color, target_color, mix_factor);
	    final_color += noise + scanline; // 叠加噪点和扫描线
	    final_color = clamp(final_color, 0.0, 1.0); // 防止颜色溢出
	    
	    COLOR = vec4(final_color, 1.0);
	}
}