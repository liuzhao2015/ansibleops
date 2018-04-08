#!/bin/bash
ansible-playbook -i hosts Functionmenu.yaml  --tags="LAMP" -vvv  --syntax-check
ansible-playbook -i hosts Functionmenu.yaml  --tags="LAMP" -vvv  --list-task
ansible-playbook -i hosts Functionmenu.yaml  --tags="TENGINX" -vvv  --list-task
#ansible-playbook -i hosts Functionmenu.yaml  --tags="LAMP" -vvv  --list-hosts
##ansible-playbook -i hosts Functionmenu.yaml  --tags="LAMP" -v --start-at-task="restup config"
ansible-playbook -i hosts Functionmenu.yaml  --tags="LAMP" -v --start-at-task="start execute shell scripts install lamp." --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"" 
ansible-playbook -i hosts Functionmenu.yaml  --tags="TENGINX" -v --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh""

