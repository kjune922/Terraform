#!/bin/bash
# 1. 시스템 업데이트 및 Docker 설치
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Docker Compose 설치
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 2. 애플리케이션 작업 디렉토리 생성
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# 3. [app.py] 생성
cat <<EOT > app.py
from flask import Flask
import os
import time
import mysql.connector

app = Flask(__name__)

db_config = {
    "host": os.getenv("DB_HOST","db"),
    "user": os.getenv("DB_USER","admin"),
    "password": os.getenv("DB_PASS","password123!"),
    "database": os.getenv("DB_NAME","portfolio_db")
}

def get_db_connection():
    retries = 5
    while retries > 0:
        try:
            conn = mysql.connector.connect(**db_config)
            return conn
        except:
            retries -= 1
            time.sleep(2)
    return None

@app.route('/')
def index():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute("CREATE TABLE IF NOT EXISTS visits (id INT AUTO_INCREMENT PRIMARY KEY, visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
        cursor.execute("INSERT INTO visits () VALUES ()")
        conn.commit()
        cursor.execute("SELECT COUNT(*) FROM visits")
        count = cursor.fetchone()[0]
        conn.close()
        return f"<h1>안녕! 풀스택 배포 성공!</h1><p>현재까지 총 방문 횟수: {count}</p>"
    else:
        return "<h1>DB 연결 실패...</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOT

# 4. [requirements.txt] 생성
cat <<EOT > requirements.txt
Flask
mysql-connector-python
EOT

# 5. [Dockerfile] 생성
cat <<EOT > Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]
EOT

# 6. [docker-compose.yml] 생성
cat <<EOT > docker-compose.yml
version: "3.8"
services:
  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: portfolio_db
      MYSQL_USER: admin
      MYSQL_PASSWORD: password123!
      MYSQL_ROOT_PASSWORD: password123!
    ports:
      - "3306:3306"

  web:
    build: .
    ports:
      - "80:5000"
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_NAME: portfolio_db
      DB_USER: admin
      DB_PASS: password123!
EOT

# 7. 서비스 실행 (전체 자동화)
sudo /usr/local/bin/docker-compose up -d --build
