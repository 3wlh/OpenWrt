#!/bin/bash
dir="/etc/init.d/config"
# 写入开机启动
echo "开始配置"
cat > $dir <<'EOF'
#!/bin/sh /etc/rc.common
START=99
STOP=15
dir="/usr/bin/Auto_Config"
start() {
  echo start
  while :
	do
	ping -c 1 github.cooluc.com > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo 检测网络正常
			# 下载文件
			wget https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/openwrt/api/Auto_Config -O $dir$name
			if [ $? -eq 0 ];then
				# 运行文件
				chmod +x $dir$name
				if [ $? -eq 0 ];then
					bash -c $dir$name
					break
				fi					
			fi	
		else
			echo 检测网络连接异常
		fi
	sleep 5
	done
	/etc/init.d/config disable
	rm -f "/etc/init.d/config"
}
EOF
#给予运行权限
chmod +x /etc/init.d/config
#创建自启动
/etc/init.d/config enable
#启动脚本
echo "配置完成"