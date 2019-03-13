#!/bin/bash
# justicefriendshipunitykindnessbright_2@protonmail.com


#安装docker脚本

. config.sh
#增强加密协议兼容性
yum install -y epel-release
yum install -y libsodium

kill -9 `cat pid_local`

`nohup $local_path \
-s $shadowsocks_s \
-p $shadowsocks_p \
-k $shadowsocks_k \
-m $shadowsocks_m \
-O $shadowsocks_O \
-o $shadowsocks_o \
-l $shadowsocks_l \
-b $shadowsocks_b \
-vv >> local.log  2>&1 & echo $! > pid_local`

#"$!" > pid_local
export all_proxy=socks5://127.0.0.1:${shadowsocks_l}
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm -f get-docker.sh
service docker start
kill -9 `cat pid_local`
rm -f nohup.out
rm -f pid_local

#打开路由转发，必须主机打开容器才会打开，只支持linux
echo "1" > /proc/sys/net/ipv4/ip_forward
net.ipv4.ip_forward = 1 >> sysctl.conf

sysctl -p


