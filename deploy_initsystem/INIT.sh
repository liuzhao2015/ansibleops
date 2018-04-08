#!/bin/bash
dt=$(date +%Y_%m_%d)
echo ${dt}
ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT1 -vvv --syntax-check
ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT1 -v   --list-tasks
#ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT -v  --list-tags
ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT1 -vv --start-at-task="set limits.conf"
#ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT1 -vv 
ansible-playbook -vv -i hosts Functionmenu.yaml  --tags="IPTABLES"  --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"" 
#ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT1 -vv && ansible-playbook -i hosts Functionmenu.yaml  --tags=IPTABLES -vv


#>./logs/INIT-${dt}.log
 
