#!/bin/bash
ansible-playbook -i hosts Functionmenu.yaml  --tags=UNINIT -vvv --syntax-check
ansible-playbook -i hosts Functionmenu.yaml  --tags=UNINIT -v   --start-at-task="yum remove  common file"
#ansible-playbook -i hosts Functionmenu.yaml  --tags=UNINIT -v  --list-tags
#ansible-playbook -i hosts Functionmenu.yaml  --tags=UNINIT -v  
 
