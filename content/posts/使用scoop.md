---
title: 使用scoop
date: 2020-03-28T21:45:33+08:00
tags: ["scoop"]
category: ["技术"]
---

# 安装

## 允许本地脚本执行

```powershell
$ set-executionpolicy remotesigned -scope currentuser
```

## 自定义scoop安装路径

```powershell
$ [environment]::setEnvironmentVariable('SCOOP','D:\scoop','User')
$ $env:SCOOP='D:\scoop'
```

## 执行安装脚本

```powershell
$ iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
```

