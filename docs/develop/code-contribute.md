# 代码贡献指南

## 贡献方式

无论是文档、代码还是其他内容，都可以通过以下方式贡献：

- **Pull Request**：提交代码到仓库，经过代码审查后合并到主分支
- **Issue**：提交问题或建议，经过讨论后决定是否实现，并分配给开发者


## 代码贡献流程

在提交代码之前请确保在本地完成了 Git 的全局配置。本地Git的提交邮箱和用户名**需要和平台上注册的邮箱和用户名保持一致**，否则会产生错误的提交记录，并无法计入贡献者名单。

如果你不确定自己的邮箱和用户名是否正确，请在终端查看你的 Git 配置：

```shell
git config --global user.name
git config --global user.email
```

如果需要修改，可以使用以下命令：

```shell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

完成配置后，建议重启终端，以确保配置生效。

1. **Fork 项目**：点击右上角 Fork 到自己的仓库  
2. **创建分支**：`git checkout -b feature/your-feature`  
3. **提交更改**：`git commit -m "feat: 描述你的更改"`  
4. **推送分支**：`git push origin feature/your-feature`  
5. **提交 PR**：创建 Pull Request

贡献后的代码会经过代码审查，通过后合并到主分支。

## GDScript 编程规范参考

本项目遵守 Godot 官方文档中的 [GDScript 编写风格指南](https://docs.godotengine.org/zh-cn/4.x/tutorials/scripting/gdscript/gdscript_styleguide.html) 的代码规范，以下是一些参考规范：

### 格式规范
- **缩进**：使用制表符而非空格，每级缩进一个制表符
- **行长度**：控制在100字符以内，推荐80字符以下，不然容易影响阅读
- **换行**：使用LF换行，文件末尾保留换行符，避免Git冲突
- **编码**：UTF-8无BOM，避免乱码

一般来说使用 Godot 默认的脚本编辑器或者 VSCode 可以自动满足这些格式规范，如果使用其他编辑器，请注意这些规范。

### 命名约定
| 元素类型 | 命名风格 | 示例 |
|---------|---------|------|
| 文件名 | snake_case | `player_controller.gd` |
| 类名 | PascalCase | `class_name PlayerController` |
| 函数/变量 | snake_case | `func move_player()` |
| 信号 | snake_case（过去时） | `signal door_opened` |
| 常量 | CONSTANT_CASE | `const MAX_HEALTH = 100` |
| 枚举名 | PascalCase | `enum GameState` |
| 枚举值 | CONSTANT_CASE | `IDLE, RUNNING, JUMPING` |

脚本中只允许使用英文命名，不允许使用其他语言，避免出现问题。

### 注释规范

- **类注释**：每个类顶部都需要注释，描述类的功能和使用方法，这个注释会自动生成到文档中，请尽可能详细
- **函数注释**：每个公共函数顶部都需要注释，描述函数的功能、参数和返回值，如果是私有函数，或者是内部工具函数，可以省略注释
- **变量注释**：建议给必要的变量添加注释，特别是那些具有特定含义或用途的变量
- **信号注释**：每个信号顶部都需要注释，描述信号的用途和参数
- **TODO注释**：如果需要添加待办事项，请使用 `TODO` 注释，并描述待办事项的内容和优先级


## 提交规范

对于一个开源项目来说，提交信息初期学习成本和适应过程确实需要一些努力，但它带来的长期回报是巨大的。“严格”的信息规范可以节省开发者之间理解和沟通时间，同时也为变更日志（CHANGELOG）的生成提供了便利，使得变更日志的生成更加规范。


### Commit 信息

本项目参考了Conventional Commits 1.0.0规范，具体格式如下：

```
<type>(<scope)>: <subject>
```

包括三个字段：`type`（必需）、`scope`（可选）和 `subject`（必需）。

**`type`（类型）** 用于说明 commit 的类别，必须使用以下标识之一：

| 类型         | 说明                                     |
| :----------- | :--------------------------------------- |
| **feat**     | 新功能（feature）                        |
| **fix**      | 修复 bug                                |
| **docs**     | 修改文档（documentation）               |
| **test**     | 增加测试或修改现有测试                   |
| **ci**       | 对 CI 配置文件和脚本的更改               |

**`scope`（范围）** 用于说明 commit 影响的范围，视项目而定。例如可以是模块、组件、文件等。
*   `feat(something): ...`
*   `fix(ui): ...`
*   `docs(readme): ...`
*   如果影响范围广，可以省略或者使用(*)。

**`subject`（主题）** 是本次提交目的的简短描述。

示例如下：

```
feat(xxx): 添加回放功能
fix: 修复了回放功能中回放速度过快导致程序崩溃的问题
docs(readme): 更新了readme
```

### Pull Request

PR（Pull Request）用于将你的代码提交到主仓库的主分支。在提交 PR 之前，请确保你的代码符合以下规范：

1. 代码格式规范，符合项目的代码风格。
2. 提交信息规范，符合 Git Commit 信息规范。
3. 提交的代码经过测试，无已知的问题。

如果以上条件基本满足，就可以开始提交 PR 了。

### PR 提交规范

PR 信息需要包含以下内容：

1. **标题**：简洁明了地描述 PR 的内容，可以采用Git Commit 信息。
2. **描述**：详细描述 PR 的内容，包括实现功能说明、实现方式、影响范围等。
3. **issue关联**：如果 PR 是针对某几个 issue 的修复，请将 issue 的链接添加到 PR 信息中。

::: tip 其他建议
1. 为了节约维护者的时间和精力，PR描述应尽可能详细。  
2. 除了简单的bug修复或文字改动，都需要写一篇像“小作文”一样的PR正文，最好事无巨细。  
3. 有时PR里的commit内容需要修改，请随时关注PR评论区里的讨论。
4. 并非所有PR都会被合并，在此提前向您表示抱歉。
:::