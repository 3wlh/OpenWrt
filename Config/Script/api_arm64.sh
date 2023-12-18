#!/bin/bash
dir="/usr/share/api/"
file="api_arm64"
api="https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Config/api_arm64"
url="https://github.cooluc.com/https://raw.githubusercontent.com/3wking/OpenWrt/main/Config/Config/"
if [ ! -e $dir$file ]; then
	mkdir -p $dir
	wget $api -O $dir$file
	chmod +x $dir$file
fi	
	cd $dir && ./$file $pwd $url