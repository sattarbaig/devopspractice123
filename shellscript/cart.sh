#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log

USERID =$(id -u)
if [ $USERID -ne 0 ]
then
   echo "run this script with error"
   exit 1
fi

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ];
   then
      echo -e "$2 ::::is failure"
      exit 1
   else
      echo -e "$2 ::: is success"
   fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y &>>$LOGFILE
VALIDATE $? "nodejs installation"

useradd roboshop &>>$LOGFILE
VALIDATE $? "user got added"

mkdir /app &>>$LOGFILE
VALIDATE $? "app dir got created"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>>$LOGFILE
VALIDATE $? "zip got download"

cd /app &>>$LOGFILE
VALIDATE $? "cahange to /app dir"

unzip /tmp/cart.zip &>>$LOGFILE
VALIDATE $? "unzip cart"

cd /app 

cp . /etc/systemd/system/cart.service
npm install &>>$LOGFILE
VALIDATE $? "npm installation"


systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon got reload"

systemctl enable cart 
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"
