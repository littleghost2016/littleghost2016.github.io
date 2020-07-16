---
title: "学习scikit-Learn"
date: 2020-07-14T21:23:07+08:00
tags: ["机器学习", "sklearn"]
categories: ["技术"]
---

# 安装

使用`scoop`很简单地安装`Anaconda3`

```powershell
scoop install anaconda3
```

# 配置环境并激活

## 创建环境

```powershell
conda create -n learn-scikit
```

## 激活环境

```powershell
conda activate learn-scikit
```

## 退出环境

```powershell
conda deactive
```

## 删除环境

```powershell
conda remove -n learn-scikit --all
```

## 列出当前所有已创建的环境

```powershell
conda env list
```

*`Windows`上的最新命令`activate`和`deactivate`前都有加`conda`了，以前不加可以使用，但现在必须要加了。*

## 解决Collecting package metadata (current_repodata.json): failed

方案来自GitHub [#9554](https://github.com/conda/conda/issues/9554) [#9555](https://github.com/conda/conda/issues/9555)

> Copy files libcrypto-1_1-x64.dll and libssl-1_1-x64.dll from the directory ./Anaconda3/Library/bin/ to ./Anaconda3/DLLs.

## 解决Your shell has not been properly configured to use 'conda activate'

使用`Windows Terminal`的`PowerShell`时，输入`conda activate learn-scikit`会显示无法使用`conda activate`，即使我按照提示使用`conda init powershell`命令后也不行，于是转而想使用`Anaconda`自带的`Anaconda Powershell Prompt`，于是往`Windows Terminal`的设置里面添加一个`Anaconda`的标签页。

以下内容添加至`Windows Terminal`的`setting.json`，`profiles`的`list`里

```json
{
	// Make changes here to the cmd.exe profile.
	"guid": "{0caa0dad-35be-5f56-a8ff-afceee452369}",
	"name": "Anaconda",
	"icon": "%USERPROFILE%\\scoop\\apps\\anaconda3\\current\\Menu\\anaconda-navigator.ico",
	"commandline": "%windir%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -ExecutionPolicy ByPass -NoExit -Command \"& 'C:\\Users\\LittleGhost\\scoop\\apps\\anaconda3\\2020.02\\shell\\condabin\\conda-hook.ps1'\"",
	"hidden": false
}
```

*注意`commandline`这一项，后面的`C:\\Users\\LittleGhost\\scoop\\apps\\anaconda3\\2020.02\\shell\\condabin\\conda-hook.ps1`请根据情况自行修改，直接复制以上配置肯定是会出错的。*