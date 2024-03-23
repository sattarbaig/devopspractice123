#!/bin/bash
USERID =$(id -u)
if [ $USERID -ne 0 ]
then
   echo "error: please run this script with root access"
   exit 1
fi

yum install mysql -y
if [ $? -ne 0 ]
then
   echo "mysql installation is error"
   exit 1
else
   echo "mysql installation  is success"
fi

yum install git -y
if [ $? -ne 0 ]
then
   echo "installation of git is error"
   exit 1
else
   echo "git installation is success"
fi
