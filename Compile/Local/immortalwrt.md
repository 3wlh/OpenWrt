# 编译immortalwrt
## PVE编译immortalwrt
#### liunx环境
###### 开启ssh:
```sh
sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
reboot
```
###### 创建用户:
```sh
useradd admin
```
###### 创建密码:
```sh
passwd admin
```
###### 删除用户:
```sh
userdel -r admin
```	
###### 创建用户和密码:
```sh
useradd admin &&(echo admin:123456 | chpasswd)  #密码：123456 
```
###### 添加权限:
```sh
sed -i '/root\tALL=(ALL:ALL) ALL/a\admin\tALL=(ALL) NOPASSWD:ALL' /etc/sudoers
```
```
找到以下文件 /etc/sudoers 
找到 root	ALL=(ALL:ALL) ALL
后面加入一行，写入刚才你建立的用户名：
admin ALL=(ALL) NOPASSWD:ALL
```
###### 更新系统:
```sh
sudo apt update -y
```
###### 更新已有软件:
```sh
sudo apt full-upgrade -y
```
######## 安装环境:
```sh
apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
		bzip2 ccache cmake cpio curl device-tree-compiler ecj fakeroot fastjar flex gawk gettext git \
		gnutls-dev gperf haveged help2man intltool jq libc6-dev-i386 libelf-dev lib32gcc-s1 libglib2.0-dev \
		libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5 libncursesw5-dev \
		libreadline-dev libssl-dev libtool libyaml-dev libz-dev lrzsz mkisofs msmtp nano ninja-build \
		p7zip p7zip-full patch pkgconf python2 libpython3-dev python3 python3-pip python3-ply python3-docutils \
		python3-pyelftools qemu-utils quilt re2c rsync scons squashfs-tools subversion swig texinfo uglifyjs \
		unzip vim wget xmlto xxd zlib1g-dev
```
#### 源码编译
###### 进入用户:
```sh
su admin
```
###### 更新系统:
```sh
sudo apt-get update
```
###### 创建文件夹:
```sh
cd /
sudo mkdir immortalwrt
sudo chmod 777 immortalwrt
```
###### 拉取源码:
```sh
git clone https://github.com/coolsnowwolf/lede
```
```sh
git clone -b <分支> https://github.com/coolsnowwolf/lede
```

###### 添加其他插件源:
```sh
echo "src-git small8 https://github.com/kenzok8/small-package" >> /immortalwrt/feeds.conf.default
```
###### 进入目录:
```sh
cd / && cd immortalwrt
```
###### 更新源码:
```sh
git pull
```
###### 更新插件源:
```sh
./scripts/feeds update -a
```
```sh
./scripts/feeds install -a
```
###### 选择插件:
```sh
make menuconfig
```
###### 下载dll库:
```sh
make download -j$(nproc)
```
```sh
make download -j$(nproc) V=s  #显示信息
```
###### 编译源码:
```sh
make -j1 V=s	# 单核编译(第一次)
```
```sh
make -j$(nproc) V=s	# 多核编译(第2次)
```
###### 重新配置：
```sh
rm -rf ./tmp && rm -rf .config
```

## 额外修改
###### 添加密码:
```sh
echo "root:$1$Ob2V/c3A$HdzeMqZZCxfbG.6X8PjL..:19036:0:99999:7:::" >> /immortalwrt/package/base-files/files/etc/shadow
```
```
目录：/immortalwrt/package/base-files/files/etc目录中的shadow
root:$1$Ob2V/c3A$HdzeMqZZCxfbG.6X8PjL..:19036:0:99999:7:::
```
###### 更改IP:
```sh
sed -i 's/192.168.1.1/10.10.10.254/g' immortalwrt/package/base-files/files/bin/config_generate
```
###### 更改主机名:
```sh
sed -i 's/'OpenWrt'/'3wking'/g' immortalwrt/package/base-files/files/bin/config_generate
```
###### 更改主题:
```sh
ed -i 's/luci-theme-bootstrap/luci-theme-argon/g' /immortalwrt/feeds/luci/collections/luci/Makefile
```
###### 修改固件默认中文:
```
目录：/immortalwrt/feeds/luci/modules/luci-base/root/etc/config
option lang auto 改成 option lang zh_cn
```
###### 修改无线名称:
```
目录：/immortalwrt/package/kernel/mac80211/files/lib/wifi/mac80211.sh
```
###### 定制shell登陆后的欢迎信息:
```
定制shell登陆后的欢迎信息：
定制网址：http://patorjk.com/software/taag/#p=display&f=Big%20Money-nw&t=3WKING
目录：/immortalwrt/package/base-files/files/etc/banner：
```
```
 $$$$$$\  $$\      $$\ $$\   $$\ $$$$$$\ $$\   $$\  $$$$$$\  
$$ ___$$\ $$ | $\  $$ |$$ | $$  |\_$$  _|$$$\  $$ |$$  __$$\ 
\_/   $$ |$$ |$$$\ $$ |$$ |$$  /   $$ |  $$$$\ $$ |$$ /  \__|
  $$$$$ / $$ $$ $$\$$ |$$$$$  /    $$ |  $$ $$\$$ |$$ |$$$$\ 
  \___$$\ $$$$  _$$$$ |$$  $$<     $$ |  $$ \$$$$ |$$ |\_$$ |
$$\   $$ |$$$  / \$$$ |$$ |\$$\    $$ |  $$ |\$$$ |$$ |  $$ |
\$$$$$$  |$$  /   \$$ |$$ | \$$\ $$$$$$\ $$ | \$$ |\$$$$$$  |
 \______/ \__/     \__|\__|  \__|\______|\__|  \__| \______/ 
-------------------------------------------------------------
& by 3wking |$	%D %V, %C	$|    
-------------------------------------------------------------
```