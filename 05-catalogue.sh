#!bin/bash

app_name=catalogue
source ./common.sh
check_root

app_setup
nodejs_setup 

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding MongoDB repo"

dnf install mongodb-mongosh -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB client"

INDEX=$(mongosh --host mongodb.arrud.online --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -lt 0 ]; then
    mongosh --host mongodb.arrud.online < /app/db/master-data.js &>>$LOGS_FILE
VALIDATE $? "Loading products"
else
    echo -e "products already loaded ... $Y skipping $N"
fi

systemctl enable catalogue &>>$LOGS_FILE
systemctl restart catalogue &>>$LOGS_FILE 
VALIDATE $? "reStarting and enabling catalogue service"