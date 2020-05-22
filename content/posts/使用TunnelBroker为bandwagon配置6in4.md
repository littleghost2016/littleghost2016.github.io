---
title: 使用TunnelBroker为bandwagon配置6in4
date: 2019-12-01T11:24:41+08:00
tags: ["ipv6", "6in4", "TunnelBroker", "linux"]
category: ["技术"]
---

VPS套餐只提供ipv4地址，无ipv6，使用`TunnelBroker`搭建6in4隧道，获取可使用的ipv6地址。

# 注册配置TunnelBroker

## 注册

[注册网址](https://www.tunnelbroker.net/register.php)，除了`username` `password` `email` 其他我是随便写的，包括`phone`，并没有做审核信息审查。

## 配置

1. 点击左侧[Create Regular Tunnel](https://www.tunnelbroker.net/new_tunnel.php)

   ![CreateRegularTunnel](CreateRegularTunnel.png)

2. 上方输入VPS的公网ipv4地址，下方选择隧道接入点，默认是洛杉矶。![CreateNewTunnel](CreateNewTunnel.png)

3. 在`ipv6 tunnel`页面可查看自己的信息，包括ipv4、ipv6地址。![IPV6Tunnel](IPV6Tunnel.png)

4. 在`Example Configurations`页面选择自己VPS的操作系统，下面回给出后续操作模板。我的是Ubuntu系统，所以根据提示应该修改网络配置文件。![Example Configurations](ExampleConfigurations.png)

# VPS配置

1. 修改文件

   ```bash
   $ sudo vim /etc/network/interfaces
   ```

2. 在下面添加`Example Configurations`页面的内容，直接复制粘贴即可。![/etc/network/interfaces](etc_network_interfaces.png)

3. 重启网络服务（可能会有些慢，我等待了大概10-15秒）

   ```bash
   $ sudo systemctl restart networking.service
   ```

4. 查看ip显示已有ipv6地址

   ```bash
   $ ip a
   ```

   其中蓝色箭头指示已有的ipv4地址，红色箭头指示新的ipv6地址![ip a](ip_a.png)

5. 可以使用`ping`命令检测是否已可以使用ipv6网络![ping6 google.com](ping6_google.com.png)

   速度还挺快的！