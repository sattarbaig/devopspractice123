#!/bin/bash
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2....$R failure $N"
       exit 1
    else
       echo -e "$2 ..... $G  success $N"
    fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
   echo "run this script with failure"
fi

yum install mysql -y  &>>$LOGFILE
VALIDATE $? "installation mysql"

yum install git -y  &>>$LOGFILE
VALIDATE $? "git installation"


