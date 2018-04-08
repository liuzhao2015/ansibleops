#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin


IN_PWD=$(pwd)


function InitInstall()
{
############### install_mysql #################
yum install -y openssl-devel gcc-c++ gcc make perl perl-devel db4-utils postfix dos2unix unzip pcre-devel libtool-devel ncurses-devel vsftpd db4-utils cmake libncurses5-dev freetype bison

##添加用户和用户组
user=mysql
group=mysql
install_dir=/usr/local/ver01/percona

/usr/sbin/groupadd -g 800 $group
/usr/sbin/useradd -g 800 -u 800 -s /bin/false $user
  

##创建安装所需的目录
mkdir -p /data/dbdata/mysqldata
mkdir -p /data/dbdata/mysqldata/tmp
mkdir -p /data/dbdata/mysqllog
mkdir -p /data/dbdata/mysqllog/binlog
mkdir -p /data/dbdata/mysqllog/relay-log
mkdir -p /usr/local/ver01
mkdir -p /usr/local/ver01/percona

cd ./packages
tar -zxf Percona-Server-5.5.33-rel31.1.tar.gz

cd Percona-Server-5.5.33-rel31.1

cmake . -DCMAKE_BUILD_TYPE=Release 	\
        -DCMAKE_INSTALL_PREFIX=/usr/local/ver01/percona  \
        -DMYSQL_USER=mysql	\
        -DDEFAULT_CHARSET=utf8 	\
        -DDEFAULT_COLLATION=utf8_general_ci 	\
        -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock	\
        -DEXTRA_CHARSETS=all	\
        -DENABLED_LOCAL_INFILE=1	\
        -DWITH_READLINE=1	\
        -DWITH_ZLIB=system	\
        -DWITH_SSL=system	\
        -DWITH_INNOBASE_STORAGE_ENGINE=1 	\
        -DWITH_FEDERATED_STORAGE_ENGINE=1 	\
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1 	\
        -DWITH_EXAMPLE_STORAGE_ENGINE=1 	\
        -DWITH_PARTITION_STORAGE_ENGINE=1 	\
        -DWITH_ARCHIVE_STORAGE_ENGINE=1 	\
        -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 	\
        -DWITH_DEBUG=0


if [ $? -ne 0 ];then
	echo "configure filed ,please check it out"
        exit 1
fi

##安装mysql
echo "make mysql, please wait for 20 minutes"

make

if [ $? -ne 0 ];then
        echo "make filed ,please check it out"
        exit 1
fi

make install

if [ $? -eq 0 ];then
        echo "install mysql success!"
fi

cd ..

##修改目录权限
chown -R mysql:mysql $install_dir
chown -R mysql:mysql /data/dbdata/

##设定配置文件
if cat /etc/my.cnf|wc -l ;then
   mv /etc/my.cnf /etc/my_bak.cnf
   /bin/cp $IN_PWD/conf/my5_5.cnf /etc/my.cnf
else
   /bin/cp $IN_PWD/conf/my5_5.cnf /etc/my.cnf
fi
##初始化db
cp /usr/local/ver01/percona/scripts/mysql_install_db /usr/local/ver01/percona/bin/

cd /usr/local/ver01/percona

./bin/mysql_install_db  --defaults-file=/etc/my.cnf  --user="$user"

cp  /usr/local/ver01/percona/support-files/mysql.server  /etc/init.d/mysqld.ver01
echo "/etc/init.d/mysqld.ver01 start" >>/etc/rc.d/rc.local
#echo "export PATH=/usr/local/ver01/percona/bin:\$PATH" >> /etc/profile.d/mysql.sh
echo "export PATH=/usr/local/ver01/percona/bin:\$PATH" >> /etc/profile

source /etc/profile

/etc/init.d/mysqld.ver01 star


if [ $? -ne 0 ];then
	echo "mysql start filed ,please check it out"
else
	echo "mysql start successful,congratulations"
fi

######################Install_openssl-1.0.1g###################
cd $IN_PWD/packages
tar -xvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
./config shared --prefix=/usr/local/ver01/openssl-1.0.1g --openssldir=/usr/local/ver01/openssl-1.0.1g
make && make install
echo "/usr/local/ver01/openssl-1.0.1g/lib" >> /etc/ld.so.conf
ldconfig

######################Install_curl-7.46.0######################
cd $IN_PWD/packages
tar -xvf curl-7.46.0.tar.gz
cd curl-7.46.0
./configure --prefix=/usr/local/ver01/curl --with-ssl PKG_CONFIG_PATH=/usr/local/ver01/openssl-1.0.1g/lib/pkgconfig LDFLAGS=-L/usr/local/ver01/openssl-1.0.1g/lib
make && make install



######################Install_Apache###########################
/usr/sbin/groupadd -g 502 wwwuser
/usr/sbin/useradd -g 502  -u 502 -s /bin/false wwwuser
/usr/sbin/useradd -g 502  -u 503  gbecuser
mkdir  /home/wwwroot
mkdir  /home/wwwroot/default
mkdir  /home/wwwroot/loadbalancers
mkdir  /home/wwwroot/php_error
touch /home/wwwroot/loadbalancers/index.html
chown gbecuser.wwwuser -R  /home/wwwroot
chmod 770 /home/wwwroot/php_error

cd $IN_PWD/packages
tar zxf cronolog-1.6.2.tar.gz
cd  cronolog-1.6.2
./configure
make
make install
cd ..

tar zxf httpd-2.2.17.tar.gz
tar zxf apr-1.4.6.tar.gz
tar zxf apr-util-1.4.1.tar.gz
cd httpd-2.2.17
/bin/cp -R ../apr-1.4.6 ./srclib/apr
/bin/cp -R ../apr-util-1.4.1 ./srclib/apr-util
./configure --prefix=/usr/local/ver01/apache2 --enable-modules=so --enable-rewrite --enable-deflate --enable-dav --enable-dav-fs --enable-dav-lock --enable-ssl --with-ssl=/usr/local/ver01/openssl-1.0.1g
make
make install
/usr/local/ver01/apache2/bin/apxs -i -a -c  modules/metadata/mod_expires.c
/usr/local/ver01/apache2/bin/apachectl start
cp /usr/local/ver01/apache2/bin/apachectl  /etc/rc.d/init.d/httpd.ver01
if [ -d /usr/local/ver01/apache2 ];then
cd ..
else
echo "apache error"
exit
fi

mv /usr/local/ver01/apache2/conf/httpd.conf /usr/local/ver01/apache2/conf/httpd.conf_bak
cd $IN_PWD
/bin/cp ./conf/httpd.conf /usr/local/ver01/apache2/conf/
mv /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf_bak



######################## Install_PHP##########################################
cd ./packages/
tar jxf   libmcrypt-2.5.8.tar.bz2
cd libmcrypt-2.5.8
./configure
make
make install

cd ..
tar jxf mhash-0.9.9.9.tar.bz2
cd  mhash-0.9.9.9
./configure
make
make install

cd ..
echo "/usr/local/lib" >> /etc/ld.so.conf
/sbin/ldconfig
tar zxf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8
./configure --enable-ltdl-install
make
make install
cd ..
 tar zxf freetds-current.gz
cd freetds-0.83.dev.20110314/
./configure \
--prefix=/usr/local/ver01/freetds \
--with-tdsver=8.0 --enable-msdblib \
--enable-dbmfix \
--with-gnu-ld \
--enable-shared \
--enable-static
make
make install
if [ -d /usr/local/ver01/freetds ];then
cd ..
else
echo "freetds-0.83.dev.20110314 error"
exit
fi
##########################################################
echo "install jpeg8"
tar zxf jpegsrc.v8c.tar.gz
cd jpeg-8c
mkdir -p /usr/local/ver01/jpeg8
mkdir -p /usr/local/ver01/jpeg8/bin
mkdir -p /usr/local/ver01/jpeg8/lib
mkdir -p /usr/local/ver01/jpeg8/include
mkdir -p /usr/local/ver01/jpeg8/man
mkdir -p /usr/local/ver01/jpeg8/man1
mkdir -p /usr/local/ver01/jpeg8/man/man1

./configure --prefix=/usr/local/ver01/jpeg8  --enable-shared --enable-static
make
make install

if [ -d /usr/local/ver01/jpeg8 ];then
cd ..
else
echo "jpeg8  error"
exit
fi
#########################################################
unzip ft244.zip
cd freetype-2.4.4
find ./ -name  "*" -exec dos2unix {} \;
./configure --prefix=/usr/local/ver01/freetype
make
make install

if [ -d /usr/local/ver01/freetype ];then
cd ..
else
echo "freetype error ft244.zip"
exit
fi

########################################################
 tar zxf libpng-1.5.1.tar.gz
cd libpng-1.5.1
./configure --prefix=/usr/local/ver01/libpng
make
make install
if [ -d /usr/local/ver01/libpng ];then
cd ..
else
echo "libpng error"
exit
fi
####################################################### 
tar zxf libxml2-2.7.2.tar.gz
cd libxml2-2.7.2
./configure --prefix=/usr/local/ver01/libxml2
make
make install
if [ -d /usr/local/ver01/libxml2 ];then
cd ..
else
echo "libxml2 error"
exit
fi

####################################################### 
 tar zxf zlib-1.2.5.tar.gz
cd zlib-1.2.5
./configure  --prefix=/usr/local/ver01/zlib
make
make install
if [ -d /usr/local/ver01/zlib ];then
cd ..
else
echo " zlib error"
exit
fi


#######################################################
tar zxf libxslt-1.1.22.tar.gz
cd libxslt-1.1.22
  ./configure --prefix=/usr/local/ver01/libxslt --with-libxml-prefix=/usr/local/ver01/libxml2
make
make install
if [ -d /usr/local/ver01/libxslt ];then
cd ..
else
echo " libxslt error"
exit
fi

#####################################################################
tar jxf php-5.6.14.tar.bz2
cd php-5.6.14
  ./configure --prefix=/usr/local/ver01/php6 \
--with-pdo-mysql=/usr/local/ver01/percona \
--with-mysql=/usr/local/ver01/percona  \
--with-apxs2=/usr/local/ver01/apache2/bin/apxs \
--with-zlib-dir=/usr/local/ver01/zlib \
--with-curl=/usr/local/ver01/curl \
--enable-mbstring --with-mcrypt  --enable-soap  --disable-ipv6 --with-gd --enable-bcmath --enable-sockets --enable-zip --with-openssl=/usr/local/ver01/openssl-1.0.1g \
--with-freetype-dir=/usr/local/ver01/freetype \
--with-png-dir=/usr/local/ver01/libpng  \
--with-jpeg-dir=/usr/local/ver01/jpeg8  \
--with-libxml-dir=/usr/local/ver01/libxml2 \
--with-xsl=/usr/local/ver01/libxslt \
--with-mysqli=/usr/local/ver01/percona/bin/mysql_config

make
make install


cd $IN_PWD
/bin/cp ./conf/php.ini /usr/local/ver01/php6/lib/
######################################################################
cd ./packages
tar zxf libevent-2.0.12-stable.tar.gz
cd  libevent-2.0.12-stable
./configure --prefix=/usr/local/ver01/libevent
make
make install
if [ -d /usr/local/ver01/libevent ];then
cd ..
else
echo " libevent error"
exit
fi
#########################################################################
tar zxf memcached-1.4.15.tar.gz
cd memcached-1.4.15
 ./configure --prefix=/usr/local/ver01/memcached  --with-libevent=/usr/local/ver01/libevent
make
make install
if [ -d /usr/local/ver01/memcached ];then
cd ..
else
echo " memcached error"
exit
fi
#########################################################################
tar zxf memcache-2.2.6.tgz
cd memcache-2.2.6
export PHP_PREFIX=/usr/local/ver01/php6
$PHP_PREFIX/bin/phpize
./configure --enable-memcache --with-php-config=$PHP_PREFIX/bin/php-config
make
make install
cd ..
#====================
/usr/local/ver01/memcached/bin/memcached -d -m 512 -l 127.0.0.1 -p 11215 -u root -c 4096
IP=`/sbin/ifconfig| grep -Po '(?<=addr:)[^ ]+'|grep -E "^10\.|^192\.168|^172\.([1][6-9]|[2][0-9]|[3][01])"`
/usr/local/ver01/memcached/bin/memcached -d -m 2048 -l $IP -p 11211 -u root -c 4096

##########################################################################
tar -zxvf nicolasff-phpredis-2.1.3-167-ga5e53f1.tar.gz
cd nicolasff-phpredis-a5e53f1
export PHP_PREFIX=/usr/local/ver01/php6/
$PHP_PREFIX/bin/phpize
./configure --with-php-config=/usr/local/ver01/php6/bin/php-config
make
make install

}
InitInstall 2>&1 | tee /root/lamp_install.log
echo "#################################################"
echo "mysql data:   /data/dbdata/mysqldata"
echo "mysql dir:    /usr/local/ver01/percona"
echo "php dir:      /usr/local/ver01/php6"
echo "web dir:      /home/wwwroot"
echo "apache dir:   /usr/local/ver01/apache2"
echo "memcached dir:   /usr/local/ver01/memcached"
echo "##################################################"
