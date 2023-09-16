---
title: "安装plsql"
date: 2023-06-07T08:57:16+08:00
tags: ["plsql"]
categories: ["技术"]
---

# 1.下载安装包

[PLSQL 14.0.6 下载地址](https://www.allroundautomations.com/registered-plsqldev/)

[oracle client 下载地址](https://www.oracle.com/database/technologies/[instant](https://so.csdn.net/so/search?q=instant&spm=1001.2101.3001.7020)-client/downloads.html)

# 2.安装

plsql安装略过，oracle client解压略过。

# 3.配置

## 1.为plsql配置oracle client

设置【配置】-【首选项】中的”Oracle主目录“、”OCI库“。其中”Oracle主目录“路径指定为``oracle client的目录`，”OCI库“为oracle client目录下的`oci.dll`。

## 2.解决plsql中文乱码问题

添加系统变量`NLS_LANG`，设置值为：`SIMPLIFIED CHINESE_CHINA.ZHS16GBK`，重启plsql。
