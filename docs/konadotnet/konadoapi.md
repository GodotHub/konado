# Konadotnet - Konado .NET API

## 简介

Konado的.NET API，用于在Godot C#项目中使用Konado API来控制Konado对话，该项目是Konado项目的一部分。

## 依赖

- Godot 4.4.1 C# 版本
- .NET 8.0 SDK
- Konado

## 使用方法

请先启用Konado插件，然后再启用Konado .NET API插件。

首次启用 Konado.NET，会遇到如下报错：

```
无法从路径 “res://addons/konadotnet/Konadotnet.cs” 加载附加组件脚本：该脚本可能有代码错误。
正在禁用位于 “res://addons/konadotnet/plugin.cfg” 的附加组件以阻止其进一步报错。
```

这是正常现象，请重新在Godot编译 Konado.NET，然后重新打开项目即可解决。

如果无法启用插件，并且在MSBuild中没有任何报错，可以尝试关闭项目后，删除项目根目录的 .godot/ 文件夹，然后重新生成项目。

