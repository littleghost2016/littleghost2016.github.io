---
title: 树莓派使用docker
date: 2020-01-24T21:38:51+08:00
tags: ["树莓派", "docker"]
categories: ["技术"]
---

# 解决Got permission denied问题

```bash
$ sudo groupadd docker				#添加docker用户组
$ sudo gpasswd -a $USER docker		#将登陆用户加入到docker用户组中
$ newgrp docker						#更新用户组
$ docker ps
```

# 配置国内镜像源

```bash
$ sudo vim /etc/docker/daemon.json
```

```
{
  "registry-mirrors": [
    "https://dockerhub.azk8s.cn",
    "https://hub-mirror.c.163.com"
  ]
}
```

```bash
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker.service
```

# 使用UnblockNeteaseMusic

项目地址：[UnblockNeteaseMusic](https://github.com/nondanee/UnblockNeteaseMusic)

```bash
$ docker run --name yunmusic -d -p [外部地址]:8080 nondanee/unblockneteasemusic
```

*使用 QQ / 虾米 / 百度 / 酷狗 / 酷我 / 咪咕 / JOOX 音源替换变灰歌曲链接 (默认仅启用一、五、六)，可通过在上面的命令后面加上`-o migu`等指定音源*