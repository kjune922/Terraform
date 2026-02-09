resource "aws_security_group" "lee_sg" {
  name = "${var.project_name}-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id = var.vpc_id

  # 1. 인바운드 규칙
  ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_groups = [aws_security_group.alb_sg.id] # 이제 외부(0.0.0.0/0)이 아닌 ALB를 통해서만 들어오함게
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

# ALB 전용 보안 그룹추가
resource "aws_security_group" "alb_sg" {
  name = "${var.project_name}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 로드밸런서(ALB) 설정
resource "aws_lb" "lee_alb" {
  name = "${var.project_name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = var.public_subnet_ids
}

resource "aws_lb_target_group" "lee_tg" {
  name = "${var.project_name}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    port = "80"
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
    interval = 30
    matcher = "200"
  }
}

resource "aws_lb_listener" "lee_http" {
  load_balancer_arn = aws_lb.lee_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
  type = "forward"
  target_group_arn = aws_lb_target_group.lee_tg.arn
  }
}


# EC2인스턴스

#resource "aws_instance" "lee_app" {
#  ami = var.ubuntu_ami
#  instance_type = var.instance_type
#  subnet_id = var.subnet_id
#  vpc_security_group_ids = [aws_security_group.lee_sg.id]
#  key_name = "lee_key"
#  associate_public_ip_address = true

# localstack -> AWS 옮기면서 db관련 올 주석처리
#  user_data_replace_on_change = true
#  user_data = templatefile("${path.root}/userdata.sh")

#  tags = {
#  Name = "${var.project_name}"
#  }
#}


# EC2 실행 템플릿 (기존 aws_instance.lee_app을 이거로 대체)
resource "aws_launch_template" "lee_lt" {
  name_prefix = "${var.project_name}-lt-"
  image_id = var.ubuntu_ami
  instance_type = var.instance_type
  key_name = "lee_key"
  user_data = base64encode(templatefile("${path.module}/userdata.sh",{db_endpoint = var.db_endpoint}))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.lee_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-asg-instance"
    }
  }
}

# 오토스케일링 그룹설정

resource "aws_autoscaling_group" "lee_asg" {
  desired_capacity = 2
  max_size = 4
  min_size = 1
  target_group_arns = [aws_lb_target_group.lee_tg.arn]
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id = aws_launch_template.lee_lt.id
    version = "$Latest"
  }
}





