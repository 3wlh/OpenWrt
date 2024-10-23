# NanoPi R6S
#### 插件(luci-app)：
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-wizard luci-app-ttyd luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-eqosplus luci-app-hd-idle luci-app-unishare luci-app-filebrowser-go  luci-app-sunpanel luci-app-alist
```
#### 初始化(Shell):
```
#!/bin/bash
#========Fstab========
# 自动挂载未配置的Swap
uci set fstab.@global[].anon_swap="0"
# 自动挂载未配置的磁盘
uci set fstab.@global[].anon_mount="0"
# 自动挂载交换分区
uci set fstab.@global[].auto_swap="0"
# 自动挂载磁盘
uci set fstab.@global[].auto_mount="1"

#========ARGON========
uci set argon.@global[].online_wallpaper="none"
uci set argon.@global[].mode="normal"
uci set argon.@global[].bing_background="0"
uci set argon.@global[].transparency_dark="0.2"
uci set argon.@global[].dark_primary="#e16496"
uci set argon.@global[].primary="#e16496"
uci set argon.@global[].blur_dark="1"
uci set argon.@global[].transparency="0.2"
uci set argon.@global[].blur="1"

#========DHCP========
# 禁用 ipv6 DHCP
# DHCPv6 服务
uci -q delete dhcp.lan.dhcpv6
# RA 服务
uci -q delete dhcp.lan.ra
# NDP 代理
uci -q delete dhcp.lan.ndp
# 禁用 ipv6 解析
uci set dhcp.@dnsmasq[].filter_aaaa="1"

#========Network========
# 更改 eth1 为 WAN 口
uci del_list network.@device[].ports="eth1"
uci add_list network.@device[].ports="eth2"
uci set network.wan.device="eth1"
# 删除 WAN6 口
uci delete network.wan6
# 设置拨号协议
uci set network.wan.proto="pppoe"

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
# 关闭系统 led [red:power & red:sys]
uci set system.led_sys="led"
uci set system.led_sys.name="SYS_LED"
uci set system.led_sys.sysfs="red:power"
uci set system.led_sys.trigger="none"
uci set system.led_sys.default="0"
# 更改名称
uci set system.@system[].hostname='R6S'

```