#!/bin/bash
ansible all -m ping
#ansible windows -m win_ping
#ansible check -m ping --extra-vars="ansible_ssh_user="zeusadmin" ansible_ssh_pass="hH3S2kxVNU4sbCfh"" 
