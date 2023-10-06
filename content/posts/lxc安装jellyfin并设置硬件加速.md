---
title: "lxc安装jellyfin并设置硬件加速"
date: 2023-08-24T23:24:41+08:00
tags: ["lxc", "jellyfin"]
categories: ["技术"]
---

lxc模板：debian12

# 编辑lxc配置文件

```bash
$ vim /etc/pve/lxc/121.conf
```

写入以下内容

```
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.autodev: 1
lxc.hook.autodev: /var/lib/lxc/121/mount_hook.sh
```

编辑设备映射

```bash
$ vim /var/lib/lxc/121/mount_hook.sh
```

写入以下内容

```
#!/bin/sh
mkdir -p ${LXC_ROOTFS_MOUNT}/dev/dri
mknod -m 666 ${LXC_ROOTFS_MOUNT}/dev/dri/card0 c 226 0
mknod -m 666 ${LXC_ROOTFS_MOUNT}/dev/dri/renderD128 c 226 128
```

# 安装jellyfin

>[Linux | Jellyfin](https://jellyfin.org/docs/general/installation/linux)

```bash
$ apt install curl gpg
```

```bash
$ curl https://repo.jellyfin.org/install-debuntu.sh | bash
```

解决中文乱码。我没安装，未出现中文乱码问题。

```bash
$ apt install fonts-noto-cjk-extra
```

# 效果

vainfo回显

```bash
$ root@jellyfin:~# vainfo
```

```
error: XDG_RUNTIME_DIR is invalid or not set in the environment.
error: can't connect to X server!
libva info: VA-API version 1.17.0
libva info: Trying to open /usr/lib/x86_64-linux-gnu/dri/iHD_drv_video.so
libva info: Found init function __vaDriverInit_1_17
libva info: va_openDriver() returns 0
vainfo: VA-API version: 1.17 (libva 2.12.0)
vainfo: Driver version: Intel iHD driver for Intel(R) Gen Graphics - 23.1.1 ()
vainfo: Supported profile and entrypoints
      VAProfileMPEG2Simple            : VAEntrypointVLD
      VAProfileMPEG2Main              : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointEncSliceLP
      VAProfileH264High               : VAEntrypointVLD
      VAProfileH264High               : VAEntrypointEncSliceLP
      VAProfileJPEGBaseline           : VAEntrypointVLD
      VAProfileJPEGBaseline           : VAEntrypointEncPicture
      VAProfileH264ConstrainedBaseline: VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSliceLP
      VAProfileVP8Version0_3          : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointVLD
      VAProfileHEVCMain10             : VAEntrypointVLD
      VAProfileVP9Profile0            : VAEntrypointVLD
```

以下为网页播放时的详细信息，说明转码正常。

```
播放信息
	播放器：Html Video Player
	播放方式：转码
	协议：http
	串流类型：HLS

视频信息
	播放器尺寸：3841x1911
	视频分辨率：1280x506
	丢弃的帧：2
	损坏的帧：0

转码信息
	视频编码：H264
	音频编码：AAC (direct)
	声道：2
	比特率：3.0 Mbps
	转码进度：37.7%
	转码帧率：323 fps
	转码原因：视频比特率超过限制

媒体源信息
	媒体载体：mov
	大小：2.7 GiB
	比特率：3.3 Mbps
	视频编码：H264 High
	视频码率：3.2 Mbps
	Video range type：SDR
	音频编码：AAC LC
	比特率：95 kbps
	声道：2
	采样率：48000 Hz
```

# 解决tmdb dns污染

```
https://dnschecker.org/
```

```
api.themoviedb.org
image.tmdb.org
www.themoviedb.org
```

以下ip可能过段时间会变，不具有时效性。

```
api.themoviedb.org 13.32.99.119
api.themoviedb.org 13.32.99.112
api.themoviedb.org 13.32.99.49
api.themoviedb.org 13.32.99.17
image.tmdb.org 169.150.249.168
www.themoviedb.org 18.66.122.3
www.themoviedb.org 18.66.122.47
www.themoviedb.org 18.66.122.113
www.themoviedb.org 18.66.122.75
```

# 最后

如果挂载了硬盘，可以把【常规】中的【缓存路径】、【常规】中的【媒体资料路径】、【播放】中的【转码路径】都换到挂载目录下，以节省lxc中的硬盘空间。
