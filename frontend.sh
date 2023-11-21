script_path=$(dirname $0)
source ${script_path}/common.sh
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<\e[0m"
}
func_print_head "install nginx"
dnf install nginx -y &>>$log_file
func_status_check $?

func_print_head "copy roboshop conf file"
cp roboshop.conf /et/nginx/default.d/roboshop.conf &>>$log_file
func_status_check $?

func_print_head "remove nginx html content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status_check $?

func_print_head "get frontend zip file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status_check $?

func_print_head "remove old content"
cd /usr/share/nginx/html &>>$log_file
func_status_check $?

func_print_head "unzip content"
unzip /tmp/frontend.zip &>>$log_file
func_status_check $?

func_print_head "start nginx service"
systemctl restart nginx &>>$log_file
systemctl enable nginx &>>$log_file
func_status_check $?

