script_path=$(dirname $0)
source ${script_path}/common.sh

func_ststus_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[36mSUCESS\e[0m"
  else
    echo -e "\e[31mERROR\e[0m"
    exit 1
  fi
}

func_print_head() {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<\e[0m"
}
func_print_head "install nginx"
dnf install nginx -y
func_ststus_check

func_print_head "copt roboshop conf file"
cp roboshop.conf /et/nginx/default.d/roboshop.conf
func_ststus_check

func_print_head "remove nginx html content"
rm -rf /usr/share/nginx/html/*
func_ststus_check

func_print_head "get frontend zip file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_ststus_check

func_print_head "remove old content"
cd /usr/share/nginx/html
func_ststus_check

func_print_head "unzip content"
unzip /tmp/frontend.zip
func_ststus_check

func_print_head "start nginx service"
systemctl restart nginx
systemctl enable nginx
func_ststus_check

