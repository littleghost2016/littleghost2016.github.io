---
title: 树莓派搭建aria2+caddy+filebrowser
date: 2019-11-02T23:10:20+08:00
tags: ["树莓派", "aria2", "caddy", "filebrowser"]
categories: ["树莓派"]
---
树莓派为3B+，24小时供电，*就是有点吵*。

# dnsmasq部分

路由器为K2P，刷了Openwrt系统，自带`dnsmasq`，编辑配置文件

```bash
$ vim /etc/dnsmasq.conf
```

添加以下内容，三四两行自用于内网RDP，与本篇文章的内容无关

```
address=/download.com/192.168.2.198
address=/filebrowser.com/192.168.2.198
address=/mylab6.com/2001::XXXX
address=/mylab.com/10.173.XX.XX
```

重新启动`dnsmasq`服务

```bash
$ /etc/init.d/dnsmasq restart
```

# caddy部分

>    Caddy is praised by researchers and industry experts for its **security defaults** and **unparalleled usability**. ——by [caddyserver](https://caddyserver.com/)

`caddy`配置文件简洁，可简单地实现`HTTPS`功能。本次因想尝试新程序而未使用`Nginx`。

1.  从官网下载`caddy`二进制文件

2.  使用`systemd`作进程守护

    ```bash
    $ sudo vim /etc/systemd/system/caddy.service
    ```

    ```
    [Unit]
    Description=Caddy Server
    After=syslog.target
    After=network.target
    
    [Service]
    User=root
    Group=root
    LimitNOFILE=64000
    ExecStart=/home/ubuntu/caddy/caddy -log stdout -agree=true -conf=/home/ubuntu/caddy/config/Caddyfile -root=/home/ubuntu/caddy/www
    Restart=always
    
    [Install]
    WantedBy=multi-user.target
    ```

    *搭建过程中使用ubuntu作为User和Group会报错，尚未解决。*

3.  编辑配置文件`Caddyfile`

    ```
    http://download.com:80 {
            root /home/ubuntu/caddy/www/download.com
            gzip
    }
    
    http://filebrowser.com:80 {
            proxy / 127.0.0.1:7001
            gzip
    }
    ```

    `download.com`使用AriaNG，`filebrowser`则反代端口，因服务目前只架设在内网，均只是用HTTP服务。caddy配置文件确实简洁。

# aria2部分

## 安装

```bash
$ sudo apt install aria2
```

```bash
$ tree .
```

```
.
├── config
│   ├── aria2.conf
│   └── aria2.session
└── downloads
    ├── a
    │   └── 1
    ├── b
    │   ├── 2
    │   └── 3
    ├── c
    │   └── 4
    ├── d
    │   └── 5
    └── e

7 directories, 7 files
```

## 使用`systemd`作进程守护

```bash
$ sudo vim /etc/systemd/system/aria2.service
```

```
[Unit]
Description=aria2c -- file download manager
After=network.target

[Service]
Type=forking
User=ubuntu
Group=ubuntu
#WorkingDirectory=%h
#Environment=VAR=/var/%i
ExecStart=/usr/bin/aria2c -D --conf-path=/home/ubuntu/aria2/config/aria2.conf

[Install]
WantedBy=multi-user.target
```

## 修改配置文件

```bash
$ vim /home/ubuntu/aria2/config/aria2.conf
```

```bash
#RPC
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
#rpc-listen-port=6800
#require &gt;1.15.2
#rpc-user=ftp
#rpc-passwd=ftp123
rpc-secret=XXX

#RATE
max-concurrent-downloads=5
continue=true
max-connection-per-server=5
min-split-size=10M
split=10
max-overall-download-limit=0
max-download-limit=0
max-overall-upload-limit=0
max-upload-limit=0

#B
#PROGRESS
input-file=/home/ubuntu/aria2/config/aria2.session
save-session=/home/ubuntu/aria2/config/aria2.session
#require &gt;1.16.1
save-session-interval=120

#DISK
dir=/home/ubuntu/aria2/downloads
file-allocation=prealloc

#BT
bt-enable-lpd=true
bt-max-peers=80
bt-require-crypto=true
follow-torrent=true
#listen-port=6881-6999
enable-dht=false
bt-enable-lpd=false
enable-peer-exchange=false
peer-agent=uTorrent/2210(25130)
user-agent=uTorrent/2210(25130)
peer-id-prefix=-UT2210-
seed-ratio=0
force-save=true
bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true

listen-port=50000-65000
```

HTTP可以，校内PT站可以下载，但公网上的种子和磁力链接都是`0/0`，尚未解决。

# filebrowser部分

1.  从`Github`下载二进制文件

2.  使用`systemd`作进程守护

    ```
    [Unit]
    Description=File Browser
    After=network.target
    
    [Service]
    User=ubuntu
    Group=ubuntu
    ExecStart=/home/ubuntu/filebrowser/filebrowser -d /home/ubuntu/filebrowser/filebrowser.db
    
    [Install]
    WantedBy=multi-user.target
    ```

    ```bash
    $ tree .
    ```

    ```
    .
    ├── caddy
    ├── caddy_v1.0.3_linux_arm64.tar.gz
    ├── config
    │   ├── Caddyfile
    │   └── Caddyfile.bak
    ├── init
    │   ├── README.md
    │   ├── freebsd
    │   │   ├── README.md
    │   │   └── caddy
    │   ├── linux-systemd
    │   │   ├── README.md
    │   │   └── caddy.service
    │   ├── linux-sysvinit
    │   │   ├── README.md
    │   │   └── caddy
    │   ├── linux-upstart
    │   │   ├── README.md
    │   │   ├── caddy.conf
    │   │   ├── caddy.conf.centos-6
    │   │   └── caddy.conf.ubuntu-12.04
    │   └── mac-launchd
    │       ├── README.md
    │       └── com.caddyserver.web.plist
    ├── ssl
    └── www
        └── download.com
            ├── AriaNg-1.1.4.zip
            ├── LICENSE
            ├── css
            │   ├── aria-ng-2a46099f8c.min.css
            │   ├── bootstrap-3.4.1.min.css
            │   └── plugins-9b678dd4f5.min.css
            ├── favicon.ico
            ├── favicon.png
            ├── fonts
            │   ├── fontawesome-webfont.eot
            │   ├── fontawesome-webfont.svg
            │   ├── fontawesome-webfont.ttf
            │   ├── fontawesome-webfont.woff
            │   └── fontawesome-webfont.woff2
            ├── index.html
            ├── index.manifest
            ├── js
            │   ├── angular-packages-1.6.10.min.js
            │   ├── aria-ng-994a2d3441.min.js
            │   ├── bootstrap-3.4.1.min.js
            │   ├── echarts-common-3.8.5.min.js
            │   ├── jquery-3.3.1.min.js
            │   ├── moment-with-locales-2.24.0.min.js
            │   └── plugins-01928ba731.min.js
            ├── langs
            │   ├── zh_Hans.txt
            │   └── zh_Hant.txt
            ├── robots.txt
            ├── tileicon.png
            └── touchicon.png
    
    14 directories, 43 files
    ```

*对于`filebrowser`当使用`Firefox`浏览器时，请关闭“允许页面选择自己的字体代替您的上述选择”，否则会出现网页字体混乱的场景。*

![替换字体](替换字体.png)
