echo "----------configure nodejs repos---------"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo "----------install nodejs---------"
dnf install nodejs -y

echo "----------add application user---------"
useradd roboshop

echo "----------create application dir---------"
rm -rf /app
mkdir /app

echo "----------download app content---------"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo "----------unzip app content---------"
unzip /tmp/catalogue.zip

echo "----------install dependencies---------"
npm install

echo "----------copy catalogue systemd service file ---------"
cd /home/centos/roboshop-shell
cp catalogue.service /etc/systemd/system/catalogue.service

echo "----------start catalogue service---------"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo "----------copy mongo repo---------"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo "----------install mongodb client---------"
dnf install mongodb-org-shell -y

echo "----------load scheema---------"
mongo --host mongodb-dev.mdevops333.online </app/schema/catalogue.js

