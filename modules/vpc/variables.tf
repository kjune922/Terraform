variable "project_name" {
  description = "프로젝트 이름"
  type = string
}

variable "vpc_cidr" {
  description = "VPC의 IP 범위"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷의 IP범위"
  type = string
  default = "10.0.1.0/24"
}


