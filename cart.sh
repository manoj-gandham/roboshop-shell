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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo "----------unzip app content---------"
unzip /tmp/cart.zip

echo "----------install dependencies---------"
npm install

echo "----------copy catalogue systemd service file ---------"
cd /home/centos/roboshop-shell
cp cart.service /etc/systemd/system/cart.service

echo "----------start catalogue service---------"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

