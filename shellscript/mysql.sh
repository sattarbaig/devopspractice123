#!/bin/sh
DATE=$(date +%F)
LOGSDIR=/tmp
LOGSFILE=$LOGSDIR/$0-$DATE.log
SCRIPT_NAME=$0

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "run this script with error"
   exit 1
fi

R='/e[31m"
G="/e[32m"
Y="/e[33m"
N="/e[0m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
      echo "$2 ::: is failure"
      exit 1
   else
      echo "$2 ::: is success"
   fi
}

yum module disable mysql -y  &>>$LOGFILE
VALIDATE $? "disable mysql"

cat <<EOF | sudo tee -a /etc/yum.repos.d/mysql.repo

[mysql]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0

yum install mysql-community-server -y &>>$logfile
VALIDATE $? "install mysql-community"


systemctl enable mysqld

VALIDATE $? "enable mysqld"

systemctl start mysqld
VALIDATE $? "start mysqld"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "setting root password"
