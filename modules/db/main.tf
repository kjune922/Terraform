resource "aws_security_group" "db_sg" {
  vpc_id = var.vpc_id
  description = "3306(mysql)요청으로 들어오는 것중에 web_sg_id라는 이름표가 달린애만 받을게"
  
  # 인바운드 규칙
  ingress {
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_groups = [var.web_security_id]
  }

  # 아웃바운드 규칙
  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  Name = "${var.project_name}-db-sg-group"
  }
}
  
resource "aws_instance" "lee_db_ec2" {
  ami = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name = "lee_db_key"
  
  user_data_replace_on_change = true
  # user_data = file("${path.root}/db_setup.sh")


  tags = {
  Name = "${var.project_name}-db-ec2"
  }
}
