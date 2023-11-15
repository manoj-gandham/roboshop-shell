script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_user_pass=$1

echo -e "\e[32m--------disable default mysql version-------\e[0m"
dnf module disable mysql -y

echo -e "\e[32m--------copy mysql repo file-------\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[32m--------install mysql server-------\e[0m"
dnf install mysql-community-server -y

echo -e "\e[32m--------start mysql service-------\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[32m--------reset mysql password-------\e[0m"
mysql_secure_installation --set-root-pass ${mysql_user_pass}
