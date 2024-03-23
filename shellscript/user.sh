#!/bin/sh
DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-SDATE.log

USERID=$(id -u)
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
      echo "$2 :::: $R is failure"
      exit 1
   else
      echo "$2 :::: $G is success $N"
   fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>$LOGFILE

yum install nodejs -y  &>>$LOGFILE
VALIDATE $? "nodejs installation"

useradd roboshop  &>>$LOGFILE
VALIDATE $? "user got added"

mkdir /app &>>$LOGFILE
VALIDATE $? "app got created"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE
VALIDATE $? "user.zip got downloaded"

cd /app &>>$LOGFILE

unzip /tmp/user.zip &>>$LOGFILE
VALIDATE $? "unzip user"

npm install &>>$LOGFILE
VALIDATE $i "download dependencies"

cat <<EOF | sudo tee -a /etc/systemd/system/user.service
[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=<REDIS-SERVER-IP>
Environment=MONGO_URL="mongodb://<MONGODB-SERVER-IP-ADDRESS>:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target

VALIDATE $? "content got added"

systemctl daemon-reload &>>$LOGFILE

systemctl enable use  &>>$LOGFILE

systemctl start user &>>$LOGFILE


cat <<EOF | sudo tee -a /etc/yum.repos.d/mongo.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=0
enabled=1

yum install mongodb-org-shell -y &>>$LOGFILE
VALIDATE $? "mongodb got installed"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js
