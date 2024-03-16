DATE=$(date +%F)
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log
SCRIPT_NAME=$0

R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2....$R failure $N"
       exit 1
    else
       echo -e "$2....$G success $N"
    fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
   echo "run this script with error"
fi
yum install mysql -y &>>$LOGFILE
VALIDATE $? "mysql installation"

yum install postfix -y &>>$LOGFILE
VALIDATE $? "postfix installation"       
