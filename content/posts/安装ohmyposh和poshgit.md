---
title: "安装ohmyposh和poshgit"
date: 2022-04-28T18:43:44+08:00
tags: ["powershell", "ohmyposh", "poshgit"]
categories: ["技术"]
---

# 操作系统信息

| 版本             | Windows 10 企业版 LTSC |
| ---------------- | ---------------------- |
| 版本号           | 21H2                   |
| 安装日期         | ‎2021/‎11/‎24             |
| 操作系统内部版本 | 19044.1645             |

# 系统自带powershell信息

使用`host`命令查看powershell信息。

```powershell
host
```

```
Name             : ConsoleHost
Version          : 5.1.19041.1645
InstanceId       : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
UI               : System.Management.Automation.Internal.Host.InternalHostUserInterface
CurrentCulture   : zh-CN
CurrentUICulture : zh-CN
PrivateData      : Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy
DebuggerEnabled  : True
IsRunspacePushed : False
Runspace         : System.Management.Automation.Runspaces.LocalRunspace
```

目前位5.1版本，将先安装最新版本的powershell。

# 安装powershell

使用微软商城搜索并（MicroSoft Store）安装，安装完成后使用最新版。使用`host`命令查看最新版powershell信息。

```powershell
host
```

```
Name             : ConsoleHost
Version          : 7.2.3
InstanceId       : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
UI               : System.Management.Automation.Internal.Host.InternalHostUserInterface
CurrentCulture   : zh-CN
CurrentUICulture : zh-CN
PrivateData      : Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy
DebuggerEnabled  : True
IsRunspacePushed : False
Runspace         : System.Management.Automation.Runspaces.LocalRunspace
```

最新版本位7.2.3

# 使用scoop安装oh-my-posh和posh-git

```powershell
scoop install oh-my-posh
scoop install posh-git
```

# 修改配置文件

使用vscode打开配置文件

```powershell
code $PROFILE
```

修改配置文件内容

```
oh-my-posh init pwsh --config "你的主题路径.omp.json" | Invoke-Expression

Import-Module posh-git
Set-PSReadLineOption -PredictionSource History # 设置预测文本来源为历史记录
Set-PSReadlineKeyHandler -Key Tab -Function Complete # 设置 Tab 键补全
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function MenuComplete # 设置 Ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo # 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward # 设置向下键为前向搜索历史纪录
```

关闭powhershell，重新打开。powershell有主题了而且能够通过历史命令自动补全。

> [ohmyposh官网指导文档](https://ohmyposh.dev/docs/installation/windows)
>
> [给 PowerShell 带来 zsh 的体验](https://zhuanlan.zhihu.com/p/137251716)

# 快捷键

| 快捷键      | 功能                     |
| ----------- | ------------------------ |
| esc         | 删除命令行中的所有内容   |
| ctrl + home | 删除当前位置到开始的内容 |
| ctrl + end  | 删除当前位置到结束的内容 |
