#!/bin/bash
DATE=$(id -u)
SCRIPT_NAME=$0
LOGFILE=/tmp/$0-$DATE.log


R="\e[31m"
G="\e[32m"
N="\e[0m"
VALIDATOR(){
   if [ $1 -ne 0 ];
   then
      echo -e "$2::: $R is failure $N"
      exit 1
   else
      echo -e "$2::: $G is success $N"
   fi
}

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "run this script with error"
   exit 1
fi


yum install java -y  &>>$LOGFILE
VALIDATOR $? "mysql installation"
yum unstall postfix -y  &>>$LOGFILE
VALIDATOR $? "postfix installation"
