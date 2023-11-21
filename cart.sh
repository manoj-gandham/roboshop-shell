script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=cart

func_print_head "disable default nodejs version and enable required version"
dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:18 -y &>>$log_file
func_status_check $?

func_nodejs

