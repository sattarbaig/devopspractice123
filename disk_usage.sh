#!/bin/sh
LOGDIR=/home/centos/shellscript.log
DATE=$(date +%F)
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
SCRIPT_NAME=$0


R="\e[31m"
G="\e32m"
Y="\e[33m"
N="\e[0m"

DISK_USAGE=$(df -hT | grep -vE 'tmpfs|Filesystem')
DISK_USAGE_THRESHOLD=1
message=""

#IFS= means internal feild seperator is space.
while IFS= read line
do  
    # this command will give you usage in number format for comparision
    usage=$(echo $line | awk '{print $6}' | cut -d % -f1)
    # this command will give us partition
    partition=$(echo $line | awk '{print $1}')
    #now you need to check whether it is more than threshold or not
    if [ $usage -gt $DISK_USAGE_THRESHOLD ];
    then
        message+="HIGH DISK USAGE on $partition: $usage\n"
    fi
done <<< $DISK_USAGE

echo -e "message: $message"

#echo "$message" | mail -s "High Disk usage" info@joindevops.com

#how to call other shell script from your current script
sh mail.sh sattarbaig786@gmail.com "High Disk Usage" "$message" "DEVOPS TEAM" "High Disk usage"
