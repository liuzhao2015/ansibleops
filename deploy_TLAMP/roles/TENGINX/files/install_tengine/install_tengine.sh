#!/bin/bash
yum -y install openssl-devel openssl gcc c++
useradd -s /sbin/nologin --uid 504 www
INTENGINE_PWD=$(pwd)
cd packages/
tar -zxvf ngx_cache_purge-2.1.tar.gz  
tar -zxvf pcre-8.13.tar.gz 
tar -zxvf zlib-1.2.3.tar.gz
tar -zxvf ngx_http_redis-0.3.8.tar.gz
tar -zxvf LuaJIT-2.0.0.tar.gz
cd LuaJIT-2.0.0
make
make install
(
cat <<EOF
export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
EOF
)>>/etc/profile
source /etc/profile 
cd ../
tar -zxvf v0.9.5rc2.tar.gz
unzip master.zip
tar -zxvf v0.2.19.tar.gz
tar -zxvf tengine-2.1.2.tar.gz
cd tengine-2.1.2
./configure --user=www --group=www --add-module=../ngx_cache_purge-2.1 --prefix=/usr/local/ver01/tengine --with-http_stub_status_module  --with-zlib=../zlib-1.2.3 --with-pcre=../pcre-8.13 --with-http_stub_status_module --with-http_realip_module --add-module=../ngx_http_redis-0.3.8  --add-module=../ngx_devel_kit-0.2.19 --add-module=../lua-nginx-module-0.9.5rc2  --with-http_secure_link_module --http-client-body-temp-path=/usr/local/ver01/tengine/tmp/client_body
make
make install
ln -s /usr/local/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2

mkdir /usr/local/ver01/tengine/conf/vhost
mkdir -p /usr/local/ver01/tengine/tmp/client_body
mv /usr/local/ver01/tengine/conf/nginx.conf /usr/local/ver01/tengine/conf/nginx.conf_bk
cd $INTENGINE_PWD
cp ./conf/nginx.conf /usr/local/ver01/tengine/conf/
cp ./conf/server.conf /usr/local/ver01/tengine/conf/vhost/
#==============================config============================================
/usr/local/ver01/tengine/sbin/nginx

if [ $? -ne 0 ];then
	echo "Nginx start filed ,please check it out"
else
	echo "Nginx start successful,congratulations"
fi


