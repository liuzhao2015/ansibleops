#!/bin/bash
source /etc/profile>/dev/null
pid=$(ps -ef|grep falcon|grep -v 'grep'|awk -F " " '{print $2}')
if [ -n "${pid}" ]
then
	 kill -9 ${pid}
else 
	/usr/local/monitor/open-falcon/agent/control start
fi
