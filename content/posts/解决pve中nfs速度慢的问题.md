---
title: "解决pve中nfs速度慢的问题"
date: 2023-09-16T22:46:34+08:00
tags: ["nfs"]
categories: ["技术"]
---

# 0.起因

最近在pve中虚拟机安装omv（5.6.13）之后，打算把一块14T的东芝硬盘空间通过[NFS](https://www.techtarget.com/searchenterprisedesktop/definition/Network-File-System)挂载出去，以便其他虚拟机使用。

*前段时间我尝试在lxc中安装omv，直通硬盘后经常掉盘，所以放弃使用lxc安装omv，改为pve虚拟机安装omv，然后采取硬盘映射的方式直通了一个14T硬盘。*

刚开始omv上的nfs（服务端）使用默认参数，只有`subtree_check`和`insecure`。lxc中的nfs客户端使用命令安装`nfs-common`，同时pve网页中`无特权的容器`选`否`，功能中`嵌套`和`nfs`处于选中状态，并且开机自动挂载nfs

```bash
$ vim /etc/fstab
```

```
xxx:/xxx/xxxx /yyy/yyyy nfs defaults 0 0 
```

我这是一个用于qbittorrent下载文件的lxc，下载目录为挂载的nfs文件夹，写入速度比较慢，大概25MB/s。网上查了一下nfs一般内网传输速度在100MB/s左右（参考自[折腾nas nfs读写提速 – 小小白的总结纸 (wordpress.com)](https://ilmvfx.wordpress.com/2021/02/01/asustor-5304t-nas-nfs-multi-pathing/)），我这是虚拟机，不存在网线不足千兆的问题。我有个ttnode的lxc，显示传输速度为40M/s，也说明速度未达到100MB/s。

以下为排查过程记录。

# 1.检查lxc之间的网速

omv中安装`iperf3`

```bash
$ apt install iperf3
```

开启iperf3服务端

```bash
$ iperf -s
```

qbittorrent中安装`iperf3`，开启iperf客户端

```bash
$ iperf -c omv
```

```
Connecting to host omv, port 5201
[  5] local xxx port 42550 connected to xxx 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   699 MBytes  5.86 Gbits/sec  450   3.05 MBytes
[  5]   1.00-2.00   sec   564 MBytes  4.72 Gbits/sec   32   3.05 MBytes
[  5]   2.00-3.00   sec   734 MBytes  6.16 Gbits/sec   45   3.05 MBytes
[  5]   3.00-4.00   sec   739 MBytes  6.19 Gbits/sec   49   3.05 MBytes
[  5]   4.00-5.00   sec   781 MBytes  6.54 Gbits/sec  179   3.05 MBytes
[  5]   5.00-6.00   sec   780 MBytes  6.57 Gbits/sec    3   2.26 MBytes
[  5]   6.00-7.00   sec   724 MBytes  6.07 Gbits/sec    0   2.43 MBytes
[  5]   7.00-8.00   sec   635 MBytes  5.33 Gbits/sec  108   2.53 MBytes
[  5]   8.00-9.00   sec   720 MBytes  6.02 Gbits/sec    0   2.60 MBytes
[  5]   9.00-10.00  sec   398 MBytes  3.34 Gbits/sec    3   2.66 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  6.61 GBytes  5.68 Gbits/sec  869             sender
[  5]   0.00-10.05  sec  6.61 GBytes  5.65 Gbits/sec                  receiver

iperf Done.
```

发现内网速度远大于25MB/s，不是限制nfs低速的原因，继续。

# 2.更改nfs选项

## 2.1nfs服务端

在omv中更改nfs的选项

从

```
subtree_check,insecure
```

改为

```
subtree_check,insecure,no_root_squash,async
```

其中

- `no_root_squash`：不把`root` （或任何其他）的`UID/GID`映射到匿名`UID/GID（nobody/nogroup）`
- `async`：指定NFS服务器端是否使用异步写入模式，这个选项可以提高传输速度，但会降低数据的安全性，如果发生断电或网络故障，可能会导致数据丢失或损坏。

> 参考自[Basic NFS Security – NFS, no_root_squash and SUID – The Geek Diary](https://www.thegeekdiary.com/basic-nfs-security-nfs-no_root_squash-and-suid/)

## 2.2nfs客户端

更改`/etc/fstab`为

```
x:/xxx/xxxx /yyy/yyyy nfs vers=3,nolock,rsize=65535,wsize=65535,noatime,nodiratime,async,_netdev 0 0
```

其中

- `vers=3`：指定nfs版本为3
- `nolock`：NFS 服务器和nfs客户端之间不交换文件锁定信息。 服务器不知道该客户端上的文件锁，反之亦然。
- `rsize`和`wsize`：设置nfs操作的最大传输大小。 如果挂载时未指定rsize或wsize，则客户端和服务器协商两者支持的最大大小。
- `noatime`：指定nfs客户端是否更新文件的访问时间，这个选项可以减少对服务器端的写入操作，从而提高传输速度。
- `nodiratime`：禁止nfs服务器更新目录访问时间。
- `async`：使用异步写入模式，这个选项可以提高传输速度，但会降低数据的安全性，如果发生断电或网络故障，可能会导致数据丢失或损坏。
- `_netdev`：无网络服务时不挂载NFS资源。如果存在`/etc/fstab`，则防止客户端在启用网络之前尝试装载 EFS 文件系统
- 最后两个`0`，参考自[Linux中/etc/fstab配置项里最后两个数字是什么意思 - 简书 (jianshu.com)](https://www.jianshu.com/p/8562f66baf71)

> 其中nolock参考自[NFS nolock option ? - Hewlett Packard Enterprise Community (hpe.com)](https://community.hpe.com/t5/operating-system-linux/nfs-nolock-option/td-p/4474666)
>
> rsize和wsize参考自[Linux NFS mount options best practices for Azure NetApp Files | Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-netapp-files/performance-linux-mount-options)
>
> \_netdev参考自[推荐的 NFS 装载选项 - Amazon Elastic File System](https://docs.aws.amazon.com/zh_cn/efs/latest/ug/mounting-fs-nfs-mount-settings.html)

更改选项以后，速度基本没有变化，继续。

# 3.检测nfs传输速度

## 3.1检测v3版本

在nfs客户端所在系统中，使用`dd`命令创建文件，查看传输速度。

此时nfs客户端还是v3版本，先`cd`到nfs挂载目录中（of中的文件名称随便取）

```bash
$ dd if=/dev/zero of=./130-v3-1M-1024.bin bs=1M count=1024
```

其中

- `bs`：块大小
- `count`：块的数量

命令回显

```
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 26.1779 s, 41.0 MB/s
```

其中`41.0 MB/s`是速度，与前文提到的ttnode显示的速度是一致的。

更改一下bs和count参数，重新创建一个1G的文件，再次尝试

```bash
$ dd if=/dev/zero of=./130-v3-1G-1.bin bs=1G count=1
```

命令回显

```
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.0853 s, 44.6 MB/s
```

速度变化不大，说明问题就出在nfs的传输上，继续。

## 3.2检测v4.2版本

我在询问chatgpt和newbing之后，均看到了推荐使用v4版本的nfs。

一开始在客户端挂载nfs路径时未指定版本，后来在看了[使用qBittorent使用NFS对接nas存储的时候遇到的性能问题排查方法 - KeL0v0-blogcenter (atsuko.org)](https://atsuko.org/?p=309)之后选择了v3版本，3.1中的测速也是v3版本。

下面将指定nfs为v4.2。

**注意**：在挂载omv的nfs时，v3和v4版本的挂载路径不同。例如omv中nfs路径为`/export/volume0`，v3版本挂载时路径写为`/export/volume0`，v4版本挂载时路径写为`/volume0`，即v4比v3版本少了前面的`/export`

> 参考自[NFS — openmediavault 5.x.y documentation](https://docs.openmediavault.org/en/5.x/administration/services/nfs.html)

我在pve中挂载了omv中的nfs路径，通过映射的方式，将挂载后的目录映射到lxc中。

**注意**：映射需要在pve系统中指定，需要更改lxc的配置文件。pve挂载nfs后，会将目录映射在`/mnt/pve`中。当想把nfs目录`/volume0`映射到lxc时，可添加以下内容

```
mp0: /mnt/pve/volume0,mp=/mnt/volume0
```

> lxc挂载nfs参考自[如何在PVE的LXC容器中挂载NFS目录 - cch的划水站 (hcc0v0.cyou)](https://hcc0v0.cyou/archives/如何在pve的lxc容器中挂载nfs目录)

挂载完成后，在nfs客户端所在系统中使用`dd`命令再次创建文件，测试nfs传输速度

```bash
$ dd if=/dev/zero of=./130-v4mp-1M-1024.bin bs=1M count=1024
```

命令回显

```
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 7.71491 s, 139 MB/s
```

更改一下bs和count参数，重新创建一个1G的文件，再次尝试

```bash
$ dd if=/dev/zero of=./130-v4mp-1G-1.bin bs=1G count=1
```

命令回显

```
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 8.44596 s, 127 MB/s
```

速度能达到120MB/s，比之前提高了不少，ttnode显示为127MB/s。

# 4.最后

简单总结：**客户端版本从v3改为了v4.2**（v4和v4.1未测试）。两个版本存在速度差异的原因未知，困扰了我好几天，再不解决都打算直接在omv中安装qbittorrent了。

# 附录

在更换了nfs客户端版本以后，我在jellyfin的lxc中同样使用`dd`命令测速，结果如下，速度能达到120MB/s。

```bash
$ dd if=/dev/zero of=./jellyfin-v4-1M-1024.bin bs=1M count=1024
```

```
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 8.88698 s, 121 MB/s
```

```bash
$ dd if=/dev/zero of=./jellyfin-v4-1G-1.bin bs=1G count=1
```

```
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 8.93422 s, 120 MB/s
```
