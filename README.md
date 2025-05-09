# Konado 可娜多

![star](https://gitcode.com/shengjing/Konado/star/badge.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)

<p align="center">
  <img src="./assets/KonadoBanner.png" alt="看板娘多文" width=596px>
</p>


<p align="center">
<span style="font-size:12px;">看板娘可娜</span>
<span style="font-size:12px;">画师: Marukles</span>
</p>

## 简介
Konado是一个对话创建工具，提供多种对话模板以及对话管理器，可以快速创建对话游戏，也可以嵌入各类游戏的对话场景。

## 安装

### 依赖环境

- Godot 4.4 或更高版本
- 建议通过Git安装插件

### 安装步骤

1. 安装Git，在使用apt包管理器的Linux发行版可以直接执行`sudo apt install git`
2. 新建Godot项目
3. 新建插件文件夹`addons`
4. 在项目根目录打开终端
5. 执行`git clone https://gitcode.com/shengjing/Konado.git addons/konado` 下载插件
6. 在Godot项目设置中启用插件

#### 作为子模块安装

进入项目根目录后执行以下命令
```bash
git submodule add https://gitcode.com/shengjing/Konado.git addons/konado
```

递归更新子模块
```bash
git submodule update --remote
```

### 常见问题
- 插件无法加载：确保插件文件夹路径正确，且Godot版本符合要求


## Konado Scripts 语法规范

## 文件结构
- 文件扩展名：`.ks`
- 编码格式：UTF-8
- 基础结构：
```text
chapter_id [章节ID]
chapter_name [章节名称]
[内容行...]
```

## 元数据规范
### 章节标识
```text
chapter_id chapter01
```
- 必须为文件首行
- 使用英文+数字组合
- 推荐格式：`chapter`+数字编号

### 章节名称
```text
chapter_name 序章：命运的相遇
```
- 必须为文件第二行
- 支持任意Unicode字符
- 显示在游戏章节选择界面

## 内容指令集

### 1. 背景切换
```text
background [图片资源名] <效果类型>
```
- 参数说明：
  - 图片资源名：不带扩展名的纹理文件名
  - 效果类型（可选）：
	- erase：淡出
	- blinds：百叶窗
	- wave：波浪
	- fade：淡入
- 示例：
```text
background morning_room fade
background battle_field wave
```

### 2. 角色控制
#### 显示角色
```text
actor show [角色ID] [状态] at [x] [y] scale [比例]
```
- 参数说明：
  - 角色ID：角色资源标识符
  - 状态：对应角色不同立绘状态
  - 坐标：场景坐标系（单位：像素）
  - 比例：显示缩放（1.0为原始大小）
- 示例：
```text
actor show alice normal at 300 450 scale 0.9
```

#### 隐藏角色
```text
actor exit [角色ID]
```
- 示例：
```text
actor exit bob
```

#### 状态变更
```text
actor change [角色ID] [新状态]
```
- 示例：
```text
actor change alice angry
```

#### 角色移动
```text
actor move [角色ID] [目标x] [目标y]
```
- 示例：
```text
actor move alice 500 320
```

### 3. 音频控制
#### 播放BGM
```text
play bgm [音乐ID]
```
- 示例：
```text
play bgm battle_theme
```

#### 播放音效
```text
play se [音效ID]
```
- 示例：
```text
play se sword_clash
```

#### 停止BGM
```text
stop bgm
```

### 4. 分支选项


#### 标签
```text
tag [标签ID]
```
- 示例：
```text
tag 这是一个标签
```


#### 标签跳转
```text
choice "选项文本1" [跳转ID1] "选项文本2" [跳转ID2]...
```
- 规则说明：
  - 最多支持4个选项
  - 文本需用双引号包裹
  - 跳转ID对应标签ID
- 示例：
```text
choice "进入战斗" tag1 "尝试逃跑" tag2
```



### 5. 对话系统
```text
"角色ID" "对话内容" <语音ID>
```
- 语法规则：
  - 必须用双引号包裹字段
  - 语音ID为可选参数
  - 支持转义字符：\n 换行、\" 显示引号
- 示例：
```text
"narrator" "暴风雨即将来临..." storm_voice_12
"alice" "这不是我的错！\n你根本不懂！" alice_angry_03
```

### 7. 特殊指令
#### 成就解锁
```text
unlock_achievement [成就ID]
```
- 示例：
```text
unlock_achievement first_blood
```

#### 游戏结束
```text
end
```

## 注释规范
- 单行注释以`#`开头
- 示例：
```text
# 这里是注释内容
background tavern_night  # 夜间酒馆场景
```

## 语法校验规则
1. 行首空格自动忽略
2. 空行自动跳过，但是尽可能避免使用空行
3. 无效指令将触发警告日志
4. 参数缺失会触发错误提示


## 项目贡献者

- [Kamiki_](https://gitcode.com/Kamiki_) - 项目贡献者
- [lgyxj](https://gitee.com/lgyxj) - 为本项目提供shader支持
- 麻卤可乐丝 - 为本项目提供看板娘

## 开源许可证
Konado 使用 MIT 许可证，开源且免费使用，具体内容请查看 [LICENSE](./LICENSE) 文件。
