script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m--------copy repo mongo repo file-------\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_status_check $?

echo -e "\e[32m--------install momgodb-------\e[0m"
dnf install mongodb-org -y
func_status_check $?

echo -e "\e[32m--------update listen address port-------\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
func_status_check $?

echo -e "\e[32m--------start mongodb service-------\e[0m"
systemctl enable mongod
systemctl restart mongod
func_status_check $?
