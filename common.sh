app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[35m--------$*-------\e[0m"
}

schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
  print_head "copy mongo repo"
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  print_head "install momgodb client"
  dnf install mongodb-org-shell -y

  print_head "load scheema"
  mongo --host mongodb-dev.mdevops333.online </app/schema/${component}.js
  fi
}

func_nodejs() {
  print_head "configure nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "install nodejs"
  dnf install nodejs -y

  print_head "add application user"
  useradd ${app_user}

  print_head "create application dir"
  rm -rf /app
  mkdir /app

  print_head "download app content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "unzip app content"
  unzip /tmp/${component}.zip

  print_head "install npm dependencies"
  npm install

  print_head "copy catalogue systemd service file"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

  print_head "start catalogue service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  schema_setup
}