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
#### 更改feeds.conf.default
###### LEDE
```
# 加速地址
export Proxy=1094890624
echo ``
git clone https://github.com/coolsnowwolf/lede.git /Compile
```
###### OpenWrt
```
git clone https://github.com/coolsnowwolf/lede.git /Compile
```


#### GitHub加速
###### URL替换
```
git config --global url."https://github.com/".insteadOf "https://ghproxy.com/https://github.com/"
```
###### 修改~/.gitconfig文件
```
[url "https://github.com/"]
	insteadOf = https://ghproxy.com/https://github.com/
```

## 编译：
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
#### 开始编译
```
make -j$(($(nproc) + 1)) V=s
```
#### 编译IPK
```
make package/<IPK名>/compile V=99
```
#### 清理编译
```
make package/luci-theme-rosy/luci-theme-rosy clean
```




