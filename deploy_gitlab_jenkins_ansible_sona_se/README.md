projectname: deploy_gitlab_jenkins_ansible_sona_se
projectpackagename: deploy_gitlab_jenkins_ansible_sona_se.zip
version: 1.0.0
packages:
    - nginx-1.9.tar.gz


使用说明：

ALLinit.sh  调用ALLinit.sh初始化所有机器
DBinit.sh   调用DBinit.sh初始化DB的机器
WEBinit.sh  调用WEBinit.sh初始化化WEB的机器
Functionmenu.yaml 是所有功能操作的初始菜单入口

sshPING.sh     是用来调用hosts文件测试所有要执行任务主机是否连通

通过各个功能脚本调用对应功能tags来执行后续操作

ansible.cfg个性化配置：
[defaults]
inventory      = ./hosts
sudo_user      = root
remote_port    = 22

roles_path    = ./roles

host_key_checking = False
remote_user = root

log_path = /opt/Ansible/log/ansible.log

[privilege_escalation]

[paramiko_connection]

[ssh_connection]

control_path = ./ssh_keys

[persistent_connection]

connect_timeout = 30

connect_retries = 30

connect_interval = 1

[accelerate]

[selinux]

[colors]

[diff]
