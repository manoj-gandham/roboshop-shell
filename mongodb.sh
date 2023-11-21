script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "copy repo mongo repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_status_check $?

func_print_head "install momgodb"
dnf install mongodb-org -y &>>$log_file
func_status_check $?

func_print_head "update listen address port"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
func_status_check $?

func_print_head "start mongodb service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_status_check $?
