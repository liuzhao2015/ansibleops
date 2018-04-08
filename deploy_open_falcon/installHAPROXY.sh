#!/bin/bash
dt=$(date +%Y_%m_%d)
ansible-playbook -i hosts Functionmenu.yaml  --tags="HAPROXY" -vvv  --syntax-check
ansible-playbook -i hosts Functionmenu.yaml  --tags="HAPROXY" -vvv  --list-task
ansible-playbook -i hosts Functionmenu.yaml  --tags="HAPROXY" -vvv  --list-hosts
##ansible-playbook -i hosts Functionmenu.yaml  --tags="HAPROXY" -v --start-at-task="restup config"
ansible-playbook -i hosts Functionmenu.yaml  --tags="HAPROXY" -vv \
 --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh""
 
