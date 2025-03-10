拷贝 alpine 3.10 + 3.12 rootfs.img 进 USB，直接刷 alpine OK?
构建 alpine rootfs 是否可以直接使用官方 uboot 版本？
构建最新 kernel + alpine

## notes

### alpine-3.10-kernel-4.14

resizing filesystem from 178176 to 1907712 blocks

### alpine-3.21-kernel-4.14

EXT4-fs (mmcblk0p1): bad geometry: block count 1907712 exceeds size of device (178176 blocks)

### alpine-3.12-kernel-5.4

ext4_lookup comm init.sh checksum invalid

### alpine-3.12-kernel-4.14

stuck at `Resize rootfs, please reboot after finish`
