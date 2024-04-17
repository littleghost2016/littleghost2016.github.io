---
title: "搭建ruoyi框架所需环境"
date: 2022-11-20T11:58:54+08:00
tags: ["java", "mariadb", "redis", "minio"]
categories: ["技术"]
---

[TOC]

# 阅读本文请注意

1. 所有以`$`开头的命令均为命令行中的输入，只需要复制`$`后面的内容即可，无需输入`$`。
2. 以`Debian 12`系统为基础。

# mariadb

## 安装

```bash
$ sudo apt install mariadb-server
```

## 允许远程连接

```bash
$ sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
```

*mariadb的配置文件有点多，得去mariadb.conf.d文件夹下面找。*

把第27行改成，这将使`mariadb`服务器仅监听`192.168.1.100`这个ip地址上的连接。

```
bind-address = 192.168.1.100
```

重启mariadb

```bash
$ sudo systemctl restart mariadb
```

## mariadb初始化

```bash
$ sudo mysql_secure_installation
```

## 创建数据库

 ```mysql
> CREATE DATABASE test;
 ```

## 创建新用户并授权

```mysql
> CREATE USER 'testry'@'localhost' IDENTIFIED BY '123456';
```

***localhost**代表仅允许本地连接，如果想允许远程连接，可将**localhost**换成**%***

## 给账户分配权限

```mysql
> GRANT ALL PRIVILEGES ON test.* TO 'testry'@'localhost' IDENTIFIED BY '123456';
> FLUSH privileges;
```

### 其他命令，仅供学习

```mysql
-- 创建数据库
CREATE DATABASE xxx;

-- 查询用户和地址
SELECT user, host FROM mysql.user;

-- 创建用户
CREATE USER 'testry'@'%' IDENTIFIED BY '123456';

-- 修改用户的地址
rename user 'testry'@'%' to 'testry'@'localhost';

-- 删除用户
drop user 'testry'@'localhost';

-- 添加额外的 Host
GRANT ALL PRIVILEGES ON *.* TO 'testry'@'192.168.0.100' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'testry'@'example.com' IDENTIFIED BY '123456';

-- 刷新权限
FLUSH PRIVILEGES;
```

# redis

## 安装

```bash
$ sudo apt install redis
```

## 允许远程连接和修改密码

```bash
$ sudo vim /etc/redis/redis.conf
```

*我使用非root账户输入以上命令时，在/etc/redis的路径下是没有权限的，所以后面的redis.conf不能被tab自动补全，此处需要手动输入*

将第87行改成，这将使`redis`服务器监听`127.0.0.1`、`::1`、`192.168.1.101`这3个`ip`地址上的连接

```
bind 127.0.0.1 -::1 192.168.1.101
```

注意：在redis.conf配置文件中，bind指令后面的地址用于指定Redis服务器监听的网络接口。当一个地址前面有横线-时，这意味着如果该地址不可用（即不对应任何网络接口），Redis服务器也不会因此启动失败。这是一种容错设置，确保即使某个指定的地址不可用，Redis服务器仍然可以启动并运行。例如，bind -::1表示即使IPv6的本地回环地址::1不可用，Redis也会尝试继续启动。这有助于在不同的环境中灵活部署Redis，特别是在IPv6可能不被支持的环境中。

> https://redis.io/docs/management/config-file/

修改redis默认密码，将1036取消注释后，修改空格后面的字符串为想要设置的密码（例如abc123）

```
requirepass abc123
```

重启redis服务

```bash
$ sudo systemctl restart redis
```

验证远程连接相关配置修改成功

```bash
$ ss -lnr 'sport == 6379'
```

显示

```
Netid      State       Recv-Q      Send-Q            Local Address:Port             Peer Address:Port      Process
tcp        LISTEN      0           511                   localhost:6379                  0.0.0.0:*
tcp        LISTEN      0           511                   redis.lan:6379                  0.0.0.0:*
tcp        LISTEN      0           511                   localhost:6379                     [::]:*
```

*注意：这里redis.lan是我自己自定义的redis服务器的域名*

验证密码修改成功

```bash
$ redis-cli -h x.x.x.x -a abc123
```

显示

```
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
x.x.x.x:6379>
```

此时输入

```
x.x.x.x:6379> ping
```

会得到回复

```
PONG
```

不输入密码或者输错密码时也能进入redis-cli的交互界面，但是同样输入

```
x.x.x.x:6379> ping
```

会得到回复

```
(error) NOAUTH Authentication required.
```

# minio

## 下载

```bash
$ curl -LO https://dl.min.io/server/minio/release/linux-amd64/minio
```

> 地址可在https://min.io/download#/linux查询

## 安装

```bash
$ cd ~/program
$ mkdir minio
$ cd minio
$ mkdir bin
$ mkdir data
$ mv ~/download/minio ~/program/minio/bin
$ chmod +x ~/program/minio/bin
```

新建一个minio的data文件夹，存放文件

```bash
$ mkdir -p /root/program/minio/data
```

## 配置systemd

```bash
$ vim /etc/systemd/system/minio.service
```

```
[Unit]
Description=MinIO
Documentation=https://docs.min.io
Wants=network-online.target
After=network-online.target
AssertFileIsExecutable=/home/dev/program/minio/bin/minio

[Service]
WorkingDirectory=/home/dev/program/minio

User=root
Group=root
ProtectProc=invisible

Environment="MINIO_ROOT_USER=xxx"
Environment="MINIO_ROOT_PASSWORD=xxxxxxxxx"
ExecStart=/home/dev/program/minio/bin/minio server --address ":9000" --console-address ":9001" /home/dev/program/minio/data

# Let systemd restart this service always
Restart=always

# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65536

# Specifies the maximum number of threads this process can create
TasksMax=infinity

# Disable timeout logic and wait until process is stopped
TimeoutStopSec=infinity
SendSIGKILL=no

[Install]
WantedBy=multi-user.target
```

```bash
$ systemctl enable --now minio.service
```

*注意：minio的用户名至少为3个字符，密码至少为8个字符*

# java

## 安装

各个版本预编译的openjdk可在[Home | Adoptium](https://adoptium.net/zh-CN/)下载，解压后`ln`到`/usr/bin`。

访问`localhost:8080`会显示

```
欢迎使用RuoYi后台管理框架，当前版本：v3.8.3，请通过前端地址访问。
```

证明后端运行环境搭建完成。

# nodejs

## 安装

各个版本的nodejs可在[nodejs releases](https://nodejs.org/en/about/previous-releases)下载，解压后`ln`到`/usr/bin`。

```bash
$ npm install --registry=https://registry.npmmirror.com
```

# 解决问题

## java.lang.RuntimeException: Fontconfig head is null, check your fonts or fonts configuration

```bash
$ sudo apt install fontconfig
$ fc-config --force
```

