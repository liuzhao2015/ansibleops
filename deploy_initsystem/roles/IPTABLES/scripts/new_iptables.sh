#!/bin/bash
/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 5672 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 25672 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 15672 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 4369 -j ACCEPT
service iptables save
service iptables restart
