#!/bin/bash
# 에러확인용
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "배포 시작중..."



# 1. 패키지 업데이트 및 파이썬 설치
sudo apt-get update -y
sudo apt-get install -y python3-pip python3-venv

# 2. 앱 디렉토리 생성 및 이동 (예시)
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# 3. 여기서 앱 소스코드를 가져오거나 작성해야 합니다.
# (포트폴리오용이라면 git clone을 쓰거나, 테스트용이라면 아래처럼 간단히 작성)
cat <<EOF > main.py
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, Gyeong jun! Your ALB is working!"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)
EOF

# 4. 가상환경 생성 및 설치
python3 -m venv venv
./venv/bin/pip install fastapi uvicorn

# 5. 앱 실행 (백그라운드)
sudo ./venv/bin/python3 main.py > /home/ubuntu/app.log 2>&1 &
