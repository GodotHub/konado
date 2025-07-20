## 代码贡献指南

## 贡献方式

无论是文档、代码还是其他内容，都可以通过以下方式贡献：

- **Pull Request**：提交代码到仓库，经过代码审查后合并到主分支
- **Issue**：提交问题或建议，经过讨论后决定是否实现，并分配给开发者

## 代码贡献流程  

1. **Fork 项目**：点击右上角 Fork 到自己的仓库  
2. **创建分支**：`git checkout -b feature/your-feature`  
3. **提交更改**：`git commit -m "feat: 描述你的更改"`  
4. **推送分支**：`git push origin feature/your-feature`  
5. **提交 PR**：创建 Pull Request

贡献后的代码会经过代码审查，通过后合并到主分支。

## 文档贡献流程

### 在线编辑

在线编辑文档，点击在线文档左下角的 `在 GitCode 上编辑此页`，浏览器会跳转到仓库文件所在目录位置，此时点击右上角 `编辑` 按钮，修改后预览查看效果，确认无误后点击 `提交修改` 提交。

提交后会经过审查，通过后合并到主仓库。一般主仓库合并后，在线文档会自动更新，如果没有更新，请手动刷新页面，或者提交后等待几分钟再刷新。

### 本地编辑

文档可以直接向master分支提交PR，不必创建分支。

1. **Fork 项目**：点击右上角 Fork 到自己的仓库  
2. **克隆仓库**：`git clone https://gitcode.net/your_username/konado.git`  
4. **编辑文档**：在 `docs` 目录下找到需要修改的文件，使用 Markdown 语法进行编辑（参考 [Markdown 语法](https://www.markdownguide.org/basic-syntax/)）
5. **提交更改**：`git commit -m "描述你的文档更改"`  
6. **推送分支**：`git push origin master`

提交后，点击右上角 `Pull Request` 按钮，创建 Pull Request。

## 开发规范

请在每个文件头部添加以下注释：

```
################################################################################
# Project: Konado
# File: your_srcipt.gd
# Author: Your Name <your_email@example.com>
# Created: [YYYY-MM-DD]
# Last Modified: [YYYY-MM-DD]
# Description:
#   [描述功能]
################################################################################
```

Author字段建议填写Git用户名，功能描述请尽量详细，方便他人理解。

## 其他贡献

如果你有其他形式的贡献，例如：翻译、测试、推广等，欢迎随时联系我们。

## 问题反馈  

- **Bug 报告**：描述问题，需包含重现步骤
- **功能建议**：在 Issue 区描述需求背景和预期效果
- **文档改进**：在 Issue 区描述需要改进的地方

