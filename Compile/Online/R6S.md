# NanoPi R6S
#### 插件(luci-app)：
```
 -luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-filemanager -luci-app-wizard -luci-app-webadmin -luci-app-partexp -luci-app-diskman -luci-app-syscontrol
```
```
 uhttpd libstdcpp6 openssl-util luci-app-ramfree luci-app-turboacc luci-app-v2ray-server luci-app-ttyd luci-app-ddns ddns-scripts-dnspod ddns-scripts-cloudflare luci-app-vssr luci-app-unishare luci-app-sunpanel luci-app-alist
```
#### 初始化(Shell):
```
#!/bin/bash
#========变量========
KEY=$(ip -o link show eth0 | awk '{print $NF}' | tr -d '\n' | md5sum | awk '{print $1}' | cut -c9-24)
PPOE_User=$(echo "VfJYy92qZbEM8KZAvJN6Pw==" | openssl enc -e -aes-128-cbc -a -K ${KEY} -iv ${KEY} -base64 -d 2>/dev/null)
PPOE_PWD=$(echo "zHZ4RAG+Q4VPG+8w4NJ5vA==" | openssl enc -e -aes-128-cbc -a -K ${KEY} -iv ${KEY} -base64 -d 2>/dev/null)

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
uci set argon.@global[0].dark_primary="#6666FF"
uci set argon.@global[0].primary="#6666FF"
uci set argon.@global[0].blur_dark="1"
uci set argon.@global[0].transparency="0.2"
uci set argon.@global[0].blur="1"
uci commit argon

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

#========Firewall========
# 默认设置WAN口防火墙打开
uci set firewall.@zone[1].input='ACCEPT'
uci commit firewall

#========Network========
# 更改 eth1 为 WAN 口
uci del_list network.@device[0].ports="eth1"
uci add_list network.@device[0].ports="eth2"
uci set network.wan.device="eth1"
# 删除 WAN6 口
uci -q delete network.wan6
# 设置拨号协议
uci set network.wan.proto="pppoe"
uci set network.wan.username="${PPOE_User}"
uci set network.wan.password="${PPOE_PWD}"
uci commit network

#========System========
# echo ledtrig-netdev > /etc/modules.d/led-for-r6s && ln -s /etc/modules.d/led-for-r6s /etc/modules-boot.d/led-for-r6s && modprobe ledtrig-netdev
# 网口 LED 循序
# WAN LED
uci set system.led_wan.dev="pppoe-wan"
# LAN1 LED
uci set system.led_lan1.dev="eth1"
# LAN2 LED
uci set system.led_lan2.dev="eth0"
# 更改网口闪烁方式
uci set system.led_wan.mode="link"
uci set system.led_lan1.mode="link"
uci set system.led_lan2.mode="link"
# 关闭系统 SYS_led
RED_LED=$(find "/sys/class/leds/" -type l -name "*red*" | sed "s|.*/||g")
if [ -n "${RED_LED}" ]; then
	uci set system.led_red="led"
	uci set system.led_red.name="SYS"
	uci set system.led_red.sysfs="${RED_LED}"
	uci set system.led_red.trigger="none"
	uci set system.led_red.default="0"
fi
# 更改名称
uci set system.@system[0].hostname='R6S'
uci commit system
```