resource "aws_security_group" "lee_db_sg" {
  name = "${var.project_name}-db-sg"
  vpc_id = var.vpc_id
  tags = {
  Name = "${var.project_name}-db-sg"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro" # 프리티어
  db_name = "mydb"
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.lee_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.lee_db_sg.id]
}

resource "aws_db_subnet_group" "lee_db_subnet_group" {
  name = "${var.project_name}-db-subnet-group"
  # vpc 모듈에서 만든 두 프라이빗 서브넷의 id를 받음
  subnet_ids = var.private_subnet_ids

  tags = {
  Name = "${var.project_name}-db-subnet-group"
  }
}

# rds 보안그룹 설정추가
resource "aws_security_group_rule" "rds_ingress" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  
  security_group_id = aws_security_group.lee_db_sg.id # 이 rds방에서 만든 SG
  source_security_group_id = var.web_security_id # 허용할 대상임 , 루트에서 만든 ec2방에서 나온 열쇠를 rds방에 전달
}
