#!/bin/bash
APP_LOGS=/home/centos/app.log
LOGSDIR=/home/centos/shellscript.log
LOGFILE=$LOGSDIR/$0-$DATE.log
DATE=$(date +%F)
SCRIPT_NAME=$0

FILES_TO_DELETE=$( find $APP_LOGS -name "*.logs" -type f -mtime +14)
echo "script started at $DATE" &>>$LOGFILE

while read line
do 
    echo "delete $line" &>>$LOGFILE
    rm -rf $line
done <<< $FILES_TO_DELETE
