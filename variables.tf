variable "project_name" { default = "lee-3tier-project" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidr" { default = "10.0.1.0/24" }
variable "ubuntu_ami" { default = "ami-040c33c6a51fd5d96"}
variable "instance_type" { default = "t2.micro" }
variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  default = "10.0.3.0/24"
}
