#!/bin/bash
# justicefriendshipunitykindnessbright_2@protonmail.com


function gensh_local(){

sh=$(cat >sh.txt <<EOF
#!/bin/bash
yum -y install epel-release
yum -y install libsodium
nohup /root/local/local \
-s $shadowsocks_s \
-p $shadowsocks_p \
-k $shadowsocks_k \
-m $shadowsocks_m \
-O $shadowsocks_O \
-o $shadowsocks_o \
-l $shadowsocks_l \
-b $shadowsocks_b \
-vv >> /root/local/local.log \
" 2>&1 &"
EOF

rm -f $docker_local_shell_path
chmod +x sh.txt
mv sh.txt $docker_local_shell_path
)

}



function docker_run_local(){
        docker run -itd --network=${docker_network_name} \
         --ip=${docker_local_ip} \
         --name=${docker_local_name} \
         --hostname=${docker_local_name} \
         -v=${docker_local_path}:/root/local \
         centos \
        /root/local/local.sh

}



function docker_run_dns(){

        docker run -itd --network=${docker_network_name} \
         --ip=${docker_dns_ip} \
         --name=${docker_dns_name} \
         --hostname=${docker_dns_name} \
         -v=${docker_dns_path}:/root/dns \
         centos \
        /root/dns/dns.sh

        docker run -itd --network=${docker_network_name} \
         --ip=${docker_dns_ip_2} \
         --name=${docker_dns_2_name} \
         --hostname=${docker_dns_2_name} \
         -v=${docker_dns_path}:/root/dns \
         centos \
        /root/dns/dns.sh

}



function gensh_dns(){

sh=$(cat >config.json <<EOF
{
  "BindAddress": ":53",
  "DebugHTTPAddress": "127.0.0.1:5555",
  "PrimaryDNS": [
    {
      "Name": "googlePublic",
      "Address": "8.8.8.8:53",
      "Protocol": "udp",
      "SOCKS5Address": "${docker_local_ip}:${shadowsocks_l}",
      "Timeout": 6,
      "EDNSClientSubnet": {
        "Policy": "disable",
        "ExternalIP": "",
        "NoCookie": true
      }
    }
  ],
  "AlternativeDNS": [
    {
      "Name": "OpenDNS",
      "Address": "208.67.222.222:443",
      "Protocol": "tcp",
      "SOCKS5Address": "${docker_local_ip}:${shadowsocks_l}",
      "Timeout": 6,
      "EDNSClientSubnet": {
        "Policy": "disable",
        "ExternalIP": "",
        "NoCookie": true
      }
    }
  ],
  "OnlyPrimaryDNS": false,
  "IPv6UseAlternativeDNS": false,
  "IPNetworkFile": {
    "Primary": "./ip_network_primary_sample",
    "Alternative": "./ip_network_alternative_sample"
  },
  "DomainFile": {
    "Primary": "./domain_primary_sample",
    "Alternative": "./domain_alternative_sample"
  },
  "HostsFile": "./hosts_sample",
  "MinimumTTL": 0,
  "CacheSize" : 0,
  "RejectQtype": [255]
}

EOF

rm -f $docker_dns_config_path
mv config.json $docker_dns_config_path
)

}




function docker_run_gost(){
        docker run -itd --network=${docker_network_name} \
         --ip=${docker_gost_ip} \
         --name=${docker_gost_name} \
         --hostname=${docker_gost_name} \
         -v=${docker_gost_path}:/root/gost \
         --privileged \
         centos \
        /root/gost/gost.sh
}


function gensh_gost(){

sh=$(cat >sh.txt <<EOF
#!/bin/sh
yum -y install iproute

iptables -t nat -N V2RAY # 新建一个名为 V2RAY 的链
iptables -t nat -A V2RAY -d 192.168.0.0/16 -j RETURN # 直连 192.168.0.0/16
iptables -t nat -A V2RAY -p tcp -j RETURN -m mark --mark 0xff # 直连 SO_MARK 为 0xff 的流量(0xff 是 16 >进制数，数值上等同与上面配置的 255)，此规则目的是避免代理本机(网关)流量出现回环问题
iptables -t nat -A V2RAY -p tcp -j REDIRECT --to-ports ${docker_gost_local_port} # 其余流量转发到 ${docker_gost_local_port} 端口（即 V2Ray）
iptables -t nat -A PREROUTING -p tcp -j V2RAY # 对局域网其他设备进行透明代理
iptables -t nat -A OUTPUT -p tcp -j V2RAY # 对本机进行透明代理

ip rule add fwmark 1 table 100
ip route add local 0.0.0.0/0 dev lo table 100
iptables -t mangle -N V2RAY_MASK
iptables -t mangle -A V2RAY_MASK -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A V2RAY_MASK -p udp -j TPROXY --on-port ${docker_gost_local_port} --tproxy-mark 1
iptables -t mangle -A PREROUTING -p udp -j V2RAY_MASK

/root/gost/gost -L=redirect://:${docker_gost_local_port}?dns=8.8.8.8,8.8.4.4:53/udp -F=socks5://${docker_local_ip}:${shadowsocks_l}${docker_gost_mbind}

EOF


rm -f $docker_gost_shell_path
chmod +x sh.txt
mv sh.txt $docker_gost_shell_path
)

}



#创建网络
function docker_network_create(){
	docker network create -d macvlan \
	--subnet=${docker_subnet} \
	--gateway=${docker_gateway} \
	-o parent=${parent} ${docker_network_name}
}
