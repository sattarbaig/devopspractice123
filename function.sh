#!/bin/sh
DATE=$(date +%F)i
SCRIPT_NAME=$0
LOGFILE=/tmp/$DATE-$SCRIPT_NAME

R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
      echo -e "$2 ... $R FAILURE $N"
      exit 1
   else
      echo -e "$2.... $G success $N"
   fi
}


USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "ERROR:: PLEASE RUN THIS SCRIPT WITH ERROR"
   exit 1
fi

yum install mysql -y &>>$LOGFILE
VALIDATE $? "mysql installation"

yum install git -y &>>$LOGFILE
VALIDATE $? "git installation"
