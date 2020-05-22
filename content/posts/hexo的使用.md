---
title: hexo的使用
date: 2019-07-13T16:42:41+08:00
tags: ["hexo"]
category: ["技术"]
---
# 安装Hexo

## 初始化文件夹

```bash
$ hexo init myblog

$ cd myblog
$ npm install
```

## 安装主题

```bash
$ git clone git@github.com:forsigner/fexo.git themes/fexo

$ npm install hexo-deployer-git --save
```

## 常用hexo命令

```bash
$ hexo g
$ hexo s
$ hexo d
```

## 迁移`hexo`需要移动的文件（夹）

```
_config.yml
package.json
scaffolds/
source/
themes/
```

```bash
$ npm install hexo-cli -g
$ npm install
$ npm install hexo-deployer-git --save  // 文章部署到 git 的模块
```

