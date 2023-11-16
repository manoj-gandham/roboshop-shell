script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m--------disable nodejs-------\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

component=user
func_nodejs






