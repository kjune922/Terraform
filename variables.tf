variable "project_name" { default = "lee-3tier-project" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidr" { default = "10.0.1.0/24" }
variable "ubuntu_ami" { default = "ami-0c55b159cbfafe1f0"}
variable "instance_type" { default = "t2.micro" }
