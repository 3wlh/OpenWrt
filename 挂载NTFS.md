# 挂载NTFS
#### 安装插件
```
opkg install mount-utils ntfs-3g
```
#### 一键修改命令
```sh
sed -i "s/ntfs3/ntfs-3g/" /sbin/mount.ntfs
```
#### 手动修改/sbin/mount.ntfs
```
#!/bin/sh
mount -t ntfs-3g -o iocharset=utf8 "$@"
```
#### 还原修改命令
```sh
sed -i "s/ntfs-3g/ntfs3/" /sbin/mount.ntfs
```
