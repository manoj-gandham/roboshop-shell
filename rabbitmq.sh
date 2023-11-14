echo -e "\e[32m--------Configure YUM Repos-------\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[32m--------Configure YUM Repos for RabbitMQ-------\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash


echo -e "\e[32m--------Install RabbitMQ-------\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[32m--------Start RabbitMQ-------\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[32m--------application user-------\e[0m"
rabbitmqctl add_user roboshop roboshop123

echo -e "\e[32m--------set_permissions for user-------\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
