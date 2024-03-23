!#/bin/bash
DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
SCRIPT_NAME=$0

R="\e[31m]"
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
   if [ $1 -ne 0 ];
   then
      echo -e "$2 ;;;; is failure"
      exit 1
   else
      echo -e "$2 :::: is success"
   fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "nodejs installed"

useradd roboshop &>>$LOGFILE
VALIDATE $? "user got added"

mkdir /app
VALIDATE $? "app dir created"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

cd /app
VALIDATE $? "switching to app dir"

unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "unzip catalogue"


npm install &>>$LOGFILE
VALIDATE $? "dependencies installation"

cp /home/centos/devopspractice/shellscript/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload
VALIDATE $? "daemon got reloaded"

systemctl enable catalogue
VALIDATE $? "enable catalogue"

systemctl start catalogue
VALIDATE $? "start catalogue"

vim /etc/yum.repos.d/mongo.repo
cat  >> /etc/yum.repos.d/mongo.repo

[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=0
enabled=1


yum install mongodb-org-shell -y

VALIDATE $? "mongodb installation is successful"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
