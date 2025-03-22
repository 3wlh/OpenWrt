# PVE编译OpenWRT：
## 编译准备：
#### 开启ssh
```
sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
reboot
```
#### 创建admin用户
```
useradd admin && passwd admin
```
#### 修改admin权限
```
# 找到以下文件 /etc/sudoers 
# 找到 root	ALL=(ALL:ALL) ALL
# 后面加入一行，写入刚才你建立的用户名：
# admin ALL=(ALL:ALL) ALL
# 命令：
sed -i '/root\tALL=(ALL:ALL) ALL/a\admin\tALL=(ALL:ALL) ALL' /etc/sudoers
```
#### 进入用户
```
su admin
```
#### 更新系统
```
sudo apt-get update
```
#### 创建文件夹
```
cd / && sudo mkdir /Compile && sudo chmod 777 /Compile
```
#### 拉取源码
###### LEDE源码
```
git clone https://github.com/coolsnowwolf/lede.git /Compile
```
###### OpenWrt源码
```
git clone https://github.com/openwrt/openwrt.git /Compile
```
###### orangepi-xunlong源码
```
git clone https://github.com/orangepi-xunlong/openwrt.git -b openwrt-22.03 /Compile
```
#### 更改feeds.conf.default
###### OpenWrt 更换Github源
```
echo "src-git packages https://github.com/openwrt/packages.git" > feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git" >> feeds.conf.default
# 添加自定义仓库
echo "src-git kiddin9 https://github.com/kiddin9/openwrt-packages.git" >> feeds.conf.default
```
###### OpenWrt 加速地址
```
sed -i "s|https://github.com|https://ghproxy.net/https://github.com|" feeds.conf.default
```
###### 添加仓库
```
echo "src-git-full kiddin9 https://github.com/kiddin9/openwrt-packages.git" >> feeds.conf.default
```
#### GitHub加速
###### 查看已有配置
```
sudo git config --global --list
```
###### 删除全局配置项
```
git config --global --unset url.<base>.insteadOf
sudo git config --global --unset url.https://ghproxy.net/https://github.com.insteadof
```
###### URL替换
```
git config --global url."https://github.com/".insteadOf "https://ghproxy.net/https://github.com"

sudo git config --global url."https://ghproxy.net/https://github.com".insteadOf "https://github.com" 

```
###### 修改~/.gitconfig文件
```
[url "https://github.com/"]
	insteadOf = https://ghproxy.com/https://github.com/
```

## 编译：
#### 进入目录
```
cd /Compile
```
#### 更新源码
```
git pull
```
#### 更新插件
```
./scripts/feeds update -a && ./scripts/feeds install -a
```

#### 编译选项
```
make menuconfig
```
#### 配置生效
```
 make defconfig
```
#### 下载dll库:
```sh
make download -j$(nproc)
```
```sh
make download -j$(nproc) V=s  #显示信息
```
#### 开始编译
```
make -j$(nproc) V=s
```
```
make -j$(($(nproc) + 1)) V=s
```
#### 编译IPK
```
make package/<IPK名>/compile V=99
```
#### 清理编译
```
sudo make clean -j$(($(nproc) + 1)) V=s
sudo make dirclean -j$(($(nproc) + 1)) V=s
sudo make distclean -j$(($(nproc) + 1)) V=s
```
#### 清理编译
```
make package/luci-theme-rosy/luci-theme-rosy clean
```




