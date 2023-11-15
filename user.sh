script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
func_nodejs

echo -e "\e[32m--------copy mongo repo-------\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m--------install mongodb-------\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m--------load scheema-------\e[0m"
mongo --host mongodb-dev.mdevops333.online </app/schema/user.js






