source common.sh

echo -e "\e[32m--------install redis repo file-------\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[32m--------install redis-------\e[0m"
dnf module enable redis:remi-6.2 -y
dnf install redis -y

echo -e "\e[32m--------update redis listen address-------\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf

echo -e "\e[32m--------start redis service-------\e[0m"
systemctl enable redis
systemctl restart redis