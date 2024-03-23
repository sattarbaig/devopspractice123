!#/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
SCRIPT_NAME=$0

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
      echo -e "$2 ::::$R is failure $N"
      exit 1
   else
      echo -e "$2 :::  $G is success $N"
   fi
}

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
VALIDATE $? "install redis package"

yum module enable redis:remi-6.2 -y &>>$LOGFILE
VALIDATE $? "enable redis"

yum install redis -y 
VALIDATE $? "install redis"


cp /home/centos/devopspractice/shellscript/redis.conf /etc/redis.conf

sed -i "s/127.0.0.1/0.0.0.0" /etc/redis.conf etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "replace 127.0.0.1 with 0.0.0.0"

systemctl enable redis

VALIDATE $? " enable redis"

systemctl start redis
VALIDATE $? "start redis"

