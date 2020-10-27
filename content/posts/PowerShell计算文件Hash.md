---
title: "PowerShell计算文件Hash"
date: 2020-10-22T00:38:24+08:00
tags: ["powershell"]
categories: ["技术"]
---

废话少说，直接上命令。

# 命令

```powershell
Get-FileHash C:\Windows\notepad.exe -Algorithm MD5| Format-List
```

其中`MD5`可使用以下选项进行替换

- SHA1
- SHA256（默认）
- SHA384
- SHA512
- MD5

# 吐槽

`PowerShell`比`CMD`的功能多好多了，以前还要专门下载软件计算文件Hash。