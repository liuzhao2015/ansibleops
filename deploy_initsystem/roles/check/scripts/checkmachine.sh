#!/bin/bash

function initchecktools(){
#yumrest=$(yum list sg3_utils|grep Packages|awk -F " " '{print $1}')

#if [ "X${yumrest}" == "XInstalled"   ]
#then
#  echo "$(date +%Y-%m-%d)|check HARDDISK tool sg3_utils already installd!">>../logs/check$(date +%Y-%m-%d).log
#else
#  echo "#######################Now start check machine==================================="
#  echo "$(date +%Y-%m-%d)|check HARDDISK tool sg3_utils Not install,Now start install">>../logs/check$(date +%Y-%m-%d).log
  yum -y install sg3_utils lsscsi redhat-lsb  dmidecode hdparm smartmontools>/dev/null
#  sleep 3
#fi

}

function uninstalltools(){

if [ "X${yumrest}" == "XAvailable"   ]
then
  echo "$(date +%Y-%m-%d)|check HARDDISK tool sg3_utils already uninstalld!">>../logs/check$(date +%Y-%m-%d).log
else
  yum remove sg3_utils>/dev/null
fi


}


function checkHardware(){

biosvendor=$(dmidecode -s bios-vendor)
biosversion=$(dmidecode -s bios-version)
biosreleasedate=$(dmidecode -s bios-release-date)

systemmanufacturer=$(dmidecode -s system-manufacturer)
systemproductname=$(dmidecode -s system-product-name)
systemversion=$(dmidecode -s system-version)
systemserialnumber=$(dmidecode -s system-serial-number)
systemuuid=$(dmidecode -s system-uuid)

baseboardmanufacturer=$(dmidecode -s baseboard-manufacturer)
baseboardproductname=$(dmidecode -s baseboard-product-name)
baseboardversion=$(dmidecode -s baseboard-version)
baseboardserialnumber=$(dmidecode -s baseboard-serial-number)
baseboardassettag=$(dmidecode -s baseboard-asset-tag)

chassismanufacturer=$(dmidecode -s chassis-manufacturer)
chassistype=$(dmidecode -s chassis-type)
chassisversion=$(dmidecode -s chassis-version)
chassisserialnumber=$(dmidecode -s chassis-serial-number)
chassisassettag=$(dmidecode -s chassis-asset-tag)

processormanufacturer=$(dmidecode -s processor-manufacturer|head -n 1)
processorversion=$(dmidecode -s processor-version|head -n 1)
processorfamily=$(dmidecode -s processor-family|head -n 1)
processorfrequency=$(dmidecode -s processor-frequency|head -n 1)
cpuconts=$(cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l)
cpucores=$(cat /proc/cpuinfo |grep "processor"|wc -l)
bitsupport=$(grep 'lm' /proc/cpuinfo |wc -l) 
if [ ${bitsupport} -gt 0 ]; 
then lm=64 
else lm=32 
fi

sibling=$( cat /proc/cpuinfo |grep "sibling"|uniq|awk -F ":" '{print $2}'
)
if [ ${sibling} -eq ${cpucores} ]
then
     hyperthread="Support Hyper threading"
else
    hyperthread="Don't support Hyper threading"    
fi



memmanufacturer=$(dmidecode -t memory |grep Manufacturer|grep -v Dimm|uniq|awk -F ":" '{print $2}')
memtype=$(dmidecode -t memory |grep '^[[:space:]]*Type'|grep -v "Synchronous\|Other\|Unknown\|Registered"|uniq|awk -F ":" '{print $2}')
memcounts=$(dmidecode -t memory |grep '^[[:space:]]*Size'|grep  'MB'|awk -F ":" '{print $2}'|wc -l)
memsize=$(dmidecode -t memory |grep '^[[:space:]]*Size'|grep  'MB'|awk -F ":" '{print $2}')
memsizenum=$(dmidecode -t memory |grep '^[[:space:]]*Size'|grep  'MB'|awk -F ":" '{print $2}'|awk -F " " '{print $1}')

a=$(dmidecode -t memory |grep '^[[:space:]]*Size'|grep  'MB'|awk -F ":" '{print $2}'|awk -F " " '{print $1}')
OLD_IFS="$IFS" 
IFS="," 
arr=($a) 
IFS="$OLD_IFS" 

memtotlesizenum=0
for s in ${arr[@]} 
do   
  memtotlesizenum=$(expr ${s} + ${memtotlesizenum})   
done

memtotlesize=$((${memtotlesizenum}/1024))
memspeed=$(dmidecode -t memory |grep '^[[:space:]]*Speed'|grep -v "Unknown"|uniq|awk -F ":" '{print $2}')

netcardmanufacturer=$(lspci|grep  Ethernet|awk -F ":" '{print $3}'|uniq)

netcardspeed=()
netface=$(ifconfig|awk -F "      " '{print $1}'|awk -F ":" '{print $1}');
j=0
for i in ${netface[@]}; 
do 
netcardspeed[${j}]=$(ethtool ${i}|grep Speed|awk -F ":" '{print $2}'); 
j=$((${j}+1));
done;

netcardinfo=$(ip addr show|grep  "^[0-9]\|inet\|link"|grep -v 'inet6')

disknumstr=$(fdisk -l|grep '^Disk'|awk -F " "  '{print $2}');
disknum=${disknumstr%%:*};
for i in ${disknum[@]};
do
         diskmode=$(hdparm -i /dev/sda|grep 'Model'|awk -F "," '{print $1}'|awk -F "=" '{print $2}')
         diskdismode=$(echo "${i}|${diskmode}")
         disksize=$(fdisk -l|grep "Disk ${i}:"|awk -F "," '{print $1}'|awk -F ":" '{print $2}')
         diskdisize=$(echo "${i}:${disksize}")
         diskserialNo=$(hdparm -i ${i}|grep SerialNo|awk -F "," '{print $3}'|awk -F "=" '{print $2}')
         diskmanufacturer=$(smartctl --all ${i}|grep "Model Family:"|awk -F ":" '{print $2}')
         disdiskmanufacturer=$(echo "${i}|${diskmanufacturer}")
         diskserialnumber=$(smartctl --all ${i}|grep "Serial Number:"|awk -F ":" '{print $2}')
         disdiskserialnumber=$(echo "${i}|${diskserialnumber}")
         lsscsi |grep ${i}|awk -F " " '{print $5}'|grep ssd>/dev/null
         if [ $? == 0 ]
	then
	   SSD=$(echo "${i}是SSD盘")
	else
	   SSD=$(echo "${i}不是SSD盘")
	fi
        hardtype=$(lsscsi |grep /dev/sda|awk -F " " '{print $3}')
        dishardtype=$(echo "${i}是${hardtype}")                  
        diskserialnumber=$(smartctl --all ${i}|grep "Start_Stop_Count"|awk -F " " '{print $10}')
        if [ ${diskserialnumber} -gt 20 ]
        then
	   newdiskinfo="通电次数大于20，旧盘"
       else
           newdiskinfo="通电次数小于20，新盘"
      fi
	diskspeed=$(sg_vpd ${i} --page=0xb1|grep 'Nominal rotation rate'|awk -F ":" '{print $2}')
        diskspeeddis=$(echo "${i}|${diskspeed}")

done

eth0ip1=$(ifconfig|grep "inet addr"|head -n 1|awk -F " " '{print $2}'|awk -F ":" '{print $2}')
eth0ip2=$(ifconfig|grep "inet"|head -n 1|awk -F " " '{print $2}')
if [ -n "${eth0ip1}" ]
then
	eth0Ip=${eth0ip1}
else
	eth0Ip=${eth0ip2}
fi



echo -e "###########################BIOS信息#####################################################"
echo "BIOS厂商: ${biosvendor}"
echo "BIOS发布日期: ${biosreleasedate} "
echo "BIOS版本: ${biosversion} "
echo -e "\n\n"
#
echo "###########################服务器管理系统信息#####################################################"
echo "服务器管理系统厂商: ${systemmanufacturer} "
echo "服务器管理系统名称: ${systemproductname}"
echo "服务器管理系统版本: ${systemversion}"
echo "服务器管理系统序列号: ${systemserialnumber} "
echo "服务器管理系统uuid: ${systemuuid}"
echo -e "\n\n"
#
echo "###########################主板信息#####################################################"
echo "主板厂商: ${baseboardmanufacturer} "
echo "主板产品名称: ${baseboardproductname} "
echo "主板版本号: ${baseboardversion} "
echo "主板系列号: ${baseboardserialnumber}"
echo "主板资产标签: ${baseboardassettag} "
echo -e "\n\n"
#
echo "###########################机箱信息#####################################################"
echo "机箱厂商: ${chassismanufacturer} "
echo "机箱型号: ${chassistype}"
echo "机箱版本：${chassisversion}"
echo "机箱编号: ${chassisserialnumber}"
echo "机箱资产标签: ${chassisassettag}"
echo -e "\n\n"
#
echo "###########################CPU信息#####################################################"
echo "处理器厂商: ${processormanufacturer}"
echo "处理器版本: ${processorversion}"
echo "处理器频率：${processorfrequency}"
echo "处理器家族: ${processorfamily}"
echo "物理处理器个数：${cpuconts}"
echo "逻辑处理器核数：${cpucores}"
echo "处理器位数: ${lm}"
echo "处理器是否支持超线程：${hyperthread}"
echo -e "\n\n"
#
echo "###########################内存信息#####################################################"
echo "内存厂商：${memmanufacturer}"
echo "内存条类型; ${memtype}"
echo "内存条个数： ${memcounts}"
echo -e  "单个内存条大小:\n${memsize}"
echo "总内存大小：${memtotlesize}GB"
echo "内存速度：${memspeed}"
echo -e "\n\n"
#
echo "###########################网卡信息#####################################################"
echo "网卡厂商： ${netcardmanufacturer%%Corporation*}"
echo "网卡型号： ${netcardmanufacturer%%Gigabit*}"
echo "网卡带宽： ${netcardspeed}"
echo -e "网卡详细信息：\n ${netcardinfo}"
echo -e "\n\n"
#
echo "###########################硬盘信息#####################################################"
echo "硬盘厂商：   ${disdiskmanufacturer}"
echo "硬盘型号：   ${diskdismode}"
echo "硬盘容量：   ${diskdisize}"
echo "硬盘序列号： ${disdiskserialnumber}"
echo "SSD盘：      ${SSD}"
echo "硬盘类型：   ${dishardtype}盘"
echo "是否是旧盘： ${newdiskinfo}"
echo "硬盘转速：   ${diskspeeddis}"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
printf "%-20s\t%-20s\t%-20s\t%-20s\t%-20s\t%-20s\t%-20s\t%-20s\t\n" "|eth0IP       |处理器厂商 |处理器型号                               |CPU（核数，频率)      |处理器频率 |总内存大小     |磁盘(硬盘大小，类型)                      |网卡速度      |"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
printf "%-20s\t%-20s\t%-5s\t%-5s\t%-20s\t%-20s\t%-20s\t%-20s\t\n" "|${eth0ip}|${processormanufacturer}      | ${processorversion}| ${cpucores}Cores, ${processorfrequency}    |${processorfrequency}   | ${memtotlesize}GB RAM      | ${diskdisize},${diskmode}| ${netcardspeed}网卡|"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

}


