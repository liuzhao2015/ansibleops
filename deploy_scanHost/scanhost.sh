#!/bin/bash
dt=$(date +%Y_%m_%d)
echo ${dt}
ansible-playbook -i hosts Functionmenu.yaml  --tags=scanhost -vvv --syntax-check
ansible-playbook -i hosts Functionmenu.yaml  --tags=scanhost -v   --list-tasks
ansible all -m ping --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh""

#ansible-playbook -vv -i hosts Functionmenu.yaml  --tags="scanhost"  --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"" 


 
