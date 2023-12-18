#!/bin/bash
dir="/usr/share/api/"
file="api_arm"
api="https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Config/api_arm"
url="https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Config/Config/"
if [ -e $dir$file ]; then
	chmod +x $dir$file
	cd $dir && ./$file $pwd $url
else	
	mkdir -p $dir
	wget $api -O $dir$file
	chmod +x $dir$file
	cd $dir && ./$file $pwd $url
fi