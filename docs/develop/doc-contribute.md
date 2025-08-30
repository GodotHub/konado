# 文档贡献指南

## 在线编辑

在线编辑文档，点击在线文档左下角的 `在 GitCode 上编辑此页`，浏览器会跳转到仓库文件所在目录位置，此时点击右上角 `编辑` 按钮，修改后预览查看效果，确认无误后点击 `提交修改` 提交。

提交后会经过审查，通过后合并到主仓库。一般主仓库合并后，在线文档会自动更新，如果没有更新，请手动刷新页面，或者提交后等待几分钟再刷新。

## 本地编辑

文档可以直接向master分支`提交PR`，不必创建分支。

1. **Fork 项目**：点击右上角 Fork 到自己的仓库  
2. **克隆仓库**：`git clone https://gitcode.net/your_username/konado.git`  
3. **编辑文档**：在 `docs` 目录下找到需要修改的文件，使用 Markdown 语法进行编辑（参考 [Markdown 语法](https://www.markdownguide.org/basic-syntax)）
4. **提交更改**：`git commit -m "描述你的文档更改"`  
5. **推送分支**：`git push origin master`

提交后，在自己fork的仓库页面、点击`Pull Request`按钮，创建 PR。
