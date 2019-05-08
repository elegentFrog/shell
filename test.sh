#!/bin/bash
oneinstack_url="http://mirrors.linuxeye.com/oneinstack-full.tar.gz"
rtmp_url="https://github.com/arut/nginx-rtmp-module/archive/master.zip"
init_dir=/usr/local/src
function judgeUrl(){
	num1=`wget --spider -nv $1 2>&1 | grep -c 200`
	return $num1
}

function download_rtmp(){
	judgeUrl $rtmp_url
	if [ $? -eq 1 ];then
		wget -P $init_dir $rtmp_url 
	        num2=`command -v zip | wc -l`
	        if [ $num2 -eq 0 ];then
	                yum install -y zip
	                unzip -q ${init_dir}/master.zip -d $init_dir
	        elif [ $num2 -eq 1 ];then
	                unzip -q ${init_dir}/master.zip -d $init_dir
	        fi
		return 1
	fi
}

function download_oneinstack(){
	judgeUrl $oneinstack_url
	if [ $? -eq 1 ];then
		wget -P $init_dir $oneinstack_url 
	        if [ $? -eq 0 -a -d "/usr/local/src/nginx-rtmp-module-master" ];then
	                tar -zxf ${init_dir}/oneinstack-full.tar.gz -C $init_dir
	                line=`cat ${init_dir}/oneinstack/options.conf | grep -n "nginx_modules_options=" | cut -f 1 -d ":"`
	                commands="${line}s"
	                sed -i "$commands#=''#='--add-module=/usr/local/src/nginx-rtmp-module-master'#g" ${init_dir}/oneinstack/options.conf         
	        fi
	        sed -i -e "s#Linuxeye/#WMS_SERVER#g;s#linuxeye@#WMS_SERVER@#g;s/#sed -i/sed -i/g" ${init_dir}/oneinstack/include/nginx.sh
	    return 1
	else
        echo "Check the url address and check the network!"
        return 0
	fi
}
function version(){
	version_u=`cat /etc/issue | cut -f 1 -d " "`
	version_c=`cat /etc/redhat-release | cut -f 1 -d " "`
	version_c_num=`cat /etc/redhat-release | cut -f 4 -d " " | cut -f 1 -d "."`
	if [ "$version_u" == "Ubuntu" ];then
		return 1   #1------>ubuntu
	elif [ "$version_c" == "CentOS" -a $version_c_num -eq 7 ];then
		return 2   #2------>centos7
	fi
}

function ffmpeg(){
	version
	if [ $? -eq 1 ];then
		sudo apt-get install ffmpeg
		if [ `command -v ffmpeg | wc -l` -eq 1 ];then
			echo "ffmpeg installed Successfully!"
			return 1
		fi
	elif [ $? -eq 2 ]; then
		yum install -y epel-release 
		yum repolist
		rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
		rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
		yum repolist
		yum install -y ffmpeg
		if [ `command -v ffmpeg | wc -l` -eq 1 ];then
			echo "ffmpeg installed Successfully!"
			return 1
		fi
	fi
}

function emqx(){
	version
	if [ $? -eq 1 ];then
		mv emqx-ubuntu16.04-v3.1.0_amd64.deb $init_dir
		sudo dpkg -i $init_dir/emqx-ubuntu16.04-v3.1.0_amd64.deb
	elif [ $? -eq 2 ]; then
		mv emqx-centos7-v3.1-beta.3.x86_64.rpm $init_dir
		rpm -ivh $init_dir/emqx-centos7-v3.1-beta.3.x86_64.rpm
	fi
}

if [ `id -u` -eq 0 ];then
	download_rtmp
	if [ $? -eq 1 ];then
		download_oneinstack
		if [ $? -eq 1 ];then
			ffmpeg
			if [ $? -eq 1 ];then
				emqx
				rm -rf $init_dir/oneinstack-full.tar.gz
				rm -rf $init_dir/master.zip
				$init_dir/oneinstack/install.sh
			else
				echo "ffmpeg wrong"
			fi
			echo "success"
		else
		    echo "Check the url address and check the network,please!"
		fi
	fi
else
	echo "Please switch to root and execute the script!!!"
fi