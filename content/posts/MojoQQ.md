---
title: MojoQQ
date: 2018-09-21T16:46:13+08:00
tags: ["qq", "perl"]
categories: ["技术"]
---

# 安装

```bash
sudo apt-get install openssl libssl-dev
sudo wget  http://xrl.us/cpanm  --no-check-certificate -O /sbin/cpanm && chmod +x  /sbin/cpanm
sudo chmod 755 /sbin/cpanm
sudo cpanm Mojo::Webqq
```

# 配置

```bash
$ vim Mojoqq/qq1.pl
```

```perl
use Mojo::Webqq;
#微信使用 use Mojo::Weixin
my $client = Mojo::Webqq->new(log_encoding=>"utf-8");
$client->load("ShowMsg");

#以下为 MiPush 推送
$client->load("MiPush",data=>{
    registration_ids=>["FP5FHPzvfB1p3lntV75WgycDuAVwWExmsHa8vQn0NuKniv4kjkHM1aIraZWYh/mF"],
    # allow_group=>[""],
    # ban_group=>[],
    # allow_discuss=>[],
    # ban_discuss=>[],
});

$client->load("Openqq",data=>{
    #如果是微信改为 Openwx
    listen => [{host=>"0.0.0.0",port=>1098}, ] ,
    #如果是推送微信的话需要保证端口不重复，并请保证所设定的端口已经在防火墙内放行，同时需要在 APP 内设定好推送服务器的地址和端口
});
#不需要 APP 内回复功能请删除以上三行（不包括被 # 号注释掉的几行）
$client->run(); 
```