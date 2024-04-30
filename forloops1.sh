#!/bin/sh

LOGSDIR=/tmp/$0-$DATE
SCRIPT_NAME=$0
DATE=$9date +%F)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
	if [ $1 -ne 0]
	then
	   echo "$2 INSTALLATION ....$R FAILURE $N"
	   exit 1
    else  
	   echo "$2 INSTALLATION .... $G SUCCESS $N"
    fi  

}



USERID=$(id -u)
if [ $USERID -ne 0]
then
   echo "ERROR: PLEASE run this script with error"
   exit 1
fi


for i in $@
do
	yum list installed $i &>>$LOGSDIR
	if [ $? -ne 0 ]
	then  
	    echo "$i is not installed... let's install it"
		yum install $i -Y  &>> $LOGSDIR
		VALIDATE $? "$i"
    else 
	    echo -e " $y $i is already installed"
    fi

done


