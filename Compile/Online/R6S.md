# NanoPi R6S
#### 插件(luci-app)：
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-wizard -luci-app-ttyd luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-cifs-mount luci-app-unishare
```
#### 初始化(Shell):
```
#!/bin/bash

#========变量========
ARGON="/etc/config/argon"
DHCP="/etc/config/dhcp"
Network="/etc/config/network"
LED="/etc/config/system"

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
# 删除 eth1 LAN 口
sed -i "/list ports 'eth1'/d" $Network
# 添加 eth2 LAN 口
sed -i "/list ports 'eth0'/a\	list ports 'eth2'" $Network
# 更改 eth1 为 WAN 口
sed -i "s/option device 'eth2'/option device 'eth1'/g" $Network
# 删除 UTUN 口
utun=$((`awk "/con.*'utun'/{print NR}" $Network`))  && sed -i "${utun},$(($utun+2))d" $Network
# 删除 WAN6 口
Net=$((`sed -n '/wan6/=' $Network`))
if [ $(($Net)) != 0 ]; then	
	sed -i -e "$(($Net))d" $Network -e "$(($Net+1))d" $Network
	sed -i "/dhcpv6/d" $Network	
fi	

#========LED========
# echo ledtrig-netdev > /etc/modules.d/led-for-r6s && ln -s /etc/modules.d/led-for-r6s /etc/modules-boot.d/led-for-r6s && modprobe ledtrig-netdev
# 网口 LED 循序
# WAN
wan=$((`awk "/'green:wan'/{print NR}" $LED`+3))  && sed -i "${wan},${wan}s/'eth.*'/'eth1'/g" $LED 
# LAN1
lan1=$((`awk "/'green:lan-1'/{print NR}" $LED`+3))  &&  sed -i "${lan1},${lan1}s/'eth.*'/'eth2'/g" $LED
# LAN2
lan2=$((`awk "/'green:lan-2'/{print NR}" $LED`+3))  && sed -i "${lan2},${lan2}s/'eth.*'/'eth0'/g" $LED
# 更改网口闪烁方式
sed -i "s/option mode .*/option mode 'link'/g" $LED
# 关闭系统 led
if ! grep -q "option name 'SYS_LED'" $LED; then
cat >>$LED<<EOF

config led
	# red:power & red:sys
	option sysfs 'red:power'
	option trigger 'none'
	option name 'SYS_LED'
	option default '0'
EOF
fi
```