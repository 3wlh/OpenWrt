# Friendlyelec NanoPi R6S
#### 插件(luci-app)：
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advanced -luci-app-wizard -luci-app-ttyd luci-app-webvirtcloud luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-cifs-mount luci-app-unishare
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

# 禁用 ipv6_DHCP
sed -i "/option dhcpv6 'hybrid'/d" $DHCP
sed -i "/option ra 'hybrid'/d" $DHCP
sed -i "/option ra_slaac '1'/d" $DHCP
sed -i "/list ra_flags 'managed-config'/d" $DHCP
sed -i "/list ra_flags 'other-config'/d" $DHCP
sed -i "/option ndp 'hybrid'/d" $DHCP

#========Network========

# 删除 WAN6
Net=$((`sed -n '/wan6/=' $Network`))
if [ $(($Net)) != 0 ]; then	
	sed -i -e "$(($Net))d" $Network -e "$(($Net+1))d" $Network
	sed -i "/dhcpv6/d" $Network	
fi	

#========LED========

# echo ledtrig-netdev > /etc/modules.d/led-for-r6s && ln -s /etc/modules.d/led-for-r6s /etc/modules-boot.d/led-for-r6s && modprobe ledtrig-netdev
# 更改闪烁方式
sed -i "s/option mode .*/option mode 'link'/g" $LED
# 网口 led 循序
# sed -i -e "s/option dev 'eth0'/option dev 'lan'/g" -e "s/option dev 'eth1'/option dev 'eth0'/g" -e "s/option dev 'lan'/option dev 'eth1'/g" $LED
# 关闭系统 led
if ! grep -q "option name 'SYS_LED'" $LED; then
cat >>$LED<<EOF

config led
	option sysfs 'red:sys'
	option trigger 'none'
	option name 'SYS_LED'
	option default '0'
EOF
fi
```