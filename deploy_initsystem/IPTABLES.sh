#!/bin/bash
dt=$(date +%Y_%m_%d)
#ansible-playbook -v -i hosts Functionmenu.yaml  --tags="IPTABLES"  --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"" 
ansible-playbook -v -i hosts Functionmenu.yaml  --tags="confignewiptables"  --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"" 
#--start-at-task="restart zabbix_agentd">>./logs/IPTABLES-${dt}.log

 
