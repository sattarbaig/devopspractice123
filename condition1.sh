#/bin/bash
USERID=$(id -u)


#it is our responsibility to check whether mysql installation is success or not

if [ $USERID -ne 0 ]
then
   echo "run this script with error"
   exit 1
fi
#it is our responsibility to check whether mysql installation is success or not
yum install mysql -y
if [ $? -ne 0 ]
then
   echo "mysql installation is failure"
   exit 1
else
   echo "mysql installation is success"
fi

