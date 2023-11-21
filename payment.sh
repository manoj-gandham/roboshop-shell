script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1  # roboshop123

if [ -z "$rabbitmq_appuser_password" ]; then
  echo password missing
  exit
fi
component=payment
func_python