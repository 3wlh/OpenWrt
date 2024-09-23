# Orange Pi 5 Plus
#### 插件(luci-app)：
```
-luci-app-upnp -luci-app-advancedplus -luci-app-wizard -luci-app-amlogic luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-vssr luci-app-eqosplus luci-app-unishare luci-app-filebrowser-go luci-app-sunpanel luci-app-alist
```
#### USB(luci-app)：
```
libpci pciids pciutils usbutils libusb-1.0-0 usbmuxd libusbmuxd kmod-scsi-core kmod-usb-core kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas kmod-usb3
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

#========Fstab========
# 更改挂挂载选项
sed -i "s|option anon_swap .*|option anon_swap '0'|g" $Fstab
sed -i "s|option anon_mount .*|option anon_mount '0'|g" $Fstab
sed -i "s|option auto_swap .*|option auto_swap '0'|g" $Fstab
sed -i "s|option auto_mount .*|option auto_mount '1'|g" $Fstab

#========Network========
# 禁用 DHCP 分配
sed -i "/option dhcpv4 'server'/a\	option ignore '1'" $Network
sed -i "/option ignore '1'/a\	option dynamicdhcp '0'" $Network
# 添加 网关 和 DNS
sed -i "/option ip6assign '60'/a\	option gateway '10.10.10.254'" $Network
sed -i "/option gateway '10.10.10.254'/a\	list dns '10.10.10.254'" $Network
# 以下是旁路由模式
# 删除 WAN 口
WAN=$((`awk "/con.*'wan'/{print NR}" $Network`))  && sed -i "${WAN},$(($WAN+3))d" $Network
# 删除 WAN6 口
WAN6=$((`awk "/con.*'wan6'/{print NR}" $Network`))  && sed -i "${WAN6},$(($WAN6+3))d" $Network
添加 eth1 到LAN 口
sed -i "/list ports 'eth.*'/a\	list ports 'eth1'" $Network

#========DHCP========
# 禁用 ipv6_DHCP
sed -i "/config dhcp 'lan'/a\	option dynamicdhcp '0'" $DHCP
sed -i "/option dhcpv6 'hybrid'/d" $DHCP
sed -i "/option ra 'hybrid'/d" $DHCP
sed -i "/option ra_slaac '1'/d" $DHCP
sed -i "/list ra_flags 'managed-config'/d" $DHCP
sed -i "/list ra_flags 'other-config'/d" $DHCP
sed -i "/option ndp 'hybrid'/d" $DHCP
sed -i "/option force '1'/d" $DHCP
# 不提供DHCP服务
sed -i "/option dhcpv4 'server'/a\	option ignore '1'" $DHCP

#========System========
if ! grep -q "option name 'Blue'" $System; then
cat >>$System<<EOF

config led
	option name 'Blue'
	option sysfs 'blue:indicator-1'
	option trigger 'none'
	option default '0'
	
EOF
fi
if ! grep -q "ooption name 'Green'" $System; then
cat >>$System<<EOF

config led
	option name 'Green'
	option sysfs 'green:indicator-2'
	option trigger 'none'
	option default '0'

EOF
fi
```