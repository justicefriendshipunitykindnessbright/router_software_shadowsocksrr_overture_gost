#!/bin/bash
# justicefriendshipunitykindnessbright@protonmail.com


#主程序

#重启
function docker_restart(){
	. config.sh
	. docker_function.sh

	service docker start

	#重建配置文件
	gensh_local
	gensh_dns
	gensh_gost

	#重启
	docker restart ${docker_local_name} ${docker_dns_name} ${docker_dns_2_name} ${docker_gost_name}
}

#启动
function docker_start(){
	. config.sh
	. docker_function.sh
	service docker start

	gensh_local
	gensh_dns
	gensh_gost

	docker start ${docker_local_name} ${docker_dns_name} ${docker_dns_2_name} ${docker_gost_name}
}

#停止服务
function docker_stop(){
	. config.sh
	service docker start
	docker stop ${docker_local_name} ${docker_dns_name} ${docker_dns_2_name} ${docker_gost_name}
}

#删除
function docker_rm(){
	. config.sh
	service docker start
	#停止服务并删除虚拟机
	docker stop ${docker_local_name} ${docker_dns_name} ${docker_dns_2_name} ${docker_gost_name}
	docker rm ${docker_local_name} ${docker_dns_name} ${docker_dns_2_name} ${docker_gost_name}
}

#创建
function docker_create(){
	service docker start
	. config.sh
	. docker_function.sh

	#创建脚本，并启动虚拟机
	gensh_local
	docker_run_local
	gensh_dns
	docker_run_dns
	gensh_gost
	docker_run_gost

}





#服务
if [ $1 == "start" ] ; then
	docker_start
	echo "start"
elif [ $1 == "stop" ] ; then
	docker_stop
	echo "stop"
elif [ $1 == "restart" ] ; then
	docker_restart
	echo "restart"
elif [ $1 == "rm" ] ; then
	echo "rm"
	echo "rm"
	docker_rm
	echo "rm"
elif [ $1 == "create" ] ; then
	docker_create
	echo "create"
else
	echo "参数可以是(start|stop|restart|rm|create)之一"
fi
