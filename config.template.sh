#!/bin/bash
# justicefriendshipunitykindnessbright_2@protonmail.com


#shadowsocks 配置信息
shadowsocks_s=127.0.0.1
shadowsocks_p=12345
shadowsocks_k="12456"
shadowsocks_m=none
shadowsocks_O=auth_chain_f
shadowsocks_o=plain
shadowsocks_l=1081
shadowsocks_b=0.0.0.0

#应用路径
app_path=/root/centos/app

#shadowsocks程序路径
local_path=${app_path}local/local


#网络配置
parent=ens33
docker_subnet=192.168.1.0/16
docker_gateway=192.168.1.1
docker_network_name=docker_pub
docker_local_ip=192.168.1.251
docker_dns_ip=192.168.1.252
docker_dns_ip_2=192.168.1.253
docker_gost_ip=192.168.1.254


#容器器名字
docker_local_name=docker_local
docker_dns_name=docker_dns
docker_dns_2_name=docker_dns_2
docker_gost_name=docker_gost

#容器路径
docker_local_path=${app_path}/local
docker_dns_path=${app_path}/dns
docker_gost_path=${app_path}/gost

#shell 脚本路径
docker_local_shell_path=${docker_local_path}/local.sh
docker_dns_shell_path=${docker_dns_path}/dns.sh
docker_gost_shell_path=${docker_gost_path}/gost.sh

#dns配置文件
docker_dns_config_path=${docker_dns_path}/config.json

#gost配置文件
docker_gost_mbind=false	#SOCKS5多路复用模式
docker_gost_local_port=1082




#判断SOCKS5多路复用模式
if  $docker_gost_mbind -eq "true" ; then
	docker_gost_mbind=?mbind=true
else
	docker_gost_mbind=""
fi


