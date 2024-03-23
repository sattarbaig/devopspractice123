#!/bin/bash
LOGSDIR=/home/centos/shellscript.log
DATE=$(date +%F)
LOGFILE=$LOGSDIR/$0-DATE.log
SCRIPT_NAME=$0

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ];
   then
      echo -e "$2 :::$R  is failure $N"
      exit 1
   else
      echo -e "$2 ::: $G is success $N"
   fi
}


USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "run this script with error"
   exit 1
fi

for i in $@
do
    yum list installed &>>$LOGFILE
    if [ $? -ne 0 ];
    then
       echo "$i is not installed, let's install it"
       yum install $i -y &>>$LOGFILE
       VALIDATE $? "$i"
    else
       echo -e "$Y $i is successfully installed"
    fi
done

