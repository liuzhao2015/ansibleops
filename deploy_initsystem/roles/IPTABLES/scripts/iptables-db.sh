#!/bin/bash
IPS=`/sbin/ifconfig| grep -Po '(?<=addr:)[^ ]+'|grep -v "^127"|grep -v "^10\."| grep -v "^192\.168"`
for IP in $IPS
do 
/sbin/iptables -A INPUT -p tcp -d $IP --dport 6379:6480 -j DROP
/sbin/iptables -A INPUT -p tcp -d $IP --dport 26379:26480 -j DROP
done


#===================Ansible=======================================================
#softlayer ansible
/sbin/iptables -A INPUT -s 119.81.140.234/29 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 119.81.140.234/29 -p tcp -m tcp --dport 30000:30010 -j ACCEPT

# AWS 韩国
/sbin/iptables -A INPUT -s 52.79.97.181/29 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 52.79.97.181/29 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
#AWS 美东
/sbin/iptables -A INPUT -s 54.172.51.102/29 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 54.172.51.102/29 -p tcp -m tcp --dport 30000:30010 -j ACCEPT

#===================Ansible=========================================================

#================永新汇三号楼出口ip添加连接sshd 22服务=================================
/sbin/iptables -A INPUT -s 202.104.111.144/29 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 202.104.111.147/32 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 202.104.111.149/32 -p tcp -m tcp --dport 20:22 -j ACCEPT

/sbin/iptables -A INPUT -s 202.104.111.144/29 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
/sbin/iptables -A INPUT -s 202.104.111.147/32 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
/sbin/iptables -A INPUT -s 202.104.111.149/32 -p tcp -m tcp --dport 30000:30010 -j ACCEPT

/sbin/iptables -A INPUT -m iprange --src-range 58.251.36.41-58.251.36.46 -p tcp  --dport 20:22 -j ACCEPT

/sbin/iptables -A INPUT -m iprange --src-range 58.251.36.41-58.251.36.46 -p tcp  --dport 30000:30010 -j ACCEPT

/sbin/iptables -A INPUT -s 210.21.223.224/29 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 210.21.233.227/32 -p tcp -m tcp --dport 20:22 -j ACCEPT

/sbin/iptables -A INPUT -s 210.21.223.224/29 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
/sbin/iptables -A INPUT -s 210.21.233.227/32 -p tcp -m tcp --dport 30000:30010 -j ACCEPT

/sbin/iptables -A INPUT -m iprange --src-range 114.113.243.226-114.113.243.228 -p tcp  --dport 20:22 -j ACCEPT

/sbin/iptables -A INPUT -m iprange --src-range 114.113.243.226-114.113.243.228 -p tcp  --dport 30000:30010 -j ACCEPT

/sbin/iptables -A INPUT -m iprange --src-range 137.59.100.28-137.59.100.30 -p tcp  --dport 20:22 -j ACCEPT

/sbin/iptables -A INPUT -m iprange --src-range 137.59.100.28-137.59.100.30 -p tcp  --dport 30000:30010 -j ACCEPT

/sbin/iptables -A INPUT -s 114.113.243.86/32 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 103.206.188.9/32 -p tcp -m tcp --dport 20:22 -j ACCEPT

/sbin/iptables -A INPUT -s 114.113.243.86/32 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
/sbin/iptables -A INPUT -s 103.206.188.9/32 -p tcp -m tcp --dport 30000:30010 -j ACCEPT

#===============永新汇三号楼出口ip添加连接sshd 22服务==================================

#++++++++++++++++++++++++++softlayer ansible++++++++++++++++++++++++++++++++++++++++++++++++
/sbin/iptables -A INPUT -s 50.23.185.6  -p tcp --dport 22  -j ACCEPT
/sbin/iptables -A INPUT -s 50.23.185.6  -p tcp --dport 30000:30010  -j ACCEPT
#++++++++++++++++++++++++++softlayer ansible++++++++++++++++++++++++++++++++++++++++++++++++
#---------------------跳板机119.81.140.250 169.60.21.200----------------------------------------------
/sbin/iptables -A INPUT -s 119.81.140.250 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 169.60.21.200 -p tcp -m tcp --dport 20:22 -j ACCEPT
/sbin/iptables -A INPUT -s 119.81.140.250 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
/sbin/iptables -A INPUT -s 169.60.21.200 -p tcp -m tcp --dport 30000:30010 -j ACCEPT
#---------------------跳板机119.81.140.250 169.60.21.200----------------------------------------------




/sbin/iptables -A INPUT -s 58.96.180.116  -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 58.251.136.63  -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 52.79.97.181   -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 119.81.140.229   -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 119.81.140.227   -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 58.251.136.61  -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 58.251.136.62  -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 58.251.136.66  -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 218.189.42.174  -p tcp -j ACCEPT
/sbin/iptables -A INPUT -s 120.25.229.51  -p tcp -j ACCEPT



/sbin/iptables -A INPUT -s 184.105.145.251  -p tcp --dport 22  -j ACCEPT
/sbin/iptables -A INPUT -s 114.113.243.86   -p tcp  --dport 3306 -j ACCEPT
/sbin/iptables -A INPUT -s 103.206.188.9   -p tcp --dport 3306 -j ACCEPT

for IP in $IPS
do 
/sbin/iptables -A INPUT -p tcp -d $IP --dport 22 -j DROP
/sbin/iptables -A INPUT -p tcp -d $IP --dport 21 -j DROP
/sbin/iptables -A INPUT -p tcp -d $IP --dport 25 -j DROP
/sbin/iptables -A INPUT -p tcp -d $IP --dport 3306 -j DROP
done

/sbin/iptables-save >  /etc/sysconfig/iptables
