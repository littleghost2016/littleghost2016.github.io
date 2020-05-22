---
title: V2ray使用QUIC
date: 2019-09-24T16:57:39+08:00
tags: ["v2ray", "quic"]
category: ["技术"]
---
# 配置文件

服务端配置`config.json`

```json
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "inbound": {
    "port": 11942,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "********-****-****-****-************",
          "alterId": 64
        }
      ]
    },
    "streamSettings": {
      "network": "quic",
      "security": "tls",
      "quicSettings": {
        "security": "aes-128-gcm",
        "header": {
          "type": "srtp"
        },
        "key": "0"
      },
      "tlsSettings": {
        "serverName": "quic.littleghost.cn",
        "alpn": [
          "http/1.1"
        ],
        "certificates": [
          {
            "certificateFile": "/etc/nginx/certificate/1_quic.littleghost.cn_bundle.crt",
            "keyFile": "/etc/nginx/certificate/2_quic.littleghost.cn.key"
          }
        ]
      }
    }
  },
  "outbound": {
    "protocol": "freedom",
    "settings": {}
  },
  "outboundDetour": [
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "strategy": "rules",
    "settings": {
      "rules": [
        {
          "type": "field",
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "127.0.0.0/8",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "outboundTag": "blocked"
        }
      ]
    }
  }
}
```

客户端配置`quicConfig.json`

```json
{
  "log": {
    "access": "D:\\Programs\\V2Ray\\v2rayN-Core\\log\\access.log",
    "error": "D:\\Programs\\V2Ray\\v2rayN-Core\\log\\error.log",
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 1080,
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "settings": {
        "auth": null
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "quic.littleghost.cn",
            "port": 11942,
            "users": [
              {
                "id": "********-****-****-****-************",
                "alterId": 64
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "quic",
        "security": "tls",
        "tlsSettings": {
          "serverName": "quic.littleghost.cn"
        },
        "quicSettings": {
          "security": "aes-128-gcm",
          "key": "0",
          "header": {
            "type": "srtp"
          }
        }
      }
    }
  ]
}
```

# 最后想说的

1. 刚开始服务端使用`Nginx`挂反向代理，不行，后来客户端直接连接端口，不经过`Nginx`。
2. 客户端软件`V2rayN`好像对`QUIC`的支持额...（也可能是我自己不会使用），对于出现`[missing port in address]`的问题，在客户端配置文件中加入以下配置语句。

```json
"tlsSettings": {
	"serverName": "quic.littleghost.cn"
},
```

> [Github Issues - Quic协议无法连接 #1536](https://github.com/v2ray/v2ray-core/issues/1536)

3. 服务端不挂`Nginx`，客户端直接使用`v2ray -config XXX`的情况下，`QUIC`可以使用，但是速度极慢（访问404网站、非死不可一直不行，游兔箔可以访问但速度不佳，目测不如蜗牛爬行..）而且大概率连接失败，猜测运营商并不喜欢UDP :(
4. ~~个人目前使用的是`Nginx + WebSocket + TLS + CDN`，下一步准备尝试`Caddy + H2 + TLS + CDN`，看看效果如何，现在发烧有点难受.....~~还有其他人需要使用现有配置，就先不动了...

# 参考

[QUIC使用 aes-128-gcm 连接关闭 #1446](https://github.com/v2ray/v2ray-core/issues/1446)

[QUIC 无法连接 #1440](https://github.com/v2ray/v2ray-core/issues/1440)

[可能的v2ray的quic中继。。。](https://luke6887.me/?p=623)

