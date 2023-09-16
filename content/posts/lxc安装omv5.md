---
title: "lxc安装omv5"
date: 2023-05-30T20:27:33+08:00
tags: ["lxc", "omv"]
categories: ["技术"]
---

lxc模板为debian10。后来因经常掉盘问题，放弃lxc安装omv，改为虚拟机安装omv的方式。

# 更改`sources.list`

```bash
$ nano /etc/apt/sources.list
```

注释掉已有的内容，添加以下内容。

```
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
```

升级并重启

```bash
$ apt update && apt upgrade -y && reboot
```

## 如遇报错

```bash
Get:1 https://mirrors.tuna.tsinghua.edu.cn/debian buster InRelease [122 kB]
Get:2 https://mirrors.tuna.tsinghua.edu.cn/debian buster-updates InRelease [56.6 kB]
Get:3 https://mirrors.tuna.tsinghua.edu.cn/debian buster-backports InRelease [51.4 kB]
Get:4 https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates InRelease [34.8 kB]
Get:5 https://mirrors.tuna.tsinghua.edu.cn/debian buster/main amd64 Packages [7909 kB]
Get:6 https://mirrors.tuna.tsinghua.edu.cn/debian buster/main Translation-en [5969 kB]
Err:3 https://mirrors.tuna.tsinghua.edu.cn/debian buster-backports InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 0E98404D386FA1D9 NO_PUBKEY 6ED0E7B82643E131
Get:7 https://mirrors.tuna.tsinghua.edu.cn/debian buster/contrib amd64 Packages [50.1 kB]
Get:8 https://mirrors.tuna.tsinghua.edu.cn/debian buster/contrib Translation-en [44.2 kB]
Get:9 https://mirrors.tuna.tsinghua.edu.cn/debian buster/non-free amd64 Packages [87.8 kB]
Get:10 https://mirrors.tuna.tsinghua.edu.cn/debian buster/non-free Translation-en [88.9 kB]
Get:11 https://mirrors.tuna.tsinghua.edu.cn/debian buster-updates/main amd64 Packages [8788 B]
Get:12 https://mirrors.tuna.tsinghua.edu.cn/debian buster-updates/main Translation-en [6915 B]
Get:13 https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates/main amd64 Packages [520 kB]
Get:14 https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates/main Translation-en [281 kB]
Get:15 https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates/non-free amd64 Packages [9148 B]
Get:16 https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates/non-free Translation-en [23.7 kB]
Reading package lists... Done
W: GPG error: https://mirrors.tuna.tsinghua.edu.cn/debian buster-backports InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 0E98404D386FA1D9 NO_PUBKEY 6ED0E7B82643E131
E: The repository 'https://mirrors.tuna.tsinghua.edu.cn/debian buster-backports InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```

执行

```bash
$ apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
```

然后执行，等待重启

```bash
$ apt update && apt upgrade -y && reboot
```

# 安装omv

先安装

```bash
$ apt install gnupg2
```

执行

```bash
$ wget -O "/etc/apt/trusted.gpg.d/openmediavault-archive-keyring.asc" https://packages.openmediavault.org/public/archive.key
```

```bash
$ apt-key add "/etc/apt/trusted.gpg.d/openmediavault-archive-keyring.asc"
```

```bash
$ cat <<EOF > /etc/apt/sources.list.d/openmediavault.list
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public usul main
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages usul main
## Uncomment the following line to add software from the proposed repository.
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public usul-proposed main
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages usul-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public usul partner
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages usul partner
EOF
```

```bash
$ apt-get --yes --auto-remove --show-upgraded --allow-downgrades --allow-change-held-packages --no-install-recommends --option DPkg::Options::="--force-confdef" --option DPkg::Options::="--force-confold" install openmediavault-keyring openmediavault
```

```bash
$ omv-confdbadm populate
```

## 如遇报错

