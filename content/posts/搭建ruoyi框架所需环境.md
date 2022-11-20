---
title: "搭建ruoyi框架所需环境"
date: 2022-11-20T11:58:54+08:00
tags: ["java", "mariadb", "redis"]
categories: ["技术"]
---

[TOC]

# 阅读本文请注意

1. 所有以`$`开头的命令均为命令行中的输入，只需要复制`$`后面的内容即可，无需输入`$`。
2. 以`Debian 11`系统为基础。

# mariadb

> 参考自[MySql、Mariadb创建数据库、用户及授权 - YJCCN - 博客园 (cnblogs.com)](https://www.cnblogs.com/acmexyz/p/12350151.html)

## 安装

```bash
$ sudo apt install mariadb-server
```

## 允许远程连接

```bash
$ sudo vim /etc/mysql/mariadb.conf.d/50-server.cnf
```

mariadb的配置文件有点多，得去mariadb.conf.d文件夹下面找。

把第27行注释掉，变成

```
#bind-address            = 127.0.0.1
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
> create user 'testry'@'localhost' identified by '123456';
```

***localhost**代表仅允许本地连接，如果想允许远程连接，可将**localhost**换成**%***

## 给账户分配权限

```mysql
> GRANT ALL ON test.* to testry@'localhost';
```

```mysql
> FLUSH privileges;
```

### 其他

```mysql
-- 给账户分配部分的权限，并且通过外网访问
> GRANT insert,delete,select,update ON test.* to testry@'%';
> FLUSH privileges;

-- 或则采用下面的代码，除了操作权限授权外，还赋予授权的权限。
> GRANT ALL ON test.* to username@'%' WITH GRANT OPTION;
> FLUSH privileges;
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

将第87行注释掉

```
#bind 127.0.0.1 ::1
```

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
tcp        LISTEN      0           511                     0.0.0.0:6379                  0.0.0.0:*
tcp        LISTEN      0           511                        [::]:6379                     [::]:*
```

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

# java

## 安装

各个版本预编译的openjdk可在[Home | Adoptium](https://adoptium.net/zh-CN/)下载，解压后配置`PATH`。

访问`localhost:8080`会显示

```
欢迎使用RuoYi后台管理框架，当前版本：v3.8.3，请通过前端地址访问。
```

证明后端运行环境搭建完成。
