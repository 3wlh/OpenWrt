# Orange Pi 5 Plus
#### 插件(luci-app)：
```
-luci-app-upnp -luci-app-advancedplus -luci-app-wizard -luci-app-amlogic -luci-app-partexp -luci-app-autoreboot -luci-app-fileassistant luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-vssr luci-app-eqosplus luci-app-unishare luci-app-filebrowser-go luci-app-sunpanel luci-app-alist
```
#### USB(luci-app)：
```
libpci pciids pciutils usbutils libusb-1.0-0 usbmuxd libusbmuxd kmod-scsi-core kmod-usb-core kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas kmod-usb3
```

#### 初始化(Shell):
```
#!/bin/bash
#========ARGON========
if [ ! -n "$(uci -q get argon.@global[])" ]; then
	echo "" > "/etc/config/argon"
	uci add argon global
	uci commit argon
fi
uci set argon.@global[0].online_wallpaper="none"
uci set argon.@global[0].mode="normal"
uci set argon.@global[0].bing_background="0"
uci set argon.@global[0].transparency_dark="0.2"
uci set argon.@global[0].dark_primary="#123456"
uci set argon.@global[0].primary="#123456"
uci set argon.@global[0].blur_dark="1"
uci set argon.@global[0].transparency="0.2"
uci set argon.@global[0].blur="1"
uci commit argon

#========Fstab========
# 自动挂载未配置的Swap
uci set fstab.@global[0].anon_swap="0"
# 自动挂载未配置的磁盘
uci set fstab.@global[0].anon_mount="0"
# 自动挂载交换分区
uci set fstab.@global[0].auto_swap="0"
# 自动挂载磁盘
uci set fstab.@global[0].auto_mount="1"
uci commit fstab

#========Firewall========
# 默认设置WAN口防火墙打开
uci set firewall.@zone[1].input='ACCEPT'
uci commit firewall

#========Network========
# 更改 eth1 为 WAN 口
uci del_list network.@device[0].ports="eth0"
uci add_list network.@device[0].ports="eth1"
uci set network.wan.device="eth0"
# 删除 WAN6 口
uci -q delete network.wan6
# 设置拨号协议
uci set network.wan.proto="pppoe"
# 旁路设置
# uci set network.lan.proto='dhcp'
# 添加 eth0 为 LAN 口
# uci add_list network.@device[0].ports="eth1"
# 删除 WAN 口
# uci -q delete network.wan
# 添加 网关 和 DNS
# uci set network.lan.gateway="10.10.10.254"
# uci add_list network.lan.dns="114.114.114.114"
uci commit network

#========DHCP========
# 禁用 ipv6 DHCP
# DHCPv6 服务
uci -q delete dhcp.lan.dhcpv6
# RA 服务
uci -q delete dhcp.lan.ra
# NDP 代理
uci -q delete dhcp.lan.ndp
# 禁用 ipv6 解析
uci set dhcp.@dnsmasq[0].filter_aaaa="1"
uci commit dhcp
# 不提供DHCP服务
# uci set dhcp.lan.ignore="1"
uci commit dhcp

#========System========
# 关闭系统 Blue_led
Blue_LED=$(find "/sys/class/leds/" -type l -name "*blue*" | sed "s|.*/||g")
if [ -n "${SYS_LED}" ]; then
	uci set system.led_blue="led"
	uci set system.led_blue.name="Blue"
	uci set system.led_blue.sysfs="${Blue_LED}"
	uci set system.led_blue.trigger="none"
	uci set system.led_blue.default="0"
fi
# 关闭系统 Green_led
Green_LED=$(find "/sys/class/leds/" -type l -name "*green*" | sed "s|.*/||g")
if [ -n "${SYS_LED}" ]; then
	uci set system.led_green="led"
	uci set system.led_green.name="Green"
	uci set system.led_green.sysfs="${Green_LED}"
	uci set system.led_green.trigger="none"
	uci set system.led_green.default="0"
fi
uci commit system
```