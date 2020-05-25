---
title: 安装zsh以及oh-my-zsh
date: 2018-07-21T18:03:54+08:00
tags: ["zsh"]
categories: ["技术"]
---

# zsh

```bash
$ sudo apt install zsh git
```

# oh-my-zsh

```bash
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# or 

$ sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

## zsh替换bash

```bash
$ vim ~/.bash_profile
```

```
exec zsh
source ~/.zshrc
```

## 更改配置

```bash
$ vim ~/.zshrc
```

```
#ZSH_THEME="rubbyrussell"
ZSH_THEME="ys"
```

