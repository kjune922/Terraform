resource "aws_security_group" "lee_sg" {
  name = "${var.project_name}-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id = var.vpc_id

  # 1. 인바운드 규칙
  ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  # 2. 아웃바운드 규칙
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
  Name = "${var.project_name}-sg"
  }
}


# EC2인스턴스

resource "aws_instance" "lee_app" {
  ami = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.lee_sg.id]
  key_name = "lee_key"
  associate_public_ip_address = true

# localstack -> AWS 옮기면서 db관련 올 주석처리
#  user_data_replace_on_change = true
#  user_data = templatefile("${path.root}/userdata.sh")

  tags = {
  Name = "${var.project_name}"
  }
}


