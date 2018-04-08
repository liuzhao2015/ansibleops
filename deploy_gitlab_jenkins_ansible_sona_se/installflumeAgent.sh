#!/bin/bash
pam=${1}
case ${parm} in
	GITLAB)
		ansible-playbook -i hosts Functionmenu.yaml  --tags="GITLAB" -vv
;;
	JENKINS)
		ansible-playbook -i hosts Functionmenu.yaml  --tags="JENKINS" -vv
;;
	ANSIBLE)
		ansible-playbook -i hosts Functionmenu.yaml  --tags="ANSIBLE" -vv
;;
	SONARQUBE)
		ansible-playbook -i hosts Functionmenu.yaml  --tags="SONARQUBE" -vv
;;
	SELENIUM)
		ansible-playbook -i hosts Functionmenu.yaml  --tags="SELENIUM" -vv
;;
	ALL)
		ansible-playbook -i hosts Functionmenu.yaml  --tags="GITLAB,JENKINS,ANSIBLE,SONARQUBE,SELENIUM" -vv
;;
	*)
		echo "您输入有误，请确认需要安装哪些组件GITLAB,JENKINS,ANSIBLE,SONARQUBE,SELENIUM或者所有ALL"
;;
esac 