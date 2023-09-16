---
title: "lxc以alpine为基础安装adguardhome"
date: 2023-05-13T09:17:54+08:00
tags: ["lxc", "alpine", "adguardhome"]
categories: ["技术"]
---

# 1.lxc创建alpine系统

可以是“无特权的容器”，可以取消勾选”嵌套“。ip在pve创建lxc容器时设置固定ip并指定ip。

# 2.更改alpine软件源

```bash
$ sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```

更新

```bash
$ apk update
```



# 3.创建文件夹

```bash
$ mkdir ~/program
$ mkdir ~/download
```

# 4.安装adguardhome

## 4.1下载

github下载页面

```
https://github.com/AdguardTeam/AdGuardHome/releases
```

例如

```bash
$ cd download
$ curl -LO https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.108.0-b.34/AdGuardHome_linux_amd64.tar.gz
```

## 4.2解压

```bash
$ tar -C ~/program -zxf AdGuardHome_linux_amd64.tar.gz
```

## 4.3创建启动脚本

```bash
$ vim /etc/init.d/AdGuardHome
```

添加以下内容

```
#!/sbin/openrc-run
#
# openrc service-script for AdGuardHome
#
# place in /etc/init.d/
# start on boot: "rc-update add adguardhome"
# control service: "service adguardhome <start|stop|restart|status|checkconfig>"
#

description="AdGuard Home: Network-level blocker"

pidfile="/run/$RC_SVCNAME.pid"
command="/root/program/AdGuardHome/AdGuardHome"
command_args="-s run"
command_background=true

extra_commands="checkconfig"

depend() {
  need net
  provide dns
  after firewall
}

checkconfig() {
  "$command" --check-config || return 1
}

stop() {
  if [ "${RC_CMD}" = "restart" ] ; then
    checkconfig || return 1
  fi

  ebegin "Stopping $RC_SVCNAME"
  start-stop-daemon --stop --exec "$command" \
    --pidfile "$pidfile" --quiet
  eend $?
}
```

添加执行权限

```bash
$ chmod +x /etc/init.d/AdGuardHome
```

## 4.4配置开机启动

添加开机启动

```bash
$ rc-update add AdGuardHome
```

启动服务

```bash
$ rc-service AdGuardHome start
```

## 5.打开网页

```
ip:3000
```

# 参考

> [Alpine LXC容器安装AdGuardHome-OPENWRT专版-恩山无线论坛 - Powered by Discuz! (right.com.cn)](https://www.right.com.cn/forum/thread-8219926-1-1.html)
