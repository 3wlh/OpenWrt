#!/bin/bash
dir="/etc/init.d/config"
echo "开始写配置"
cat >$dir<<EOF
#!/bin/sh /etc/rc.common
START=99
STOP=15

start() {
  echo start
  dir="/usr/bin/"
  name="config"
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
EOF
chmod +x $dir
echo "写配置结束"