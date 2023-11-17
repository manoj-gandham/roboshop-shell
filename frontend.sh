script_path=$(dirname $0)
source ${script_path}/common.sh


dnf install nginx -y
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl restart nginx
systemctl enabl nginx
if [ $? -eq 0 ]; then
  echo -e "\e[35msucess\e[0m"
else
  echo -e "\e[32mfailure\e[0m"
fi
