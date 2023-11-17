script_path=$(dirname $0)
source ${script_path}/common.sh

func_ststus_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[36mSUCESS\e[0m"
  else
    echo -e "\e[31mERROR\e[0m"
  fi
}
dnf install nginx -y
func_ststus_check
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
func_ststus_check
rm -rf /usr/share/nginx/html/*
func_ststus_check
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_ststus_check
cd /usr/share/nginx/html
func_ststus_check
unzip /tmp/frontend.zip
func_ststus_check
systemctl restart nginx
func_ststus_check
systemctl enable nginx
func_ststus_check

