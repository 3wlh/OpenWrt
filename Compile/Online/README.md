# supes在线编译
## 网址：
* [在线编译](https://supes.top/)
## 插件（luci-app）：
#### Friendlyelec
```sh
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-fileassistant -luci-app-wizard -luci-app-webadmin -luci-app-partexp -luci-app-diskman luci-app-ramfree luci-app-turboacc luci-app-ddns luci-app-v2ray-server luci-app-vssr luci-app-unishare luci-app-ttyd luci-app-hd-idle luci-app-filebrowser-go luci-app-sunpanel luci-app-alist
```
#### 旁路由
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-fileassistant -luci-app-wizard -luci-app-webadmin -luci-app-partexp -luci-app-diskman luci-app-v2ray-server 
```

#### 旁路由_Docker|Store
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-fileassistant -luci-app-wizard -luci-app-webadmin -luci-app-partexp -luci-app-diskman luci-app-v2ray-server luci-app-dockerman luci-app-store
```

#### 网络服务 Docker
```
-luci-app-gpsysupgrade -luci-proto-wireguard -luci-app-upnp -luci-app-advancedplus -luci-app-fileassistant -luci-app-wizard -luci-app-webadmin -luci-app-partexp -luci-app-diskman luci-app-dockerman luci-app-store luci-app-uhttpd luci-app-unishare luci-app-hd-idle luci-app-filebrowser-go luci-app-cifs-mount luci-app-cloudflared luci-app-ttyd
```
## 初始化（Shell）：
* [ARM_shell](https://github.com/3wking/3wking/blob/main/OpenWrt/Shell/arm.md)
* [X86_shell](https://github.com/3wking/3wking/blob/main/OpenWrt/Shell/x86.md)
* [Friendlyelec_shell](https://github.com/3wking/3wking/blob/main/OpenWrt/Shell/Friendlyelec_arm.md)