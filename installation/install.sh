#!/usr/bin/env bash

distro=$(cat /etc/os-release | grep -w NAME | cut -d= -f2 | sed 's/"//g');
IP=$(ip a | grep inet | grep 192 | awk '{print$2}' | cut -d/ -f1);

if [ $distro = 'Ubuntu' ]
then
	echo $distro;
else
	yum update -y;
	echo $IP `hostname` >> /etc/hosts;
	yum install -y https://rdoproject.org/repos/rdo-release.rpm;
	systemctl disable networkmanager;
	systemctl stop networkmanager;		
	echo -e 'net.ifname=0\nbiosdevname=0' >> /etc/default/grub;
	grub2-mkconfig;
	yum install -y openstack-packstack;
	packstack --gen-answer-file /root/answer.txt;
	openstack-status;
fi
