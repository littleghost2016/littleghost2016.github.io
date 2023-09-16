---
title: "pve初始化配置"
date: 2023-05-12T19:20:58+08:00
tags: ["pve"]
categories: ["技术"]
---

pve安装时选择btrfs为文件系统。

# 1.修改基础系统（Debian）的源文件

```bash
$ sed -i 's|^deb http://deb.debian.org|deb https://mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list
$ sed -i 's|^deb http://security.debian.org|deb https://mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list

$ source /etc/os-release
$ echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve $VERSION_CODENAME pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

$ cp /usr/share/perl5/PVE/APLInfo.pm /usr/share/perl5/PVE/APLInfo.pm_back
$ sed -i 's|http://download.proxmox.com|https://mirrors.tuna.tsinghua.edu.cn/proxmox|g' /usr/share/perl5/PVE/APLInfo.pm
```

更新

```bash
$ apt update
```

重启

```bash
$ reboot
```

或者重启服务

```bash
$ systemctl restart pvedaemon.service
```

# 2.开启硬件直通/核显直通

## 2.1更改grub

```bash
$ vim /etc/default/grub
```

把以下一行

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```

改成

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on pcie_acs_override=downstream i915.enable_guc=3"
```

*其中`i915.enable_guc=3`用于开启Guc*

更新grub

```bash
$ update-grub
```

## 2.2更改内核参数

```bash
$ vim /etc/modules
```

添加以下内容

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

更新内核

```bash
$ update-initramfs -u -k all
```

重启pve

```bash
$ reboot
```

## 2.3核显直通给lxc

我打算在lxc中安装omv5，使用omv5中的docker，所以此时核显直通是将核显直通给lxc即可。如果是将核显直通给虚拟机，需要在pve中屏蔽核显，参考[NAS系列 PVE基本设置 - Bensz (hwb0307.com)](https://blognas.hwb0307.com/nas/3704)。

### 2.3.1检查pve是否识别显卡

```bash
$ ls -l /dev/dri
```

```
total 0
drwxr-xr-x 2 root root          80 May 20 21:07 by-path
crw-rw---- 1 root video   226,   0 May 21 09:36 card0
crw-rw---- 1 root crontab 226, 128 May 21 09:36 renderD128
```

出现`card0`和`renderD128`说明代表PVE可以成功识别核显，未正确识别的话，需要安装驱动。

### 2.3.2检查显卡在pve中是否正常工作

```bash
$ journalctl -b -o short-monotonic -k | egrep -i "i915|dmr|dmc|guc|huc"
```

```
[    0.000000] pve kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-6.2.11-1-pve root=UUID=05b371e3-2647-4b40-a17c-e5285909ed9f ro quiet intel_iommu=on pcie_acs_override=downstream i915.enable_guc=2
[    0.072857] pve kernel: Kernel command line: BOOT_IMAGE=/boot/vmlinuz-6.2.11-1-pve root=UUID=05b371e3-2647-4b40-a17c-e5285909ed9f ro quiet intel_iommu=on pcie_acs_override=downstream i915.enable_guc=2
[    6.279374] pve kernel: Setting dangerous option enable_guc - tainting kernel
[    6.279387] pve kernel: Setting dangerous option enable_guc - tainting kernel
[    6.281844] pve kernel: i915 0000:00:02.0: [drm] VT-d active for gfx access
[    6.284225] pve kernel: i915 0000:00:02.0: vgaarb: deactivate vga console
[    6.284705] pve kernel: i915 0000:00:02.0: [drm] Using Transparent Hugepages
[    6.301239] pve kernel: i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.301837] pve kernel: i915 0000:00:02.0: [drm] Disabling framebuffer compression (FBC) to prevent screen flicker with VT-d enabled
[    6.306802] pve kernel: i915 0000:00:02.0: [drm] Finished loading DMC firmware i915/bxt_dmc_ver1_07.bin (v1.7)
[    6.496736] pve kernel: i915 0000:00:02.0: [drm] GuC firmware i915/bxt_guc_70.1.1.bin version 70.1.1
[    6.496749] pve kernel: i915 0000:00:02.0: [drm] HuC firmware i915/bxt_huc_2.0.0.bin version 2.0.0
[    6.515242] pve kernel: i915 0000:00:02.0: [drm] HuC authenticated
[    6.515256] pve kernel: i915 0000:00:02.0: [drm] GuC submission disabled
[    6.515258] pve kernel: i915 0000:00:02.0: [drm] GuC SLPC disabled
[    6.595857] pve kernel: [drm] Initialized i915 1.6.0 20201103 for 0000:00:02.0 on minor 0
[    6.603918] pve kernel: snd_hda_intel 0000:00:0e.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[    6.617961] pve kernel: i915 0000:00:02.0: [drm] Cannot find any crtc or sizes
[    6.633534] pve kernel: i915 0000:00:02.0: [drm] Cannot find any crtc or sizes
[    6.648040] pve kernel: i915 0000:00:02.0: [drm] Cannot find any crtc or sizes
```

`HuC authenticated`表明HuC固件是正常工作的，但`GuC SLPC disabled`表明GuC未成功启动，但不影响核显直通功能。

### 2.3.3修改i915的配置

参考自[【更新】免费开源影音服务Jellyfin部署，PVE下LXC套娃安装Debian Docker，核显硬解转码以N5105为例低功耗intel CPU核显通用_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Xx4y1G7MG/?spm_id_from=333.999.0.0&vd_source=c376fffe76111ea95c9b1184d027e5bb)。

```bash
$ vim /etc/modprobe.d/i915.conf 
```

添加以下内容，开启低功耗U硬解的参数

```
options i915 enable_guc=3
```

然后重启

```bash
$ reboot
```

# 3.以映射方式直通硬盘

查看硬盘id

```bash
$ ls -la /dev/disk/by-id/|grep -v dm|grep -v lvm|grep -v part
```

使用命令为虚拟机添加硬盘

```bash
$ qm set 101 --sata1 /dev/disk/by-id/xxx
```

