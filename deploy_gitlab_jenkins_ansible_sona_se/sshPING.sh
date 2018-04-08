#!/bin/bash
ansible all -m ping  --extra-vars="ansible_ssh_user="ansibleops" ansible_ssh_pass="ansibleops"" 
