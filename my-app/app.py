# app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "안녕! 이건 로컬스택 aws를 활용한 간단한 도커를 활용한 fastapi 앱서버야"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

