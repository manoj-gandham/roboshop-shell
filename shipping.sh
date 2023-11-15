script_path=$(dirname $0)
source ${script_path}/common.sh


echo -e "\e[32m--------install maven-------\e[0m"
dnf install maven -y

echo -e "\e[32m--------Add application User-------\e[0m"
useradd ${app_user}

echo -e "\e[32m--------setup app dir-------\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m--------Download the application code-------\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[32m--------unzip content-------\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[32m--------download the dependencies & build the application-------\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[32m--------Setup SystemD Shipping Service-------\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[32m--------Load the service-------\e[0m"
systemctl daemon-reload

echo -e "\e[32m--------install mysql client-------\e[0m"
dnf install mysql -y

echo -e "\e[32m--------load sheema-------\e[0m"
mysql -h mysql-dev.mdevops333.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[32m--------start the shipping service-------\e[0m"
systemctl enable shipping
systemctl restart shipping





