#!/bin/bash
ansibleping=$(ansible all -m ping --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"")

echo "==================PING通的机器================================="
echo "${ansibleping}"|grep SUCCESS|awk -F "|" '{print $1}'




echo "==================PING不通的机器================================="
echo "${ansibleping}"|grep UNREACHABLE|awk -F "|" '{print $1}'

