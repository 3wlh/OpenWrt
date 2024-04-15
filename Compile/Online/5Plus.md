# Orange Pi 5 Plus
#### 插件(luci-app)：
```
-luci-app-gpsysupgrade -luci-app-upnp -luci-app-advancedplus -luci-app-wizard luci-app-ramfree luci-app-ttyd luci-app-hd-idle luci-app-unishare luci-app-filebrowser-go luci-app-sunpanel luci-app-alist luci-app-store
```
#### 初始化(Shell):
```
#!/bin/bash

#========变量========
ARGON="/etc/config/argon"
DHCP="/etc/config/dhcp"
Network="/etc/config/network"

#========Network========
# 禁用 DHCP 分配
sed -i "/option dhcpv4 'server'/a\	option ignore '1'" $Network
sed -i "/option ignore '1'/a\	option dynamicdhcp '0'" $Network
# 添加 网关 和 DNS
sed -i "/option ip6assign '60'/a\	option gateway '10.10.10.254'" $Network
sed -i "/option gateway '10.10.10.254'/a\	list dns '10.10.10.254'" $Network
	
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
```


```