#!/bin/bash
yum install pcre-devel openssl-devel–y 
useradd -s /sbin/nologin -M haproxy
#wget http://software.intra.gomeplus.com/haproxy-1.5.8.tar.gz
tar zxvf haproxy-1.5.8.tar.gz 
cd haproxy-1.5.8
make TARGET=linux26 USE_OPENSSL=1 ADDLIB=-lz  
ldd haproxy | grep ssl                                      
#libssl.so.10 => /usr/lib64/libssl.so.10 (0x00007fb0485e5000) 
make install PREFIX=/usr/local/haproxy
cd ..

cd /usr/local/haproxy

vi /usr/local/haproxy/haproxy.cfg（配置文件内容在下方） 
    
/usr/local/haproxy/sbin/haproxy -f /usr/local/haproxy/haproxy.cfg -D

ps -ef|grep haproxy    
29477 ?        00:00:00 haproxy




haproxy.cfg配置文件

global
 maxconn 20000 #每个进程可用的最大连接数
 chroot /usr/local/haproxy	#改变当前工作目录
 user haproxy	#工作用户
 group haproxy	#工作组
 daemon	#运行方式为后台工作
 quiet	#安装模式，启动时无输出
 nbproc  8 #创建工作的进程数目
 pidfile /usr/local/haproxy/haproxy.pid	#pid文件位置
 debug	#调试模式，输出启动信息到标准输出
defaults
 retries 2	#当对server的connection失败后，重试的次数
 maxconn 20000	#最大连接数
 contimeout      5000	#连接超时
 clitimeout      50000	#客户端超时
 srvtimeout      50000	#服务器超时
frontend https_frontend
   bind *:80
   mode http	#http的7层模式
   option httpclose	#每次请求完毕后主动关闭http通道，HA-Proxy不支持keep-alive模式
   option forwardfor	##获得客户端IP
   reqadd X-Forwarded-Proto:\ https
   default_backend web_server
backend web_server
   mode http	#http的7层模式
   balance roundrobin	#负载均衡的方式，roundrobin平均方式
   cookie SERVERID insert indirect nocache	#允许插入serverid到cookie中 ，会话保持	#健康检查
   server s1 10.125.4.183:443 check cookie s1
   server s2 10.125.4.184:443 check cookie s2
