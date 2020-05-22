---
title: 树莓派搭建smb
date: 2020-01-20T21:42:55+08:00
tags: ["树莓派", "smb"]
category: ["技术"]
---

>   ~~很简单，有手就行。~~

# 安装

1.  安装二进制文件

```bash
$ sudo apt install samba
```

2.  修改配置文件

```bash
$ sudo vim /etc/samba/smb.conf
```

最后添加如下内容。*path为共享文件夹的路径，请根据自身情况修改*

```
[share]
comment = Personal SMB server
path = /home/ubuntu/sambaDirectory
public = no
writable = yes
```

3.  重启`samba`服务

```bash
$ sudo systemctl restart smbd.service
```

4.  为`samba`配置新用户

```bash
$ sudo pdbedit -a -u ubuntu
```

输入两遍密码

```
new password:
retype new password:
```

最后的回显

```
Unix username:        ubuntu
NT username:
Account Flags:        [U          ]
User SID:             S-1-5-21-3656490077-3147567822-1491380157-1000
Primary Group SID:    S-1-5-21-3656490077-3147567822-1491380157-513
Full Name:            Ubuntu
Home Directory:       \\ubuntu\ubuntu
HomeDir Drive:
Logon Script:
Profile Path:         \\ubuntu\ubuntu\profile
Domain:               UBUNTU
Account desc:
Workstations:
Munged dial:
Logon time:           0
Logoff time:          Wed, 06 Feb 2036 15:06:39 UTC
Kickoff time:         Wed, 06 Feb 2036 15:06:39 UTC
Password last set:    Mon, 20 Jan 2020 01:54:24 UTC
Password can change:  Mon, 20 Jan 2020 01:54:24 UTC
Password must change: never
Last bad password   : 0
Bad password count  : 0
Logon hours         : FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
```

# 使用

1.  Windows文件资源管理器输入`\\{树莓派IP}\share`

2.  输入刚刚设置的`samba`用户名和密码，进入共享文件夹。

# 关于pdbedit

`pdbedit`是`samba`的用户管理命令

|   主要参数    |      作用      |
| :-----------: | :------------: |
|  -L, --list   | list all users |
| -v, --verbose |    详细信息    |
| -a, --create  |  create user   |
| -r, --modify  |  modify user   |
| -x, --delete  |  delete user   |

