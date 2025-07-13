# oec turbo
#### oect
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-filemanager -luci-app-wizard -luci-app-webadmin -luci-app-partexp -luci-app-diskman -luci-app-syscontrol libstdcpp6 openssl-util luci-app-dockerman luci-app-store luci-app-unishare luci-app-cloudflared luci-app-ttyd luci-app-hd-idle luci-app-uhttpd luci-app-openlist luci-app-sunpanel
```
#### 初始化(Shell):
```
#!/bin/bash
#========ARGON========
if [ ! -n "$(uci -q get argon.@global[0])" ]; then
	echo "" > "/etc/config/argon"
	uci add argon global
	uci commit argon
fi
uci set argon.@global[0].online_wallpaper="none"
uci set argon.@global[0].mode="normal"
uci set argon.@global[0].bing_background="0"
uci set argon.@global[0].transparency_dark="0.2"
uci set argon.@global[0].primary="#5e72e4"
uci set argon.@global[0].dark_primary="#483d8b"
uci set argon.@global[0].blur_dark="1"
uci set argon.@global[0].transparency="0.2"
uci set argon.@global[0].blur="1"
uci commit argon

#========RustDesk========
dir="/etc/rustdesk-server/"
mkdir -p ${dir}
echo "aTxYkmuXWVBEEOdwiK2xpuUQ5YVFQQqxgeGdYbWd8uY=" > ${dir}id_ed25519.pub
echo "5QToaNwZFgZRhvvD3rUYJQ2MweZUjSB8YH++TYo3YP5pPFiSa5dZUEQQ53CIrbGm5RDlhUVBCrGB4Z1htZ3y5g==" > ${dir}id_ed25519

#========docker========
if [ -n "$(uci -q get dockerd.globals)" ]; then
	uci set dockerd.globals.data_root="/mnt/HDD/docker/"
	# 网易云镜像站
	uci add_list dockerd.globals.registry_mirrors="https://hub-mirror.c.163.com"
	# 百度云镜像站
	uci add_list dockerd.globals.registry_mirrors="https://mirror.baidubce.com"
	# 1panel镜像站
	uci add_list dockerd.globals.registry_mirrors="https://docker.1panel.live"
	# DockerProxy代理加速
	uci add_list dockerd.globals.registry_mirrors="https://dockerproxy.net"
	# 上海交大镜像站
	uci add_list dockerd.globals.registry_mirrors="https://docker.mirrors.sjtug.sjtu.edu.cn"
	# 南京大学镜像站
	uci add_list dockerd.globals.registry_mirrors="https://docker.nju.edu.cn"
	# Daocloud镜像站
	uci add_list dockerd.globals.registry_mirrors="https://docker.m.daocloud.io"
	uci commit dockerd
fi
#========Fstab========
# 自动挂载未配置的Swap
uci set fstab.@global[0].anon_swap="0"
# 自动挂载未配置的磁盘
uci set fstab.@global[0].anon_mount="0"
# 自动挂载交换分区
uci set fstab.@global[0].auto_swap="0"
# 自动挂载磁盘
uci set fstab.@global[0].auto_mount="1"
# 硬盘挂载
# 创建共享目录
if [ ! -d "/mnt/Share" ]; then
    mkdir -p /mnt/Share
fi
Data="$(uci -q show fstab)"

hdduuid="78ecb04e-fe2f-3b49-9f84-b0190e5ebe46"
if [ ! -n "$(echo ${Data} | grep "${hdduuid}")" ]; then
	uci_id="$(uci add fstab mount)"
	uci set fstab.${uci_id}.target="/mnt/HDD"
	uci set fstab.${uci_id}.uuid="${hdduuid}"
	uci set fstab.${uci_id}.enabled="1"
else
	uci_id="$(echo ${Data} | sed 's/fstab/\nfstab/g' | grep "${hdduuid}" | sed 's/\(.*\).uuid=.*/\1/g')"
	uci set ${uci_id}.target="/mnt/HDD"
	uci set ${uci_id}.enabled="1"
fi
if [ ! -L "/mnt/Share/HDD" ]; then
	ln -s /mnt/HDD /mnt/Share
fi

sduuid="3519c925-6c5e-7242-baa9-027d8a399db6"
if [ ! -n "$(echo ${Data} | grep "${sduuid}")" ]; then
	uci_id="$(uci add fstab mount)"
	uci set fstab.${uci_id}.target="/mnt/SD"
	uci set fstab.${uci_id}.uuid="${sduuid}"
	uci set fstab.${uci_id}.enabled="1"
else
	uci_id="$(echo ${Data} | sed 's/fstab/\nfstab/g' | grep "${sduuid}" | sed 's/\(.*\).uuid=.*/\1/g')"
	uci set ${uci_id}.target="/mnt/SD"
	uci set ${uci_id}.enabled="1"
fi
if [ ! -L "/mnt/Share/SD" ]; then
	ln -s /mnt/SD /mnt/Share
fi
uci commit fstab

#========Firewall========
# 默认设置WAN口防火墙打开
uci set firewall.@defaults[0].input='ACCEPT'
uci set firewall.@defaults[0].output='ACCEPT'
uci set firewall.@defaults[0].forward='ACCEPT'
uci set firewall.@zone[1].input='ACCEPT'
# uci set firewall.docker1.input='ACCEPT'
# uci set firewall.docker.output='ACCEPT'
# uci set firewall.docker.forward='ACCEPT'
uci commit firewall

#========Network========
# 旁路设置
# uci set network.lan.proto='static'
# uci set network.lan.ipaddr="10.10.10.250"
# 添加 网关 和 DNS
uci set network.lan.gateway="10.10.10.254"
uci add_list network.lan.dns="10.10.10.254"
uci add_list network.lan.dns="8.8.8.8"
uci add_list network.lan.dns="114.114.114.114"
# 删除 WAN 口
uci -q delete network.wan
uci commit network

#========DHCP========
# 不提供DHCP服务
uci delete dhcp.lan.force
uci set dhcp.lan.ignore="1"
uci set dhcp.lan.dynamicdhcp="0"
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
#========System========
uci set system.@system[0].hostname='OECT'
uci commit system
```