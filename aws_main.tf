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
	ami = "ami-0c55b159cbfafe1f0"
	instance_type = "t2.micro"
	

	# 부팅시 자동 실행될 쉘 스크립트
	user_data = <<-EOF
		#!/bin/bash
		echo "Hello,CloudEngineer! This is my first portfolio server!">
		nohup python3 -m http.server 80 &
		EOF
	# 변경시마다 인스턴스를 새로 생성하도록 강제 ㄱㄱ
	user_data_replace_on_change = true

	# 어제 만든 서브넷과 보안 그룹 연결
	subnet_id = aws_subnet.public_subnet.id
	vpc_security_group_ids = [aws_security_group.portfolio_sg.id]

	# 위에서 만든 키 페어 이름
	key_name = "portfolio_key"
	tags = {
	Name = "Portfolio-App-Server"
	}
}