function createReport(){
#eth0Ip=$(ifconfig|grep "inet addr"|head -n 1|awk -F " " '{print $2}'|awk -F ":" '{print $2}')
eth0ip1=$(ifconfig|grep "inet addr"|head -n 1|awk -F " " '{print $2}'|awk -F ":" '{print $2}')
eth0ip2=$(ifconfig|grep "inet"|head -n 1|awk -F " " '{print $2}')
if [ -n "${eth0ip1}" ]
then
        eth0Ip=${eth0ip1}
else
        eth0Ip=${eth0ip2}
fi





if [ -d /tmp/mathineReport ]
then
checkHardware>/tmp/mathineReport/check${eth0Ip}Report.txt
else
 mkdir -p /tmp/mathineReport
checkHardware>/tmp/mathineReport/check${eth0Ip}Report.txt
fi

}

function checkOS(){
linuxversion=$(lsb_release -d|awk -F ":" '{print $2}')
coreversion=$(cat /proc/version|awk -F " " '{print $3}')
gccversion=$(gcc --version|head -n 1)
ipinfo=$(ifconfig|grep "eth\|inet addr"|grep -v 127)
#dnsinfo=$(nslookup 127.0.0.1|grep Server|awk -F " " '{print $2}')
dnsinfo=$(cat /etc/resolv.conf|grep nameserver|awk -F " " '{print $2}')
getway=$(route -n|grep UG|awk -F " " '{print $8"\t"$2}')
hostnameinfo=$(hostname)
filesystem=$(df -h)

echo -e "\n\n"
echo "###########################OS信息#####################################################"
echo "主机名：${hostnameinfo}"
echo "操作系统：${linuxversion}"
echo "系统内核：${coreversion}"
echo "gcc：${gccversion}"
echo -e  "IP：\n${ipinfo}"
echo "网关：${getway}"
echo "DNS：${dnsinfo}"
echo -e "磁盘分区：\n${filesystem}"
}



function main(){
  yum -y install sg3_utils lsscsi redhat-lsb  dmidecode hdparm smartmontools>/dev/null

initchecktools

checkHardware

createReport

checkOS

#uninstalltools

}

main

