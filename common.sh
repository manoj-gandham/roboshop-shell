app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<\e[0m" &>>$log_file
}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[36mSUCESS\e[0m"
  else
    echo -e "\e[31mERROR\e[0m"
    echo "refer the log file for more info /tmp/roboshop.log"
    exit 1
  fi
}


func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    func_status_check $?

    func_print_head "Install MongoDB Client"
    yum install mongodb-org-shell -y &>>$log_file
    func_status_check $?

    func_print_head "Load Schema"
    mongo --host mongodb-dev.mdevops333.online </app/schema/${component}.js &>>$log_file
    func_status_check $?
  fi

  if [ "$schema_setup" == "mysql" ]; then
      func_print_head "Install MySQL"
      yum install mysql -y &>>$log_file
      func_status_check $?

      func_print_head "Load Schema"
      mysql -h mysql-dev.mdevops333.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
      func_status_check $?
  fi
  }

func_app_prereq() {
    func_print_head "Create App User"
    id ${app_user} &>>/tmp/roboshop.log
    if [ $? -ne 0 ]; then
      useradd ${app_user} &>>$log_file
    fi
    func_status_check $?

    func_print_head "Create App Directory"
    rm -rf /app
    mkdir /app
    func_status_check $?

    func_print_head "Download App Content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_status_check $?

    func_print_head "Extract App Content"
    cd /app
    unzip /tmp/${component}.zip &>>$log_file
    func_status_check $?
}

func_systemd_setup() {
    func_print_head "Setup SystemD Service"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_status_check $?

    func_print_head "Start ${component} Service"
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    func_status_check $?
}

func_nodejs() {
  func_print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status_check $?

  func_print_head "Install NodeJS"
  yum install nodejs -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_print_head "Install NodeJS Dependencies"
  npm install &>>$log_file
  func_status_check $?

  func_schema_setup
  func_systemd_setup
}

func_java() {
  func_print_head "Install Maven"
  yum install maven -y &>>$log_file
  func_status_check $?

  func_app_prereq

  func_print_head "Download Maven Dependencies"
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_status_check $?

  func_schema_setup
  func_systemd_setup
}