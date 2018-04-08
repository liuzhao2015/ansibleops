#!/bin/bash
#ansible-playbook -i hosts Functionmenu.yaml  --tags=check -v --syntax-check
#ansible-playbook -i hosts Functionmenu.yaml  --tags=check -v   --list-tasks
#ansible-playbook -i hosts Functionmenu.yaml  --tags=INIT -v  --list-tags
#ansible-playbook -i hosts Functionmenu.yaml  --tags=check -v --start-at-task="start execute shell scripts check machines"
ansible-playbook -i hosts Functionmenu.yaml  --tags=check -v   --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh""
#ansible-playbook -i hosts Functionmenu.yaml  --tags=checkmachines -vvvv   --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh""
 
