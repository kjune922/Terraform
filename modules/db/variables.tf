variable "project_name" {
  description = "프로젝트 이름"
  type = string
}

variable "vpc_id" {
  description = "어느 동네에 DB만들꺼?"
  type = string
}

variable "private_subnet_id" {
  description = "어느 구역에 DB만들꺼?"
  type = string
}

variable "web_security_id" {
  description = "Web_sg_id가 달린애들만 db가 받겠다?"
  type = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ubuntu_ami" {
  type = string
}
