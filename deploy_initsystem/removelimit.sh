#!/bin/bash
ansible-playbook -i hosts Functionmenu.yaml  --tags=removeyum -vvv  
#ansible all -m shell -a "grep -E '^\*' /etc/security/limits.conf "
 
