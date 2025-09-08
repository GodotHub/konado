# 安装

## 依赖环境

- 需要使用 **Godot 4.4 或更高版本**。
- 建议通过 **Git** 安装插件，以获得更好的版本管理和更新支持。

## 安装步骤

1. 安装Git，在使用apt包管理器的Linux发行版可以直接执行`sudo apt install git`
2. 新建Godot项目
3. 新建插件文件夹`addons`
4. 在项目根目录打开终端
5. 执行`git clone https://gitcode.com/godothub/konado addons/konado` 下载插件
6. 在Godot项目设置中启用插件

## 作为子模块安装

如果您希望将konado作为子模块安装，可以按照以下步骤操作

进入项目根目录后执行以下命令
```bash
git submodule add https://gitcode.com/godothub/konado addons/konado
```

递归更新子模块
```bash
git submodule update --remote
```