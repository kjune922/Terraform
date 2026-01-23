# 1. 가벼운 파이썬 이미지를 베이스로 ㄱㄱ
FROM python:3.9-slim

# 2. 컨테이너 내부 작업 디렉토리 설정
WORKDIR /app

# 3. 라이브러리 목록 복사
COPY requirements.txt .

# 4. 라이브러리 설치
RUN pip install --no-cache-dir -r requirements.txt

# 5. 나머지 소스코드 복사
COPY . .

# 6. 앱 실행
CMD ["python","app.py"] 
