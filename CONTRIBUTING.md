# 贡献指南

## 贡献方式

- **Pull Request**：提交代码到仓库  
- **Issue**：提交问题或建议

## 代码贡献流程  
1. **Fork 项目**：点击右上角 Fork 到自己的仓库  
2. **创建分支**：`git checkout -b feature/your-feature`  
3. **提交更改**：`git commit -m "feat: 描述你的更改"`  
4. **推送分支**：`git push origin feature/your-feature`  
5. **提交 PR**：创建 Pull Request

贡献后的代码会经过代码审查，通过后合并到主分支，并会添加贡献者到贡献者列表。

## 注释规范

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

请在每个函数上方添加注释：

```gdscript
## 函数功能描述，参数描述，返回值描述
func_name(param1, param2):
    # 函数实现
    pass
```

请在每个类成员变量上方添加注释：

```gdscript
## 变量描述，变量用途
var_name: Type = None
```

请给逻辑复杂的判断、循环、函数等添加注释，方便他人理解：

```gdscript
if condition:
    # 判断条件成立时的处理逻辑
    pass
else:
    # 判断条件不成立时的处理逻辑
    pass
```

## 测试

每次提交代码前建议先运行测试，确保代码质量，也可以等待其他开发者进行代码审查。

可以通过以下命令安装依赖并运行自动化检查测试：

```powershell
pip3 install "gdtoolkit==4.*"
python gdlinter.py --ignore addons/gut
```


## 问题反馈  
- **Bug 报告**：描述问题，需包含重现步骤
- **功能建议**：在 Issue 区描述需求背景和预期效果