```
[ERROR   ] An un-handled exception was caught by salt's global exception handler:
ValueError: 'multicast' does not appear to be an IPv4 or IPv6 network
Traceback (most recent call last):
  File "/usr/bin/salt-call", line 11, in <module>
    load_entry_point('salt==3003', 'console_scripts', 'salt-call')()
  File "/usr/lib/python3/dist-packages/salt/scripts.py", line 449, in salt_call
    client.run()
  File "/usr/lib/python3/dist-packages/salt/cli/call.py", line 58, in run
    caller.run()
  File "/usr/lib/python3/dist-packages/salt/cli/caller.py", line 112, in run
    ret = self.call()
  File "/usr/lib/python3/dist-packages/salt/cli/caller.py", line 220, in call
    self.opts, data, func, args, kwargs
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 1235, in __call__
    return self.loader.run(run_func, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2268, in run
    return self._last_context.run(self._run_as, _func_or_method, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2283, in _run_as
    return _func_or_method(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/executors/direct_call.py", line 12, in execute
    return func(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 1235, in __call__
    return self.loader.run(run_func, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2268, in run
    return self._last_context.run(self._run_as, _func_or_method, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2283, in _run_as
    return _func_or_method(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 1764, in routes
    routes_ = _ip_route_linux()
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 609, in _ip_route_linux
    address_mask = convert_cidr(comps[0])
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 1232, in convert_cidr
    cidr = calc_net(cidr)
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 1255, in calc_net
    return __utils__["network.calc_net"](ip_addr, netmask)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 1235, in __call__
    return self.loader.run(run_func, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2268, in run
    return self._last_context.run(self._run_as, _func_or_method, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2283, in _run_as
    return _func_or_method(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/utils/network.py", line 1185, in calc_net
    return str(ipaddress.ip_network(ipaddr, strict=False))
  File "/usr/lib/python3/dist-packages/salt/ext/ipaddress.py", line 108, in ip_network
    address)
ValueError: 'multicast' does not appear to be an IPv4 or IPv6 network
Traceback (most recent call last):
  File "/usr/bin/salt-call", line 11, in <module>
    load_entry_point('salt==3003', 'console_scripts', 'salt-call')()
  File "/usr/lib/python3/dist-packages/salt/scripts.py", line 449, in salt_call
    client.run()
  File "/usr/lib/python3/dist-packages/salt/cli/call.py", line 58, in run
    caller.run()
  File "/usr/lib/python3/dist-packages/salt/cli/caller.py", line 112, in run
    ret = self.call()
  File "/usr/lib/python3/dist-packages/salt/cli/caller.py", line 220, in call
    self.opts, data, func, args, kwargs
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 1235, in __call__
    return self.loader.run(run_func, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2268, in run
    return self._last_context.run(self._run_as, _func_or_method, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2283, in _run_as
    return _func_or_method(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/executors/direct_call.py", line 12, in execute
    return func(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 1235, in __call__
    return self.loader.run(run_func, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2268, in run
    return self._last_context.run(self._run_as, _func_or_method, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2283, in _run_as
    return _func_or_method(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 1764, in routes
    routes_ = _ip_route_linux()
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 609, in _ip_route_linux
    address_mask = convert_cidr(comps[0])
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 1232, in convert_cidr
    cidr = calc_net(cidr)
  File "/usr/lib/python3/dist-packages/salt/modules/network.py", line 1255, in calc_net
    return __utils__["network.calc_net"](ip_addr, netmask)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 1235, in __call__
    return self.loader.run(run_func, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2268, in run
    return self._last_context.run(self._run_as, _func_or_method, *args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/loader.py", line 2283, in _run_as
    return _func_or_method(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/salt/utils/network.py", line 1185, in calc_net
    return str(ipaddress.ip_network(ipaddr, strict=False))
  File "/usr/lib/python3/dist-packages/salt/ext/ipaddress.py", line 108, in ip_network
    address)
ValueError: 'multicast' does not appear to be an IPv4 or IPv6 network
```

我查了一下，说是omv不保证在lcontainer环境下的正常运行

> [Install error: ’multicast’ does not appear to be an IPv4 or IPv6 network · Issue #93 · openmediavault/openmediavault-docs (github.com)](https://github.com/openmediavault/openmediavault-docs/issues/93)

我再执行一遍这条命令，没有报错了...

```bash
$ omv-confdbadm populate
```

# 登录omv的web页面后保存更改时如遇报错

【日期和时间】不勾选使用NTP服务器
