#!/bin/bash
# justicefriendshipunitykindnessbright@protonmail.com



#初始化文件

#关闭selinux
setenforce 0
#安装docker
bash install_docker.sh
#创建网络
#bash docker_network_create.sh
. docker_function.sh
docker_network_create
#启动容器
bash docker_service.sh create
