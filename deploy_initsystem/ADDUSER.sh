#!/bin/bash
dt=$(date +%Y_%m_%d)
newusername=xiezuofu
newpasswd=wes1r4fa
ansible-playbook -v -i hosts Functionmenu.yaml  --tags="adduser"  --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh" zend_user="${newusername}" zend_password="${newpasswd}" " 
ansible WEB -m shell -a "who" --extra-vars="ansible_ssh_user="${newusername}" ansible_ssh_pass="${newpasswd}""

echo "用户名：${newusername}"
echo "密码：${newpasswd}"
 
