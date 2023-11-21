script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_password=$1   # RoboShop@1

if [ -z "$mysql_password" ]; then
  echo password missing
  exit
fi

func_print_head "disable default mysql version"
dnf module disable mysql -y &>>$log_file
func_status_check $?

func_print_head "copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status_check $?

func_print_head "install mysql server"
dnf install mysql-community-server -y &>>$log_file
func_status_check $?

func_print_head "start mysql service"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_status_check $?

func_print_head "reset mysql password"
mysql_secure_installation --set-root-pass ${mysql_password} &>>$log_file
func_status_check $?