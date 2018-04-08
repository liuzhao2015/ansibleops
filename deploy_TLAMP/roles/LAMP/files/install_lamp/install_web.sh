#!/bin/bash
usage()
{
        echo "Usage:`basename $0` www|m|app domain"
        exit 1
}

www()
{
DOMAIN=$1
/bin/cp ./conf/httpd-vhosts.conf /usr/local/ver01/apache2/conf/extra/
sed -i "s/abc.com/$DOMAIN/g" /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf
/bin/mkdir /home/wwwroot/www.$DOMAIN
/bin/chown gbecuser:wwwuser /home/wwwroot/www.$DOMAIN
}

m()
{
DOMAIN=$1
/bin/cp ./conf/mhttpd-vhosts.conf /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf
sed -i "s/abc.com/$DOMAIN/g" /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf
/bin/mkdir /home/wwwroot/m.$DOMAIN
/bin/chown gbecuser:wwwuser /home/wwwroot/m.$DOMAIN
}

app()
{
DOMAIN=$1
/bin/cp ./conf/apphttpd-vhosts.conf /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf
sed -i "s/abc.com/$DOMAIN/g" /usr/local/ver01/apache2/conf/extra/httpd-vhosts.conf
/bin/mkdir /home/wwwroot/app.$DOMAIN
/bin/chown gbecuser:wwwuser /home/wwwroot/app.$DOMAIN
}

 
if [ $# -eq 0 ];then
      usage
else
      $1 $2
fi
