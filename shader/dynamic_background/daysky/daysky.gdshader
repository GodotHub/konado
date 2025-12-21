shader_type canvas_item;
render_mode unshaded;

// 可调节参数
uniform float cloudscale = 1.1;
uniform float speed = 0.03;
uniform float clouddark = 0.5;
uniform float cloudlight = 0.3;
uniform float cloudcover = 0.2;
uniform float cloudalpha = 8.0;
uniform float skytint = 0.5;
uniform vec3 skycolour1 = vec3(0.2, 0.4, 0.6);
uniform vec3 skycolour2 = vec3(0.4, 0.7, 1.0);

// 替代mat2的向量表示
const vec2 m_row1 = vec2(1.6, 1.2);
const vec2 m_row2 = vec2(-1.2, 1.6);

// 手动实现2x2矩阵乘法
vec2 multiply_mat2(vec2 v) {
    return vec2(
        dot(m_row1, v),
        dot(m_row2, v)
    );
}

// 哈希函数生成随机向量
vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

// 2D噪声生成函数
float noise(in vec2 p) {
    const float K1 = 0.366025404; // (sqrt(3)-1)/2
    const float K2 = 0.211324865; // (3-sqrt(3))/6

    vec2 i = floor(p + (p.x + p.y) * K1);
    vec2 a = p - i + (i.x + i.y) * K2;
    vec2 o = (a.x > a.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec2 b = a - o + K2;
    vec2 c = a - 1.0 + 2.0 * K2;

    vec3 h = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    vec3 n = h * h * h * h * vec3(dot(a, hash(i)), dot(b, hash(i + o)), dot(c, hash(i + 1.0)));
    return dot(n, vec3(70.0));
}

// 分形布朗运动
float fbm(vec2 n) {
    float total = 0.0;
    float amplitude = 0.1;
    for (int i = 0; i < 7; i++) {
        total += noise(n) * amplitude;
        n = multiply_mat2(n);  // 使用替代的矩阵乘法
        amplitude *= 0.4;
    }
    return total;
}

void fragment() {
    // 获取UV坐标并调整宽高比
    vec2 p = UV;
    float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    vec2 uv = p * vec2(aspect_ratio, 1.0);

    // 设置时间变量
    float time = TIME * speed;
    float q = fbm(uv * cloudscale * 0.5);

    // 生成脊状噪声
    float r = 0.0;
    vec2 ridged_uv = uv * cloudscale;
    ridged_uv -= q - time;
    float weight = 0.8;

    for (int i = 0; i < 8; i++) {
        r += abs(weight * noise(ridged_uv));
        ridged_uv = multiply_mat2(ridged_uv) + time;  // 手动矩阵乘法
        weight *= 0.7;
    }

    // 生成基础噪声形状
    float f = 0.0;
    vec2 base_uv = uv * cloudscale;
    base_uv -= q - time;
    weight = 0.7;

    for (int i = 0; i < 8; i++) {
        f += weight * noise(base_uv);
        base_uv = multiply_mat2(base_uv) + time;  // 手动矩阵乘法
        weight *= 0.6;
    }

    f *= r + f;

    // 生成噪声颜色
    float c = 0.0;
    float color_time = TIME * speed * 2.0;
    vec2 color_uv = uv * cloudscale * 2.0;
    color_uv -= q - color_time;
    weight = 0.4;

    for (int i = 0; i < 7; i++) {
        c += weight * noise(color_uv);
        color_uv = multiply_mat2(color_uv) + color_time;  // 手动矩阵乘法
        weight *= 0.6;
    }

    // 生成脊状噪声颜色
    float c1 = 0.0;
    color_time = TIME * speed * 3.0;
    color_uv = uv * cloudscale * 3.0;
    color_uv -= q - color_time;
    weight = 0.4;

    for (int i = 0; i < 7; i++) {
        c1 += abs(weight * noise(color_uv));
        color_uv = multiply_mat2(color_uv) + color_time;  // 手动矩阵乘法
        weight *= 0.6;
    }

    c += c1;

    // 混合天空颜色
    vec3 skycolour = mix(skycolour2, skycolour1, p.y);

    // 计算云的颜色
    vec3 cloudcolour = vec3(1.1, 1.1, 0.9) * clamp((clouddark + cloudlight * c), 0.0, 1.0);

    // 最终云层形状
    f = cloudcover + cloudalpha * f * r;

    // 混合天空和云层
    vec3 result = mix(skycolour, clamp(skytint * skycolour + cloudcolour, 0.0, 1.0),
                      clamp(f + c, 0.0, 1.0));

    COLOR = vec4(result, 1.0);
}