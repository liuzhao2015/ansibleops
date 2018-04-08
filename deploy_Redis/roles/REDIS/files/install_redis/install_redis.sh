#!/bin/sh

cd ./packages
/bin/tar zxf redis-3.0.3.tar.gz
cd redis-3.0.3
make PREFIX=/usr/local/ver01/redis install

/bin/mkdir -p /usr/local/ver01/redis/conf
/bin/mkdir -p /usr/local/ver01/redis/dbdir
/bin/mkdir -p /usr/local/ver01/redis/logs

/bin/cp ../../conf/redis.conf /usr/local/ver01/redis/conf/redis.conf
IP=`/sbin/ifconfig| grep -Po '(?<=addr:)[^ ]+'|grep -E "^10\.|^192\.168|^172\.([1][6-9]|[2][0-9]|[3][01])"`
sed -i "s/# bind 127.0.0.1/bind 127.0.0.1 $IP/g" /usr/local/ver01/redis/conf/redis.conf
/bin/cp ../../scripts/redis /etc/init.d/redis
/bin/chmod +x /etc/init.d/redis

echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
/sbin/sysctl -p


