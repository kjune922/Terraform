provider "aws" {
        region = "ap-northeast-2"
        access_key = "test"
        secret_key = "test"
        skip_credentials_validation = true
        skip_metadata_api_check = true
        skip_requesting_account_id = true

        # 모든서비스 엔드포인트 4566, localstack
        endpoints {
        ec2 = "http://localhost:4566"
        sts = "http://localhost:4566"
        }
}

resource "aws_vpc" "portfolio_vpc" {
        cidr_block = "10.0.0.0/16"
        enable_dns_hostnames = true

        tags = {
        Name = "my-portfolio-vpc"
        }
}

resource "aws_subnet" "public_subnet" {
        vpc_id  = aws_vpc.portfolio_vpc.id
        cidr_block = "10.0.1.0/24"
        availability_zone = "ap-northeast-2a"

        tags = {
        Name = "portfolio-public-subnet"
        }
}

resource "aws_internet_gateway" "igw" {
        vpc_id = aws_vpc.portfolio_vpc.id
        tags = {
        Name = "portfolio_igw"
        }
}

# 라우팅 테이블
resource "aws_route_table" "public_rt" {
	vpc_id = aws_vpc.portfolio_vpc.id
	
	route {
		cidr_block = "0.0.0.0/0" # 모든 트래픽을
		gateway_id = aws_internet_gateway.igw.id # 우리가 만든 인터넷 게이트웨이로 보냄
	}
	
	tags = {
	Name = "public-route-table"
	}
}

# 2. 라우팅 테이블과 서브넷을 서로 연결
resource "aws_route_table_association" "public_rt_assoc" {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public_rt.id
}

# 3. Security Group 설정

resource "aws_security_group" "portfolio_sg" {
	name = "portfolio-sg"
	description = "Allow HTTP and SSH traffic"
	vpc_id = aws_vpc.portfolio_vpc.id

	# 1. 인바운드 규칙
	ingress {
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"] # 전 세계 어디서든 HTTP 접속 허용
	}
	
	ingress {
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"] # 전 세계 ssh 접속 허용
}

	# 2. 아웃바운드 규칙 # 내부에서 외부로나가는
	egress {
	from_port = 0
	to_port = 0
	protocol = "-1" # 모든 프로토콜 ㅇㅋ
	cidr_blocks = ["0.0.0.0/0"]
}
	tags = {
	Name = "portfolio-sg"
	}
}

# EC2 인스턴스 생성 ㄱㄱ
resource "aws_instance" "portfolio_app" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.portfolio_sg.id]
  key_name                    = "portfolio_key"
  user_data_replace_on_change = true # 코드가 바뀌면 인스턴스를 새로 생성함

  user_data = <<-EOF
              #!/bin/bash
              # 1. 시스템 패키지 업데이트 및 필요 도구 설치
              sudo apt-get update -y
              sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

              # 2. Docker 공식 GPG 키 추가 및 저장소 등록
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

              # 3. Docker 엔진 설치
              sudo apt-get update -y
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io

              # 4. Docker 서비스 시작 및 부팅 시 자동 실행 설정
              sudo systemctl start docker
              sudo systemctl enable docker

              # 5. (선택) ubuntu 사용자가 sudo 없이 docker를 쓸 수 있게 권한 부여
              sudo usermod -aG docker ubuntu
              
	      
              # 6. Docker compose 설치 ㄱㄱ
	      sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
	      
		#7. 애플리케이션 파일 생성(2026-01-23)
		cat <<EOT>> app.py
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
	return "안녕, 이건 테라폼으로 설계한 자동화도커 컨테이너앱이야"
if __name__ == "__main__":
	app.run(host="0.0.0.0",port=5000)
EOT
		cat <<EOT>> requirements.txt
Flask
EOT
		
		cat <<EOT>> Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python","app.py"]
EOT

	# 8. 이미지 빌드 및 컨테이너 실행
	docker build -t my-python-app .
	docker run -d -p 80:5000 --name 내 파이썬웹서버with테라폼
	EOF

  tags = {
    Name = "Portfolio-Docker-Server"
  }
}

