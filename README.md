# 项目介绍
这是一个shadowsocksRR透明代理软路由的脚本,可以避免传统socks5代理被利用webIRC漏洞泄露ip地址  
这个项目使用了docker整合了shadowsocksRR，overture,gost这三个软件架设软路由，实现透明代理上网，透明代理之后可以多路复用socks5  
它在使用vmware虚拟化，安装centos7-mini的环境下，安装docker并设置透明代理  
由于透明代理必须在linux上运行,所以安装centos7,其它linux操作系统不保证完全兼容  
由于脚本单独设置代理，dns，透明转发可能会导致环境复杂，无法检查问题,而单个应用，采用docker隔离开来,可以进一步缩小检查问题的范围  
建议备份本项目，以防止作者被抓或者其它不可坑力导致的软件被删除  



### 硬件要求
1.至少双核心处理器  
2.至少2GB内存  
3.CPU要支持虚拟化  
4.可用硬盘容量大于20G  
5.非认证网络，不可在需要授权上网的环境中使用，适用于家用路由器  

### 软件要求
1.安装vmware虚拟机，其它虚拟化方式未测试,理论上只要能装linux的虚拟化方式均支持  
2.设置网络为桥接物理网卡，这是必须的要求  
3.安装centos7-mini操作系统，其它操作系统未测试，理论上只要有sh的操作系统均支持  
4.安装操作系统时需要加密硬盘，防止被网警搬走，查出违法软件，只要查不出来，并且”忘记“密码就缺少违法的证据  

### 首次使用
复制config.template.sh文件到config.sh  
cp config.template.sh config.sh  

并修改config.sh配置文件
1.修改shadowsocks_开头配置信息为shadowsocks的配置信息  
2.修改parent为ip a查出来的网卡名字  
3.修改网络配置,修改网段为路由器dhcp的网段，设置local dns dns_2 gost的ip地址，如果和已经知ip不重复可不设置  

### 初始化
bash start.sh  

### 虚拟机重启，启动服务
bash docker_service.sh start  

### 密码，ip变更
更新config.sh里的密码，或者更config.sh里的局域网ip，并运行重启命令  
bash docker_service.sh restart  


### 客户机设置
建议单独创建虚拟机，并加密磁盘，使用软路由翻墙  
首先获取dhcp的ip地址，再设置成固定ipv4  
ip，子网掩码不变  
设置网关为docker_gost_ip  
设置dns为docker_dns_ip  
备用dns为docker_dns_2_ip，即可通过软路由上网  
请勿必卸载ipv6组件，由于没有代理ipv6，打开ipv6 dhcp仍然会导致ip泄漏  


###感谢
https://github.com/shadowsocks/shadowsocks  
https://github.com/shadowsocksrr/shadowsocksr  
https://github.com/ginuerzh/gost  
https://github.com/shawn1m/overture  
https://www.netfilter.org/  
https://github.com/v2ray/v2ray-core  
https://www.centos.org/  
https://www.gnu.org/software/bash/  
https://www.json.org/  
https://github.com/docker  





