#!/bin/bash

# 1. 패키지 목록 업데이트 (리눅스 설치의 기본)
sudo apt-get update -y

# 2. MySQL 서버 설치 
# -y 옵션이 필수입니다. (사람이 없으므로 "동의하시겠습니까?"에 무조건 YES!)
sudo apt-get install -y mysql-server

# 3. MySQL 서비스 실행 및 부팅 시 자동 시작 설정
sudo systemctl start mysql
sudo systemctl enable mysql

# 4. 데이터베이스 및 사용자 생성
sudo mysql -e "CREATE DATABASE lee_db;"
sudo mysql -e "CREATE USER 'kjune922'@'%' IDENTIFIED BY 'password123!';"
sudo mysql -e "GRANT ALL PRIVILEGES ON lee_db.* TO 'kjune922'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"


# 5. 외부 접속 허용 설정
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql
