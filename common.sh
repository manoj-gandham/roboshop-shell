app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs() {
  echo -e "\e[32m--------configure nodejs repos-------\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[32m--------install nodejs-------\e[0m"
  dnf install nodejs -y

  echo -e "\e[32m--------add application user-------\e[0m"
  useradd ${app_user}

  echo -e "\e[32m--------create application dir-------\e[0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[32m--------download app content-------\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[32m--------unzip app content-------\e[0m"
  unzip /tmp/${component}.zip

  echo -e "\e[32m--------install npm dependencies-------\e[0m"
  npm install

  echo -e "\e[32m--------copy catalogue systemd service file-------\e[0m"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[32m--------start catalogue service-------\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}