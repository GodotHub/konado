## Konado Script

Konado Script 是一种专为视觉小说游戏设计的 **领域特定语言(Domain Specific Language)** ，文件扩展名为`.ks`。它采用纯文本格式（UTF-8编码），允许开发者通过简洁的指令集描述视觉小说的所有元素，包括剧情流程、角色表现、场景转换、分支选择等。

## 设计理念

### 1. 内容与逻辑分离
Konado Script 的核心设计理念是将**故事内容**与**程序逻辑**分离：
- 编剧专注于叙事内容，无需编程知识
- 程序员专注于引擎开发，无需介入故事创作
- 资源管理（图片、音频）通过标识符引用，与脚本解耦

### 2. 直观的表达能力
语法设计模拟人类自然表达方式：
```text
"alice" "这不是我的错！你根本不懂！"
actor show bob surprised at 400 300 scale 0.8
background sunset fade
```
每行指令都直观表达游戏中的一个动作或事件，接近电影分镜脚本。

### 3. 线性流程与分支控制
- 默认顺序执行，符合故事叙事逻辑
- 通过`choice`和`jump`实现分支剧情
- 章节化结构（chapter_id/chapter_name）支持大型剧本管理

### 4. 轻量级与可扩展性
- 纯文本格式，体积小加载快
- 模块化指令集，易于扩展新功能
- 兼容版本控制系统（Git等）

## 核心优势

### 1. 开发效率提升
```mermaid
graph LR
    A[编剧] -->|撰写KS脚本| B[Konado引擎]
    C[美术] -->|提供素材资源| B
    D[程序] -->|维护引擎和框架| B
    B --> E[可运行游戏]
```
多角色并行工作，缩短开发周期50%以上。

### 2. 零编程门槛
非技术人员也能参与开发：
- 基础指令平均学习时间<30分钟
- 直观的对话系统：`"角色" "内容"`
- 可视化编辑器友好（未来规划）

### 3. 强大的表现力
```text
# 复杂场景示例
background castle_night blinds
play bgm mystery
actor show vampire smile at -200 450 mirror
actor move vampire 300 450
"vampire" "你终于来了...我等待这一刻很久了" vamp_voice_07
```

### 4. 跨平台兼容性
- 文本格式天生跨平台
- 资源引用与平台无关
- 解析器可轻松移植到各种游戏引擎


## 应用场景

- AVG文字冒险
- 视觉小说
- 互动故事游戏
- 电子漫画/有声读物
- 游戏剧情原型设计

## 总结

Konado Scripts 通过精心设计的领域特定语言，在**创作自由度**与**开发效率**之间取得完美平衡。它既保留了文本脚本的灵活性和可读性，又通过结构化指令提供了足够的表达能力，使视觉小说开发从技术密集型转变为内容导向型创作。