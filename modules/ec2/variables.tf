variable "project_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "instance_type" { default = "t2.micro" }

variable "ubuntu_ami" {
  description = "EC2에 사용할 AMI ID"
  type = string
}

variable "db_private_ip" {
  description = "DB모듈에서 전달받은 사설 IP주소"
  type = string
}
