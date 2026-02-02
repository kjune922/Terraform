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
  vpc_security_group_ids = [var.web_security_id]
}

resource "aws_db_subnet_group" "lee_db_subnet_group" {
  name = "${var.project_name}-db-subnet-group"
  # vpc 모듈에서 만든 두 프라이빗 서브넷의 id를 받음
  subnet_ids = var.private_subnet_ids

  tags = {
  Name = "${var.project_name}-db-subnet-group"
  }
}
