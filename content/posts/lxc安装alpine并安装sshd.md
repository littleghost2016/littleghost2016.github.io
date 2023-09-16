---
title: "lxc安装alpine并安装sshd"
date: 2023-09-12T21:11:41+08:00
tags: ["alpine", "ssh"]
categories: ["技术"]
---

> 参考自[Alpine安装SSH服务，并开启SSH远程登录 - 初心 (mayanpeng.cn)](https://mayanpeng.cn/archives/248.html)

# 更换软件源

```bash
$ sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```

# 安装sshd

```bash
$ apk add openssh-server
```

# 启动sshd

```bash
$ rc-service sshd start
```

# 设置开机启动

```bash
$ rc-update add sshd
```

# 取消开机启动

```bash
$ rc-update del sshd
```

# 重启sshd服务

```bash
$ rc-service sshd restart
```

# 显示所有服务

```bash
$ rc-status -a
```

# 安装oh-my-zsh

```bash
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

