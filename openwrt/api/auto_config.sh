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