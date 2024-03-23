#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}


yum install python36 gcc python3-devel -y &>>$LOGFILE
VALIDATE $? "python package got download"

useradd roboshop &>>$LOGFILE
VALIDATE $? "user got added"

mkdir /app &>>$LOGFILE
VALIDATE $? "create a appdir"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE
VALIDATE $? "downlaod app code"

cd /app
VALIDATE $? "changing to app dir"

unzip /tmp/payment.zip
VALIDATE $? "unzip paymant"

pip3.6 install -r requirements.txt
VALIDATE $? "install dependencies"

cat <<EOF | sudo tee -a /etc/systemd/system/payment.service
[Unit]
Description=Payment Service

[Service]
User=root
WorkingDirectory=/app
Environment=CART_HOST=<CART-SERVER-IPADDRESS>
Environment=CART_PORT=8080
Environment=USER_HOST=<USER-SERVER-IPADDRESS>
Environment=USER_PORT=8080
Environment=AMQP_HOST=<RABBITMQ-SERVER-IPADDRESS>
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123

ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 $MAINPID
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"


systemctl enable payment
VALIDATE $? "enable payment"

systemctl start payment
VALIDATE $? "start payment"


