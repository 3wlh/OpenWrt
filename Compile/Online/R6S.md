# NanoPi R6S
#### 插件(luci-app)：
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-wizard luci-app-ttyd luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-eqosplus luci-app-hd-idle luci-app-unishare luci-app-filebrowser-go  luci-app-sunpanel luci-app-alist
```
#### 初始化(Shell):
```
#!/bin/bash

#========变量========
Fstab="/etc/config/fstab"
ARGON="/etc/config/argon"
DHCP="/etc/config/dhcp"
Network="/etc/config/network"
System="/etc/config/system"
Sunpanel="/etc/config/sunpanel"

#========Fstab========
# 更改挂挂载选项
sed -i "s|option anon_swap .*|option anon_swap '0'|g" $Fstab
sed -i "s|option anon_mount .*|option anon_mount '0'|g" $Fstab
sed -i "s|option auto_swap .*|option auto_swap '0'|g" $Fstab
sed -i "s|option auto_mount .*|option auto_mount '1'|g" $Fstab

# 添加挂载
if ! grep -q "bca936d6-56dc-44b7-b0d0-2d30f83091dc" $Fstab; then
cat >>$Fstab<<EOF

config mount
	option target '/mnt/EMMC'
	option uuid 'bca936d6-56dc-44b7-b0d0-2d30f83091dc'
	option enabled '1'
	
EOF
else
EMMC=$((`awk "/'bca936d6-56dc-44b7-b0d0-2d30f83091dc'/{print NR}" $Fstab`))  && sed -i -e "$(($EMMC-1)),$(($EMMC-1))s|'.*'|'/mnt/EMMC'|g" -e "$(($EMMC+1)),$(($EMMC+1))s|'.*'|'1'|g" $Fstab
fi
#========ARGON========

cat >$ARGON<<EOF

config global
	option online_wallpaper 'none'
	option mode 'normal'
	option bing_background '0'
	option transparency_dark '0.2'
	option dark_primary '#e16496'
	option primary '#e16496'
	option blur_dark '1'
	option transparency '0.2'
	option blur '1'
	option save '保存更改'
EOF

#========DHCP========

# 禁用 ipv6 DHCP
sed -i "/option dhcpv6 'hybrid'/d" $DHCP
sed -i "/option ra 'hybrid'/d" $DHCP
sed -i "/option ra_slaac '1'/d" $DHCP
sed -i "/list ra_flags 'managed-config'/d" $DHCP
sed -i "/list ra_flags 'other-config'/d" $DHCP
sed -i "/option ndp 'hybrid'/d" $DHCP
# 禁用 ipv6 解析
if ! grep -q "option filter_aaaa" $DHCP; then
	sed -i "/option allservers/a\	option filter_aaaa '1'" $DHCP
else
	sed -i "s|option filter_aaaa .*|option filter_aaaa '1'|g" $DHCP
fi

#========Network========
# 更改 eth1 为 WAN 口
# sed -i "/list ports 'eth1'/d" $Network
# sed -i "s/option device 'eth2'/option device 'eth1'/g" $Network
# 添加 eth2 LAN 口
# sed -i "/list ports 'eth0'/a\	list ports 'eth2'" $Network
# 删除 UTUN 口
utun=$((`awk "/con.*'utun'/{print NR}" $Network`))  && sed -i "${utun},$(($utun+3))d" $Network
# 删除 WAN6 口
WAN6=$((`awk "/con.*'wan6'/{print NR}" $Network`))  && sed -i "${WAN6},$(($WAN6+3))d" $Network

#========System========
# echo ledtrig-netdev > /etc/modules.d/led-for-r6s && ln -s /etc/modules.d/led-for-r6s /etc/modules-boot.d/led-for-r6s && modprobe ledtrig-netdev
# 网口 LED 循序
# WAN
wan=$((`awk "/'green:wan'/{print NR}" $System`+3))  && sed -i "${wan},${wan}s/'eth.*'/'eth2'/g" $System 
# LAN1
lan1=$((`awk "/'green:lan-1'/{print NR}" $System`+3))  &&  sed -i "${lan1},${lan1}s/'eth.*'/'eth1'/g" $System
# LAN2
lan2=$((`awk "/'green:lan-2'/{print NR}" $System`+3))  && sed -i "${lan2},${lan2}s/'eth.*'/'eth0'/g" $System
# 更改网口闪烁方式
sed -i "s/option mode .*/option mode 'link'/g" $System
# 关闭系统 led
if ! grep -q "option name 'SYS_LED'" $System; then
cat >>$System<<EOF

config led
	# red:power & red:sys
	option name 'SYS_LED'
	option sysfs 'red:power'
	option trigger 'none'
	option default '0'
	
EOF
fi
#========Sunpanel========
# 设置导航页
cat >$Sunpanel<<EOF

config sunpanel
	option enabled '1'
	option port '88'
	option config_path '/mnt/EMMC/Config/SunPanel'
EOF
```