# OpenWrt
## 在线编译 ：
#### 
* [在线编译教程](/Compile/Online/README.md)
* [友善R6S](/Compile/Online/R6S.md)
* [斐讯N1](/Compile/Online/N1.md)

## 本地编译 ：
#### 环境安装：
```sh
wget -O - https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Compile/Local_Compilation/env.sh | bash
```
* [OpenWrt插件名](/Compile/Local/Pluginqa_Name.txt)
* [OpenWrt插件管理](/Compile/Local/Plug-ina_Manager.txt)
#### 本地编译教程：
* [LEDE](/Compile/Local/LEDE.md)
* [immortalwrt](/Compile/Local/immortalwrt.md)
* [openwrt-redmi](/Compile/Local/openwrt-redmi.md)

###### 系统初始化
```
#!/bin/bash
dir="/etc/init.d/config"
# 写入开机启动
cat > $dir <<'EOF'
#!/bin/sh /etc/rc.common

START=99
STOP=15
dir="/usr/bin/"
name="config"

start() {
  echo start
  while :
	do
	ping -c 1 github.cooluc.com > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo 检测网络正常
			# 判断文件
			if [ -e dir ]
			then
				# 运行文件
				chmod +x $dir$name
				cd $dir && ./$name
				if [ $? -eq 0 ];then
					rm -f $dir$name
					break
				fi	
			else
				# 下载文件
				wget https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/openwrt/api/config -O $dir$name
				if [ $? -eq 0 ];then
					# 运行文件
					chmod +x $dir$name
					cd $dir && ./$name
					if [ $? -eq 0 ];then
						rm -f $dir$name
						break
					fi	
				fi	
			fi
		else
			echo 检测网络连接异常
		fi
	sleep 5
	done
	#删除自启动
	/etc/init.d/config disable
	#删除服务文件
	rm -f /etc/init.d/config
}
EOF
#给予运行权限
chmod +x /etc/init.d/config
#创建自启动
/etc/init.d/config enable
```

###### 开机自起配置
```
#!/bin/sh /etc/rc.common
START=99
STOP=15

start() {
  echo start
  dir="/usr/bin/"
  name="config-api"
  while :
	do
	ping -c 1 github.cooluc.com > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo 检测网络正常
			# 启动的命令
			# wget -O - https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Shell/clash_core.sh | bash
			# 判断文件
			if [ -e dir ]
			then
				# 运行文件
				cd $dir && ./$name
				if [ $? -eq 0 ];then
					rm -f $dir$name
					break
				fi	
			else
				# 下载文件
				wget https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Shell/clash_core.sh -O $dir$name
				if [ $? -eq 0 ];then
					# 运行文件
					cd $dir && ./$name
					if [ $? -eq 0 ];then
						rm -f $dir$name
						break
					fi	
				fi	
			fi
		else
			echo 检测网络连接异常
		fi
	sleep 5
	done
	#删除自身
	rm -f $0
}

stop() {
  echo stop
  #终止应的命令
}
```













