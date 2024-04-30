#!/bin/bash

LOGFILE=/tmp/$SCRIPT_NAME-$DATE
DATE=$(date +%F)
SCRIPT_NAME=$0

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
      echo -e "$2 installation .... $R failure $N"
      exit 1
   else
      echo -e "$2 installation .... $G is success $N"
   fi
}


USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "ERROR: please run this script with error"
   exit 1
fi

for i in $@
do
  yum list installed $i &>>LOGFILE
  if [ $? -ne 0 ]
  then
     echo "$i is not installed... let's install it"
     yum install $i -yi &>>$LOGFILE
     VALIDATE $? "$i"
  else
     echo -e "$Y $i is already install"
  fi
done




