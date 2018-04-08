#!/bin/bash

a=$(curl -s "http://omd.glosop.com/index.php/Api/get_targetinfo?api_key=globalegrowZ2xvYmFsZWdyb3cK&target_key=name");echo ${a}>1.log;
grep message 1.log;
if [ $? -eq 0 ]
then
   echo ${a}
else
webhostname=$(eval curl -s "http://omd.glosop.com/index.php/Api/get_targetinfo?api_key=globalegrowZ2xvYmFsZWdyb3cK&target_key=name"|awk -F ":" '{print $2}')
sed -i "s/Hostname=NewWebDB/Hostname=${webhostname}/" /usr/local/zabbix/etc/zabbix_agentd.conf
sed -i "s/_0//g" /usr/local/zabbix/etc/zabbix_agentd.conf
fi
rm -f 1.log
