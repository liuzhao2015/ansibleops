# 服务器初始化整理

## 一、协作流程

开始==》业务部门申购申请==》罗梦兰申购机器==》机器到位==》罗梦兰录入OMD并发邮件下发机器初始化任务给刘钊【附表单（包括机器公私网ip,root密码，主机名，机器系统版本）】==

==》刘钊编辑配置文件执行系统初始化工程批量初始化===》初始化完成后刘钊发邮件通知赵虹推送账号，罗梦兰录入CMDB===》罗梦兰通知业务部门接受机器===》业务部门接受机器==结束

## 二、脚本说明

配置scpinitDB.sh |sspinitDB.sh要初始化的机器IP

- 分发文件

```
/bin/bash -x /root/scpinitDB.sh "/root/sys_init.zip /root/db_fio-test.zip /root/startinitDB.sh"
```

- 执行初始化

```
/bin/bash -x /root/sspinitDB.sh "cd /root/;/bin/bash -x startinitDB.sh>>/root/startinitDB_$(date "+%Y_%m_%d").log;"
```


- 清理部署文件

```
/bin/bash -x /root/sspinitDB.sh "rm -rf /root/*;"
```


- 刷防火墙

```
/bin/bash -x /root/sspinitDB.sh "cd /root/;/bin/bash/ -x iptables_db.sh;"
```


## 三、初始化操作说明

### system_init.sh 

- 1.添加跳板机用户并给用户加sudo

- 2.安全加固ssh

- 3.命令历史设置

- 4.内核优化

- 5.设置VIM

- 6.设置命令历史格式

- 7.安装CMDB客户端进行CMDB注册纳管

- 8.安装zabbix客户端接入监控

- 9。安装基础组件


### db_fio-test

- 10.安装性能优化工具，对IO性能进行测试

### iptables-db.sh

- 11.刷防火墙规则