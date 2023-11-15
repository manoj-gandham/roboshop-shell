script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m--------configure nodejs repos-------\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m--------install nodejs-------\e[0m"
dnf install nodejs -y

echo -e "\e[32m--------add application user-------\e[0m"
useradd ${app_user}

echo -e "\e[32m--------create application dir-------\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m--------download app content-------\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[32m--------unzip app content-------\e[0m"
unzip /tmp/cart.zip

echo -e "\e[32m--------install npm dependencies-------\e[0m"
npm install

echo -e "\e[32m--------copy cart systemd service file-------\e[0m"
cp $script_path/cart.service /etc/systemd/system/cart.service

echo -e "\e[32m--------start cart service-------\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

