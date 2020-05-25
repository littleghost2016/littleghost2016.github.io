---
title: K2P同时校园网和翼讯
date: 2019-07-11 03:16:47
tags: ["K2P"]
categories: ["技术"]
---
> [文章](http://rs.xidian.edu.cn/forum.php?mod=viewthread&tid=906698&highlight=ipv6)原创为西电睿思的小忧伤，感谢大佬提供技术和文章授权！
>
> 最后可以实现连入路由器的电脑端（或手机端）不需要任何配置即可使用ipv6，且不限制流量的使用ipv4。

# 1.设置校园网的账号密码

```bash
$ uci set network.wan.proto=pppoe
$ uci set network.wan.username=学号
$ uci set network.wan.password=校园网密码
$ uci commit
$ /etc/init.d/network restart
```

# 2.更新软件源

```bash
$ opkg update && opkg install kmod-ipt-nat6 && opkg install kmod-macvlan && opkg install iputils-tracepath6
```

# 3.连接虚拟链路
`eth1`就是连接外网的那根线，也就是wan口，后面出现的`eth1`同理换成自己的即可
*不一样就换成自己的，到web页面`network-interface`里随便找一个点击edit，Physical Settings，就能看到wan口是什么*

然后执行

```bash
$ ip link add link eth1 name veth1 type macvlan
$ ifconfig veth1 up
```

# 4.添加虚拟链路开机启动

*注意：这不是命令，需要添加到文件里*

```bash
$ vim /etc/rc.local
```

```bash
# 在最后一行exit 0之前添加以下内容
sleep 20
ip link add link eth1 name veth1 type macvlan
ifconfig veth1 up
```

# 5.添加一个新的wan口

可以在用户界面`Network->Interfaces>Add new interface`添加新wan口，名字设置为`vwan1`，Protocol设置为`pppoe`，`interface`选择`veth1`

# 6.在luci界面设置vwan1

设置`vwan1`拨号用户名和密码，同时设置Firewall Setting为`wan`口firewire zone，保存。

这里`vwan1`设置的是翼讯的账号和密码，格式为`t学号@dx`，或者添加转换后的账号[在线转换地址](https://note286.github.io/yixun/)。
# 7.设置默认网关

将原来的`wan`口设置为非默认路由，`vwan1`设置为默认路由，也就是**易迅走默认网关 校园网不走**，这样ipv4就只走易迅了，在`network-interface`里选择网口后edit，Advanced Settings，`Use default gateway`这个选项，**易迅勾选，校园网不勾选**。

# 8.最后设置后台转发ipv6

## 1.网络配置
最好用vim自己添加 有的最后好像没有空行
添加以下内容到`/etc/sysctl.conf`

```bash
$ vim /etc/sysctl.conf
```

```bash
# 添加以下内容
net.ipv6.conf.default.accept_ra=2
net.ipv6.conf.all.accept_ra=2
```

然后执行以下命令

```bash
$ uci set network.globals.ula_prefix="$(uci get network.globals.ula_prefix | sed 's/^./d/')"
$ uci commit network
$ uci set dhcp.lan.ra_default='1'
$ uci commit dhcp
```

## 2.添加nat6脚本

```bash
$ touch /etc/init.d/nat6
$ chmod +x /etc/init.d/nat6
$ vim /etc/init.d/nat6
```

## 3.脚本内容

```bash
#!/bin/sh /etc/rc.common
START=75
ip6tables -t nat -I POSTROUTING -s `uci get network.globals.ula_prefix` -j MASQUERADE
route -A inet6 add 2000::/3 `route -A inet6 | grep ::/0 | awk 'NR==1{print "gw "$2" dev "$7}'`
```

# 9.启动并重启
```bash
$ /etc/init.d/nat6 enable
$ reboot
```

最后，稍等几分钟就会有ipv6地址了，如果使用过程中发现ipv6没了，就到system-startup里找到`nat6`，重启路由器。可访问 http://test-ipv6.com/ 检测是否有ipv6地址。

> 最后的最后，建议把[hosts](https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts)添加到路由器里，这样所有设备就都可以用了，亲测iOS，安卓，macOS，win无线连接都可以使用ipv6，不需要额外配置。

# 10.部分模块编译路径

```
kmod-ipt-nat6 : Kernel modules -> Netfilter Extensions -> kmod-ipt-nat6
kmod-macvlan : Kernel modules -> Network Devices -> kmod-macvlan
iputils-tracepath6 : Nerwork -> iputils-tracepath6 
```

