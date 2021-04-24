---
title: git-stash学习
date: 2019-11-04T20:24:20+08:00
tags: ["git", "hexo"]
categories: ["技术"]
---
# 背景

昨天继续部署[hexo](https://github.com/hexojs/hexo)的时候发现自己使用的主题[fexo](https://github.com/forsigner/fexo)在Github上有新的commit，于是想对主题进行升级。

# 更新仓库文件

查看fexo文件夹

```bash
$ tree -L 1 .
```

```
.
├── _config.yml
├── gulpfile.js
├── languages
├── layout
├── LICENSE
├── package.json
├── README.md
├── scripts
├── source
└── yarn.lock
```

直接使用`git pull`命令发现`_config.yml`因被修改过而引起冲突，不能直接将仓库进行`pull`更新，上网搜索“hexo更新主题”，发现了`git stash`命令。

1. 使用`git stash`将修改入栈，即执行命令后`_config.yml`变成了该版本对应文件的最初始状态（因为我在修改`_config.yml`之后未进行追踪和提交，所以`git stash`后变成最初始状态）。

   ```bash
   $ git stash
   ```

2. 此时执行`git status`发现没有任何更改。执行`git pull`更新仓库。

   ```bash
   $ git pull
   ```

3. 执行`git stash pop`将已经入栈的被修改文件出栈到当前文件夹，即完成了保留`_config.yml`文件的修改，并更新了其他文件的效果。*此时栈为空。*

   ```bash
   $ git stash pop
   ```

# 关于git stash

 能够将所有未提交的修改（工作区和暂存区）保存至堆栈中，用于后续恢复当前工作目录。 

## git stash save "test1"

作用同`git stash`，`save`会指定一个名称，`drop`命令可以根据名称删除对应内容。

```
tash@{0}: On master: test1
```

## git stash list

查看当前stash中的内容。

## git stash pop

当前stash中的最后进入的内容出栈，并应用到当前分支对应的工作目录上。 
 *注：该命令将堆栈中最近保存的内容删除（栈是先进后出）。* 

## git stash apply

恢复stash中的修改，但与`pop`不同的是，`apply`从栈中删除内容。

## git stash drop "test1"

stash栈中删除名为"test1"的内容。

## git stash clear

清除stash栈中的所有内容。

## git stash show

显示stash栈中的所有内容。

# 插一句：解决git中文乱码

```bash
$ git config --global core.quotepath false
```

# 再插一句

`github-production-release-asset-2e65be.s3.amazonaws.com`国内是访问不了的，`wget`和`curl`都不能下载到内容，可绑定ip试试。

```
52.216.20.147 github-production-release-asset-2e65be.s3.amazonaws.com
```

> [brew安装失败 #312](https://github.com/oldj/SwitchHosts/issues/312)