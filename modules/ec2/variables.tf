variable "project_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  description = "ALB랑 ASG를 위한 퍼블릭 서브넷 아이디들의 리스트"
  type = list(string)
}
variable "instance_type" { default = "t2.micro" }

variable "ubuntu_ami" {
  description = "EC2에 사용할 AMI ID"
  type = string
}

