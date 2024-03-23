#!/bin/bash
DATE=$(date +%F)
LOGSDIR=/tmp
LOGFILE=$LOGSDIR/$0-DATE.log

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
   if [ $1 -ne 0 ]
   then
      echo -e "$2 ;;;; $R is failure $N"
      exit 1
   else
      echo -e "$2 :::: $G is success $N"
   fi
}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "installing rabbitmq package"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "UM Repos for RabbitMQ"

yum install rabbitmq-server -y &>>$LOGFILE
VALIDATE $? "rabbitmq server installed"

systemctl enable rabbitmq-server 
VALIDATE $? "enable rabbitmq server"

systemctl start rabbitmq-server 
VALIDATE $? "start rabbit-mq server"

rabbitmqctl add_user roboshop roboshop123
VALIDATE $? "adding user"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
VALIDATE $? "set_permission"
