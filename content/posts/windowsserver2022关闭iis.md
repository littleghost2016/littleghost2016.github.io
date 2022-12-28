---
title: "windowsserver2022关闭iis"
date: 2022-12-28T20:30:54+08:00
tags: ["windows", "iis"]
categories: ["技术"]
---

> 参考自[Server2016如何关闭和禁用IIS服务器 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/article/1538468)

# 起因

![image-20221228201028301](image-20221228201028301.png)

windows server 2022的iis（Internet Information Services）会占用80端口，使用命令查看端口占用。

```powershell
$ netstat -ano | findstr 80
```

```
TCP    0.0.0.0:80             0.0.0.0:0              LISTENING       4
TCP    [::]:80                [::]:0                 LISTENING       4
```

想要关闭并且禁用自启动一共需要2个步骤。

# 1.关闭服务

## 1.1打开“服务器管理器”

![image-20221228201535408](image-20221228201535408.png)

或者在开始菜单里面打开

![image-20221228201615132](image-20221228201615132.png)

## 1.2打开“计算机管理”

点击“工具”-“计算机管理”

![image-20221228201714008](image-20221228201714008.png)

## 1.3打开iis管理器

点击“服务和应用程序”-“Internet Information Services（iis）管理器”

![image-20221228202009113](image-20221228202009113.png)

## 1.4停止服务

左边点击服务器，弹出的页面中点击”停止“

![image-20221228202217249](image-20221228202217249.png)

## （1.5或者使用命令）

```powershell
$ net stop w3svc
```

```
World Wide Web 发布服务 服务正在停止.
World Wide Web 发布服务 服务已成功停止。
```

# 2.关闭服务自启动

## 2.1重复1.1和1.2后，打开服务

点击”服务“

![image-20221228202520429](image-20221228202520429.png)

## 2.2找到iis管理服务

![image-20221228202631907](image-20221228202631907.png)

## 2.3关闭自启动

![image-20221228202804579](image-20221228202804579.png)