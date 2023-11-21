script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "disable nodejs"
dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:18 -y &>>$log_file
func_status_check $?

component=user
schema_setup=mongo
func_nodejs






