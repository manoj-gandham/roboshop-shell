script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m--------Install Python-------\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[32m--------Add application User-------\e[0m"
useradd ${app_user}

echo -e "\e[32m--------setup an app directory-------\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m--------Download the application code-------\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[32m--------unzip content-------\e[0m"
unzip /tmp/payment.zip


echo -e "\e[32m--------download the dependencie-------\e[0m"
pip3.6 install -r requirements.txt


echo -e "\e[32m--------Setup SystemD Payment Service-------\e[0m"
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[32m--------Load the service-------\e[0m"
systemctl daemon-reload

echo -e "\e[32m--------Start the shipping service-------\e[0m"
systemctl enable payment
systemctl restart payment
