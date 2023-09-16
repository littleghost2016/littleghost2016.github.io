---
title: "omv安装qbittorrent"
date: 2023-09-12T12:45:35+08:00
tags: ["lxc", "qbittorrent"]
categories: ["技术"]
---

> 参考自[Debian 11安装qbittorrent-nox并设置Nginx反代 - 怕刺 (pa.ci)](https://pa.ci/210.html)

# 安装

```
apt update 
apt install qbittorrent-nox -y
```

# 配置开机自启

```bash
$ vim /etc/systemd/system/qbittorrent-nox.service
```

写入以下内容（我直接在1个新建的lxc中安装qbittorrent，所以直接使用了root用户）

```
[Unit]
Description=qBittorrent Command Line Client
After=network.target
[Service]
Type=forking
User=root
UMask=007
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=80
Restart=on-failure
[Install]
WantedBy=multi-user.target
```

# 解决下载文件中文乱码

下载文件名中有中文时会乱码（一个中文字显示一个"."），使用以下命令

```bash
$ apt install -y locales && sed -i '/^[^#[:space:]]/ s/^\([^#]\)/# \1/' /etc/locale.gen && sed -i '/^# en_US\.UTF-8 UTF-8/ s/^# //' /etc/locale.gen && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 && source /etc/default/locale
```

```bash
$ reboot
```

