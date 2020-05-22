---
title: 重装vps
date: 2019-11-13 16:06:44
tags: ["caddy", "v2ray", "bash"]
category: ["技术"]
---
# 总体工作

## 工作列表

- [x] 重装系统ubuntu18.04
- [x] 旧域名更换为新域名[littleghost.ml](www.littleghost.ml)
- [x] Web服务器由`Nginx`切换为`Caddy`
  - 实际使用的caddy为`caddy2Beta20`版本（当前最新），启动命令和caddyfile与1.X版本有不小的差别。
- [x] 部署`V2ray`服务
  - 模式为WebSocket + TLS，并未使用CDN。
- [x] `caddy`和`v2ray`均使用`systemd`做进程守护。
- [x] 通知小伙伴们重装期间无法提供服务，且原域名基本不再使用。
- [ ] 编写自动安装和升级caddy和v2ray的脚本。

## 整体文件布局

```
/etc/systemd/system
├── caddy.service
└── v2ray.service

/home/ubuntu/program
├── caddy
│   ├── bin
│   │   ├── caddy
│   ├── config
│   │   └── caddyfile
│   └── ssl
│       ├── acme
│       ├── locks
│       └── ocsp
└── v2ray
    ├── bin
    │   ├── v2ctl
    │   ├── v2ray
    ├── config
    │   ├── v2ray.service
    │   └── config.json
    └── log
```

# caddy

## 文件布局

```bash
$ tree caddy -L 2
```

```
caddy
├── bin
│   ├── caddy
├── config
│   └── caddyfile
└── ssl
    ├── acme
    ├── locks
    └── ocsp
```

## 说明

1. caddy包含1.X和2.0 beta 20两个版本的二进制执行文件和配置文件，两种版本都能够实现所需功能。
2. 1.0和2.0版本的配置文件和启动命令都不同。
3. 域名映射
   -  `www.littleghost.cn` --301--> `littleghost2016.github.io`
   - `blog.littleghost.ml` & `www.littleghost.ml` 反向代理`littleghost2016.github.io`
   - `blog.littleghost.ml/game` -> 反向代理

## caddy 2.0 beta20 版本

推荐使用caddy的新版本。

### 配置文件

```bash
$ sudo vim ~/program/caddy/config/caddyfile
```

```
blog.littleghost.ml/game {
    encode gzip zstd
    reverse_proxy localhost:your_port
}

blog.littleghost.ml, www.littleghost.ml {
    tls 785340571@qq.com
    encode gzip zstd
    reverse_proxy {
        to littleghost2016.github.io:443
        header_up Host {http.reverse_proxy.upstream.host}
        transport http {
            tls
        }
    }
}

www.littleghost.cn {
    tls 785340571@qq.com
    encode gzip zstd
    redir / https://littleghost2016.github.io
}
```

其中代理Github Pages部分参考了[Simple Reverse-Proxy Config for V2](https://caddy.community/t/simple-reverse-proxy-config-for-v2/6711)

### systemd进程守护配置

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
Environment=CADDYPATH=/home/ubuntu/program/caddy/ssl
ReadWriteDirectories=/home/ubuntu/program/caddy/ssl
ExecStart=/home/ubuntu/program/caddy/bin/caddy run --config /home/ubuntu/program/caddy/config/caddyfile --adapter caddyfile
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

说明：

1. 使用非root用户不能绑定80和443端口，会提醒`permission denied!`
2. caddy的启动命令使用`run`，指定配置文件时使用`--config`，当caddy的配置文件格式与上述示例相同时，应该使用`--adapter caddyfile`。
3. 注意两个地方，否则SSL证书无法正常被caddy请求、下载和使用。
   - caddy的配置文件中域名不要写错
   - DNS解析要解析到自己的服务器上

# v2ray

## 布局

```bash
$ tree v2ray -L 2
```

```
.
├── bin
│   ├── v2ctl
│   ├── v2ray
├── config
│   ├── v2ray.service
│   └── config.json
└── log
```

## 说明

v2ray采用WebSocket + TLS的组合，并未使用CDN（Cloudflare的CDN感觉有一些水土不服，国内的没找到免费的）。

## v2ray 4.22.1

### 配置文件

```bash
$ vim ~/program/v2ray/config/config.json
```

```
{
    "log": {
        "loglevel": "error"
    },
    "api": {
        "tag": "api",
        "services": [
            "HandlerService",
            "LoggerService",
            "StatsService"
        ]
    },
    "stats": {},
    "inbounds": [
        {
            "tag": "proxy",
            "port": your_port,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "your_uuid",
                        "level": 1,
                        "alterId": 10
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/game"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "inboundTag": [
                    "api"
                ],
                "outboundTag": "api"
            }
        ],
        "strategy": "rules"
    },
    "policy": {
        "levels": {
            "0": {
                "statsUserUplink": true,
                "statsUserDownlink": true
            }
        },
        "system": {
            "statsInboundUplink": true,
            "statsInboundDownlink": true
        }
    }
}
```

说明：

1. 可以在写完json文件后使用`v2ray --test XXX.json`命令检查配置文件是否存在错误。

2. 配置文件参考了

   > 博客 [利用 Caddy 轻松实现反向代理/镜像（支持自签SSL证书）](https://www.huiyingwu.com/438/)

### systemd进程守护配置

```bash
$ sudo vim /etc/systemd/system/v2ray.service
```

```
[Unit]
Description=V2Ray Service
After=network.target
Wants=network.target

[Service]
# This service runs as root. You may consider to run it as another use for security concerns.
# By uncommenting the following two lines, this service will run as user v2ray/v2ray.
# More discussion at https://github.com/v2ray/v2ray-core/issues/1011
User=ubuntu
Group=ubuntu
Type=simple
PIDFile=/var/run/v2ray.pid
ExecStart=/home/ubuntu/program/v2ray/bin/v2ray -config /home/ubuntu/program/v2ray/config/config.json
Restart=on-failure

# Don't restart in the case of configuration error
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
```

# 自用bash脚本

~~目前还没写完-_-||，等自己忙完这段时间且交上了作业再继续写吧，暂时被锁住了...貌似锁的死死的...~~

疫情在家效率太低了...

# 吐槽

ssh连接服务器延迟有点高，特别特别是晚上，要等待个2s左右，有时候直接断了，有点小烦...

*同宿舍室友说速度比以前快了一些，不知道是不是心理作用...*

目前家里是移动网 俗称墙内墙 网络确实有点差劲...

# 更新历史

20191113_1603：初始版本

20200328_2210：更新caddy2和v2ray部分配置，删除caddy1配置部分。脚本还没写，抽空填坑...