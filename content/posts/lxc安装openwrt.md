---
title: "lxc安装openwrt"
date: 2023-05-13T09:31:23+08:00
tags: ["lxc", "openwrt"]
categories: ["技术"]
---

# 1.编译openwrt固件

我是在[OpenWrt固件下载与在线定制编译 (supes.top)](https://supes.top/)中定制固件，下载`xxx-GENERIC-ROOTFS.TAR.GZ`用于lxc中系统的安装。

# 2.pve中上传固件

CT模板中上传\*\*\*-rootfs.tar.gz

# 3.前提准备

## 3.1启用无特权的 bpf() 调用

pve7中默认禁用无特权的 bpf() 调用，这将导致lxc安装openwrt之后，只有openwrt能上网，其他lxc和虚拟机等设备无法上网，`pve shell`需要执行以下命令

```bash
$ echo "kernel.unprivileged_bpf_disabled=0" >> /etc/sysctl.conf
$ sysctl -p
```

## 3.2添加模块

`pve shell`编辑文件

```bash
$ vim /etc/modules-load.d/openwrt.conf
```

添加以下内容

```
ppp_async
ppp_generic
ppp_mppe
pppoatm
pppoe
pppox
slhc
tun
xt_FULLCONENAT
xt_multiport
xt_connmark
xt_comment
xt_length
xt_time
xt_string
xt_statistic
xt_state
xt_socket
xt_recent
xt_quota
xt_pkttype
xt_owner
xt_mac
xt_helper
xt_hl
xt_esp
xt_ecn
xt_dscp
xt_connlimit
xt_connbytes
xt_bpf
xt_LOG
xt_HL
xt_DSCP
xt_CT
xt_CLASSIFY
xt_iprange
xt_TPROXY
ipt_ah
ipt_ECN
ip6t_NPT
ip_gre
ip_vs
ip_tunnel
ip_set_hash_ip
ip_set_hash_ipportnet
ip_set_hash_netport
ip_set_bitmap_ip
ip_set_hash_ipmac
ip_set_hash_mac
ip_set_hash_netportnet
ip_set_bitmap_ipmac
ip_set_hash_ipport
ip_set_hash_netiface
ip_set_bitmap_port
ip_set_hash_ipportip
ip_set_hash_netnet
nf_conntrack_amanda
nf_conntrack_bridge
nf_conntrack_broadcast
nf_conntrack_ftp
nf_conntrack_h323
nf_conntrack_irc
nf_conntrack_netbios_ns
nf_conntrack_pptp
nf_conntrack_sane
nf_conntrack_sip
nf_conntrack_snmp
nf_conntrack_tftp
nf_conntrack_netlink
nf_dup_netdev
nf_flow_table_ipv4
nf_log_bridge
nf_log_ipv6
nf_nat_ftp
nf_nat_pptp
nf_nat_tftp
nf_dup_ipv4
nf_flow_table
nf_flow_table_ipv6
nf_log_common
nf_log_netdev
nf_nat_h323
nf_nat_sip
nf_synproxy_core
nf_dup_ipv6
nf_flow_table_inet
nf_log_arp
nf_log_ipv4
nf_nat_amanda
nf_nat_irc
nf_nat_snmp_basic
nf_tables_set
act_ipt
sch_ingress
cls_fw
cls_flow
cls_u32
sch_netem
em_u32
act_connmark
sch_hfsc
act_mirred
sch_htb
```

## 3.3添加rps脚本，增加网卡的并发能力

`pve shell`编辑文件

```bash
$ vim /etc/init.d/rps
```

添加以下内容

```sh
#!/bin/sh

### BEGIN INIT INFO
# Provides:		hostapd
# Required-Start:	$remote_fs
# Required-Stop:	$remote_fs
# Should-Start:		$network
# Should-Stop:
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	Advanced IEEE 802.11 management daemon
# Description:		Userspace IEEE 802.11 AP and IEEE 802.1X/WPA/WPA2/EAP
#			Authenticator
### END INIT INFO


case "$1" in
  start)
    rfc=4096
    cc=$(grep -c processor /proc/cpuinfo)
    rsfe=$(echo $cc*$rfc | bc)
    sysctl -w net.core.rps_sock_flow_entries=$rsfe
    for fileRps in $(ls /sys/class/net/en*/queues/rx-*/rps_cpus)
    do
        echo $cc > $fileRps
    done

    for fileRfc in $(ls /sys/class/net/en*/queues/rx-*/rps_flow_cnt)
    do
        echo $rfc > $fileRfc
    done
   # tail /sys/class/net/en*/queues/rx-*/{rps_cpus,rps_flow_cnt}
	;;
  stop)

	;;
  reload)
	;;
  restart|force-reload)

	;;
  status)

	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload|reload|status}" >&2
	exit 1
	;;
esac

exit 0
```

增加执行权限

```bash
$ chmod +x /etc/init.d/rps
```

开机启动

```bash
$ update-rc.d rps defaults
```

## 3.4添加网络调优参数

`pve shell`编辑文件

```bash
$ vim /etc/sysctl.conf
```

添加以下内容

```
net.netfilter.nf_conntrack_icmp_timeout=10
net.netfilter.nf_conntrack_tcp_timeout_syn_recv=5
net.netfilter.nf_conntrack_tcp_timeout_syn_sent=5
net.netfilter.nf_conntrack_tcp_timeout_established=600
net.netfilter.nf_conntrack_tcp_timeout_fin_wait=10
net.netfilter.nf_conntrack_tcp_timeout_time_wait=10
net.netfilter.nf_conntrack_tcp_timeout_close_wait=10
net.netfilter.nf_conntrack_tcp_timeout_last_ack=10
net.core.somaxconn=65535
```

# 4.安装openwrt

*以下假设新建的lxc序号为110

## 4.1使用命令行创建lxc

`pve shell`执行以下命令

```bash
$ pct create 110 local-btrfs:vztmpl/openwrt-08.20.2023-x86-64-generic-rootfs.tar.gz --arch amd64 --hostname openwrt --rootfs local-btrfs:1 --memory 256 --cores 1 --swap 0 --ostype unmanaged -net0 bridge=vmbr0,name=eth0 -net1 bridge=vmbr1,name=eth1
```

## 4.2编辑配置文件

`pve shell`编辑配置文件

```bash
$ vim /etc/pve/lxc/110.conf
```

全部内容为

```
arch: amd64
cores: 1
hostname: openwrt
memory: 256
net0: name=eth0,bridge=vmbr0,hwaddr=A6:AE:3B:4A:12:FB,type=veth
net1: name=eth1,bridge=vmbr1,hwaddr=5E:19:6E:87:6A:BB,type=veth
onboot: 1
ostype: unmanaged
rootfs: local-btrfs:110/vm-110-disk-0.raw,size=1G
swap: 0
lxc.mount.auto: cgroup:rw
lxc.mount.auto: proc:rw
lxc.mount.auto: sys:rw
lxc.cap.drop: sys_admin
lxc.apparmor.profile: unconfined
lxc.cgroup2.devices.allow: c 108:0 rwm
lxc.autodev: 1
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.hook.autodev: /var/lib/lxc/110/device_hook.sh
lxc.mount.entry: tmp tmp tmpfs rw,nodev,relatime,mode=1777 0 0
```

`pve shell`创建挂载设备的脚本

```bash
$ vim /var/lib/lxc/110/device_hook.sh
```

添加以下内容

```
#!/bin/sh
mknod /${LXC_ROOTFS_MOUNT}/dev/ppp c 108 0
mkdir -p ${LXC_ROOTFS_MOUNT}/dev/net
mknod /${LXC_ROOTFS_MOUNT}/dev/net/tun c 10 200
```

`pve shell`添加执行权限

```bash
$ chmod +x /var/lib/lxc/110/device_hook.sh
```

## 4.3启动lxc

`lxc shell`配置，执行以下命令

```bash
$ mv /sbin/modprode sbin/mde
```

> 因为在lxc里面不能调起modprode的，一般应用会判断有没有这个，没有就会用insmod。[PVE用LXC几乎完美运行openwrt更新无需编译内核支持fullconenat-软路由,x86系统,openwrt(x86),Router OS 等-恩山无线论坛 - Powered by Discuz! (right.com.cn)](https://www.right.com.cn/forum/thread-4053183-1-1.html)

# 5.使用

miniupnp、ssrp、frps、dnsmasq均正常使用。

# 6.个人备份

```bash
$ vim /etc/config/network
```

```
config interface 'loopback'
        option device 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'xxx'
        option packet_steering '1'

config device
        option name 'br-lan'
        option type 'bridge'
        list ports 'eth0'

config interface 'lan'
        option device 'br-lan'
        option proto 'static'
        option netmask '255.255.255.0'
        option ip6assign '60'
        option ipaddr '192.168.1.1'

config interface 'wan'
        option proto 'pppoe'
        option username 'xxx'
        option password 'xxx'
        option device 'eth1'
        option ipv6 'auto'
```

