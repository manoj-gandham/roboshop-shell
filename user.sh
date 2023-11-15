script_path=$(dirname $0)
source common.sh



exit
echo -e "\e[32m--------install nodejs repo file-------\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m--------install nodejs-------\e[0m"
dnf install nodejs -y

echo -e "\e[32m--------add application user-------\e[0m"
useradd ${app_user}

echo -e "\e[32m--------setup application dir-------\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m--------Download the application-------\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[32m--------unzip the content-------\e[0m"
unzip /tmp/user.zip

echo -e "\e[32m--------Download npm-------\e[0m"
npm install

echo -e "\e[32m--------copy user systemd service file-------\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[32m--------start user service-------\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user

echo -e "\e[32m--------copy mongo repo-------\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m--------install mongodb-------\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m--------load scheema-------\e[0m"
mongo --host mongodb-dev.mdevops333.online </app/schema/user.js






