#!/bin/bash
ansible-playbook -i hosts Functionmenu.yaml  --tags="TENGINX" -vvv  --syntax-check
ansible-playbook -i hosts Functionmenu.yaml  --tags="TENGINX" -v --start-at-task="restup config"
#ansible-playbook -i hosts Functionmenu.yaml  --tags="TENGINX" -v 
 
