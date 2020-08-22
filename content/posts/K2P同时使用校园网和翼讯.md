---
title: K2P同时使用校园网和翼讯
date: 2020-08-22T12:59:47+08:00
tags: ["k2p", "ipv6"]
categories: ["技术"]

---

> [文章](http://rs.xidian.edu.cn/forum.php?mod=viewthread&tid=906698&highlight=ipv6)原创为西电睿思的小忧伤，感谢大佬提供技术和授权！本文在原文章的基础上做了部分修改，更新了NAT6转发部分的内容以适应新固件。

> 最后效果为IPv4流量计算在翼讯，IPv6流量计算在校园网。

# 一、路由器固件

虚拟机编译[LEDE](https://github.com/coolsnowwolf/lede)，内核版本5.4.51。

## 包含插件

- XXR Plus+
  - $$
  - v2ray
  - socks
- DDNS
- UPnP

*吐槽：自己K2P 16M能放的的插件太少了...*

# 二、内核插件准备

所需插件如下：

- kmod-ipt-nat6
- kmod-macvlan
- iputils-tracepath

## 可自行编译固件的看这里

以下为`menuconfig`的编译路径，直接编译到固件里

```
kmod-ipt-nat6:			Kernel modules -> Netfilter Extensions -> kmod-ipt-nat6
kmod-macvlan:			Kernel modules -> Network Devices -> kmod-macvlan
iputils-tracepath:		Nerwork -> iputils-tracepath
```

## 不能自行编译固件的看这里

```bash
$ opkg update && opkg install kmod-ipt-nat6 && opkg install kmod-macvlan && opkg install iputils-tracepath
```

在安装时可能会提示内核版本与插件版本不符合，请尝试使用`--force-depends`以强制安装，例如

```bash
$ opkg install --force-depends kmod-ipt-nat6
```

# 三、同时拨号校园网与翼讯

## 1.设置`WAN`接口为校园网

web界面设置`wan`口协议为`pppoe`，账号为学号，密码为校园网的密码，`保存并应用`。

## 2.使用`macvlan`增加虚拟链路

首先应该确定自己连接外网的那个网卡的名称，有可能叫`eth1`或者`eth0.2`等等，都有可能。

### 查看方法

web界面点击`接口`（英文为`network-interface`），点进`WAN`的`修改`（英文为`edit`），`物理设置`（英文为`Physical Settings`），即可看到已被选择的那个接口名称，我自己的为`eth0.2`，然后根据自己看到的这个名称执行以下命令

```bash
$ ip link add link eth0.2 name veth02 type macvlan
$ ifconfig veth02 up
```

`保存并应用`。

**注意**：一定是用自己的网卡名称替换第一条命令中的`eth0.2`，当然如果你的也是`eth0.2`，那可真是太巧了...

## 3.开机启动自动添加虚拟链路

### web界面操作

点击`系统`-`启动项`，在`本地启动脚本`中，`exit 0`这一行的上面添加以下内容

```bash
# 在最后一行exit 0之前添加以下内容
sleep 20
ip link add link eth0.2 name veth02 type macvlan
ifconfig veth02 up
```

`保存并应用`。

### 或者

在`rc.local`文件里面添加以上内容，效果相同。

注意：用自己的网卡名称替换命令中的`eth0.2`。

## 4.添加翼讯拨号

web界面点击`接口`，添加一个新的接口。名称可设置为`vwan1`，协议为`pppoe`，物理设置选择刚刚添加的虚拟链路`veth1`。

设置`vwan1`的拨号，分别为翼讯账号（格式为`t学号@dx`）和密码，防火墙策略选择`wan`，`保存并应用`。

翼讯账号也可添加转换后的账号，[在线转换地址](https://note286.github.io/yixun/)，但现在直接按照上面所提到的格式写就可以。

## 5.设置默认网关

web界面点击`接口`，修改校园网的接口设置，将`高级设置`中的`使用默认网关`前面的勾勾点灭，翼讯拨号不用做这个修改。

# 四、配置NAT6转发

## 1.更改IPv6 ULA 前缀

```bash
$ uci set network.globals.ula_prefix="$(uci get network.globals.ula_prefix | sed 's/^./d/')"
$ uci commit network
```

*将 IPv6 LAN 内网地址由 fd 开头变成 dd 开头。*

## 2.让DHCP服务器总是通告默认路由

```bash
$ uci set dhcp.lan.ra_default='1'
$ uci commit dhcp
```

## 3.添加NAT6脚本

```bash
$ vim /etc/init.d/nat6
```

### 脚本内容

```bash
#!/bin/sh /etc/rc.common
# NAT6 init script for OpenWrt // Depends on package: kmod-ipt-nat6

# edited by Sad Pencil at 2020-02-09
# replace route command with ip command to solve issues on new OpenWRT

START=55

# Options
# -------

# Use temporary addresses (IPv6 privacy extensions) for outgoing connections? Yes: 1 / No: 0
PRIVACY=1

# Maximum number of attempts before this script will stop in case no IPv6 route is available
# This limits the execution time of the IPv6 route lookup to (MAX_TRIES+1)*(MAX_TRIES/2) seconds. The default (15) equals 120 seconds.
MAX_TRIES=15

# An initial delay (in seconds) helps to avoid looking for the IPv6 network too early. Ideally, the first probe is successful.
# This would be the case if the time passed between the system log messages "Probing IPv6 route" and "Setting up NAT6" is 1 second.
DELAY=5

# Logical interface name of outbound IPv6 connection
# There should be no need to modify this, unless you changed the default network interface names
# Edit by Vincent: I never changed my default network interface names, but still I have to change the WAN6_NAME to "wan" instead of "wan6"
WAN6_NAME="wan6"

# ---------------------------------------------------
# Options end here - no need to change anything below

boot() {
        [ $DELAY -gt 0 ] && sleep $DELAY
        WAN6_INTERFACE=$(uci get "network.$WAN6_NAME.ifname")
        logger -t NAT6 "Probing IPv6 route"
        PROBE=0
        COUNT=1
        while [ $PROBE -eq 0 ]
        do
                if [ $COUNT -gt $MAX_TRIES ]
                then
                        logger -t NAT6 "Fatal error: No IPv6 route found (reached retry limit)" && exit 1
                fi
                sleep $COUNT
                COUNT=$((COUNT+1))
                PROBE=$(ip -6 route | grep -i '^default.*via' | grep -i -F "dev $WAN6_INTERFACE" | grep -i -o 'via.*' | wc -l)
        done

        logger -t NAT6 "Setting up NAT6"

        if [ -z "$WAN6_INTERFACE" ] || [ ! -e "/sys/class/net/$WAN6_INTERFACE/" ] ; then
                logger -t NAT6 "Fatal error: Lookup of $WAN6_NAME interface failed. Were the default interface names changed?" && exit 1
        fi
        WAN6_GATEWAY=$(ip -6 route | grep -i '^default.*via' | grep -i -F "dev $WAN6_INTERFACE" | grep -i -o 'via.*' | cut -d ' ' -f 2 | head -n 1)
        if [ -z "$WAN6_GATEWAY" ] ; then
                logger -t NAT6 "Fatal error: No IPv6 gateway for $WAN6_INTERFACE found" && exit 1
        fi
        LAN_ULA_PREFIX=$(uci get network.globals.ula_prefix)
        if [ $(echo "$LAN_ULA_PREFIX" | grep -c -E "^([0-9a-fA-F]{4}):([0-9a-fA-F]{0,4}):") -ne 1 ] ; then
                logger -t NAT6 "Fatal error: IPv6 ULA prefix $LAN_ULA_PREFIX seems invalid. Please verify that a prefix is set and valid." && exit 1
        fi

        ip6tables -t nat -I POSTROUTING -s "$LAN_ULA_PREFIX" -o "$WAN6_INTERFACE" -j MASQUERADE
        if [ $? -eq 0 ] ; then
                logger -t NAT6 "Added IPv6 masquerading rule to the firewall (Src: $LAN_ULA_PREFIX - Dst: $WAN6_INTERFACE)"
        else
                logger -t NAT6 "Fatal error: Failed to add IPv6 masquerading rule to the firewall (Src: $LAN_ULA_PREFIX - Dst: $WAN6_INTERFACE)" && exit 1
        fi

        ip -6 route add 2000::/3 via "$WAN6_GATEWAY" dev "$WAN6_INTERFACE"
        if [ $? -eq 0 ] ; then
                logger -t NAT6 "Added $WAN6_GATEWAY to routing table as gateway on $WAN6_INTERFACE for outgoing connections"
        else
                logger -t NAT6 "Error: Failed to add $WAN6_GATEWAY to routing table as gateway on $WAN6_INTERFACE for outgoing connections"
        fi

        if [ $PRIVACY -eq 1 ] ; then
                echo 2 > "/proc/sys/net/ipv6/conf/$WAN6_INTERFACE/accept_ra"
                if [ $? -eq 0 ] ; then
                        logger -t NAT6 "Accepting router advertisements on $WAN6_INTERFACE even if forwarding is enabled (required for temporary addresses)"
                else
                        logger -t NAT6 "Error: Failed to change router advertisements accept policy on $WAN6_INTERFACE (required for temporary addresses)"
                fi
                echo 2 > "/proc/sys/net/ipv6/conf/$WAN6_INTERFACE/use_tempaddr"
                if [ $? -eq 0 ] ; then
                        logger -t NAT6 "Using temporary addresses for outgoing connections on interface $WAN6_INTERFACE"
                else
                        logger -t NAT6 "Error: Failed to enable temporary addresses for outgoing connections on interface $WAN6_INTERFACE"
                fi
        fi

        exit 0
}
```

### 增加执行权限

```bash
$ chmod +x /etc/init.d/nat6
```

### 配置脚本开机启动

```bash
$ /etc/init.d/nat6 enable
```

## 4.修改内核

**接收广播并开启IPv6转发**

```bash
$ vim /etc/sysctl.conf
```

添加内容

```
net.ipv6.conf.default.forwarding=2
net.ipv6.conf.all.forwarding=2
net.ipv6.conf.default.accept_ra=2
net.ipv6.conf.all.accept_ra=2
```

## 5.配置ip6tables，加入转发规则

```bash
$ echo "ip6tables -t nat -I POSTROUTING -s $(uci get network.globals.ula_prefix) -j MASQUERADE" >> /etc/firewall.user
$ /etc/init.d/firewall restart
```

## 6.启动并重启

```bash
$ reboot
```

理论上每台连接这个路由器的设备都能同时使用IPv4和IPv6了。

