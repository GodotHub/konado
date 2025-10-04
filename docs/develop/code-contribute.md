# 代码贡献指南

## 贡献方式

无论是文档、代码还是其他内容，都可以通过以下方式贡献：

- **Pull Request**：提交代码到仓库，经过代码审查后合并到主分支
- **Issue**：提交问题或建议，经过讨论后决定是否实现，并分配给开发者


## 代码贡献流程

在提交代码之前请确保在本地完成了 Git 的全局配置
```
git config --global user.name 你的Git用户名
git config --global user.email 你的提交邮箱，必须和代码平台账户邮箱一致
```

1. **Fork 项目**：点击右上角 Fork 到自己的仓库  
2. **创建分支**：`git checkout -b feature/your-feature`  
3. **提交更改**：`git commit -m "feat: 描述你的更改"`  
4. **推送分支**：`git push origin feature/your-feature`  
5. **提交 PR**：创建 Pull Request

详细的提交规范请参考 [提交规范](./contribution-standards.md) 文档。


## GDScript 编程规范总结

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