#!/bin/bash
#author:liuzhao
#date:2017/09/05
#study_url:http://www.sphinxsearch.org/sphinx-tutorial

sphinx_version=2.2.11
sphinx_tarurl=http://sphinxsearch.com/files/sphinx-${sphinx_version}-release.tar.gz
deploy_home=/data
user=sphinx
usergroup=sphinx
execute_home=/usr/local

function installPre(){

if [ ! -f sphinx-${sphinx_version}-release.tar.gz ]
then
	wget ${sphinx_tarurl}
fi

tar -zxvf sphinx-${sphinx_version}-release.tar.gz

cd sphinx-${sphinx_version}-release


}


function installDependes(){
#sudo yum -y install gcc gcc-c++ make mysql-devel
sudo yum -y install gcc gcc-c++ make 
}


function installSphinx(){

./configure --prefix=${deploy_home}/sphinx${sphinx_version} --with-mysql  --enable-id64  #注意：这里sphinx已经默认支持了mysql

make -j 4 &&sudo  make install # 其中的“警告”可以忽略

sudo chown ${user}:${usergroup} -R ${deploy_home}/sphinx${sphinx_version}

sudo ln -s ${deploy_home}/sphinx${sphinx_version}  ${execute_home}/sphinx${sphinx_version}

 ${execute_home}/sphinx${sphinx_version}/bin/searchd  --status

}

function   checkoutSVNconfig(){
if [  -d ${execute_home}/sphinx${sphinx_version} ]
then
chown ${user}:${usergroup} -R ${execute_home}/sphinx${sphinx_version}/.svn
cd  ${execute_home}/sphinx${sphinx_version}
rm -rf ${execute_home}/sphinx${sphinx_version}/etc
su - sphinx -c "svn checkout http://svn.egomsl.com/svn/repos/config/sphinx/test/etc"

su - sphinx -c "svn up ${execute_home}/sphinx${sphinx_version}/etc/  >/tmp/sphinx${sphinx_version}etc.out 2>&1"
chown ${user}:${usergroup} -R ${execute_home}/sphinx${sphinx_version}


fi

}


function createIndex(){
#${execute_home}/sphinx${sphinx_version}/bin/searchd -C ${execute_home}/sphinx${sphinx_version}/conf/sphinx.conf &


pwd

}


function startService(){
su - sphinx -c "${execute_home}/sphinx${sphinx_version}/bin/searchd -C ${execute_home}/sphinx${sphinx_version}/conf/new_chinabrands-2.2.11.conf &"



}




function main(){

	installDependes
	installPre
	installSphinx
    checkoutSVNconfig
    startService

}

main

