#!/bin/bash
DATE=$(date +%F)
LOGSDIR=/home/centos/shellscript.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "run this script with error"
   exit 1
fi

VALIDATE(){
   if [ $1 -ne 0 ]
   then
      echo -e "install $2 .... $R failure $N"
      exit 1
   else
      echo -e "install $2.... $G success $N "
   fi
}

for i in $@
do
    yum list installed &>>$LOGFILE
    if [ $? -ne 0 ]
    then
       echo "if it's not installed, let's install it"
       yum install $i -y &>>$LOGFILE
       VALIDATE $? "$i"
    else
       echo -e "$y $i is successfully installed"
    fi
done
