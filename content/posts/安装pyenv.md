---
title: 安装pyenv
date: 2021-11-21 10:53:44
tags: ["pyenv", "python"]
categories: ["技术"]
---

# 项目地址

> https://github.com/pyenv/pyenv

# 安装手册

> [Home · pyenv/pyenv Wiki (github.com)](https://github.com/pyenv/pyenv/wiki)

# 安装编译Python所需的依赖

```bash
$ sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

# 使用项目自带脚本安装pyenv

```bash
$ curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
```

# 写入配置

## 方法1：命令

```bash
$ echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
$ echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
$ echo 'eval "$(pyenv init --path)"' >> ~/.zprofile

$ echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
$ echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
$ echo 'eval "$(pyenv init --path)"' >> ~/.profile

$ echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

## 方法2：直接写入文件

```bash
$ vim ~/.zprofile
```

```
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```

```bash
$ vim ~/.profile
```

```
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```

```bash
$ vim ~/.zshrc
```

```
# pyenv
eval "$(pyenv init -)"
```

# 测试安装

```bash
$ pyenv -v
```

```
pyenv 2.2.3
```

