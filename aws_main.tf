# 로컬환경설정
provider "aws" {
  region                      = "ap-northeast-2"
  access_key                  = "test" # 로컬 테스트용 가짜 키
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # 로컬 시뮬레이터를 사용하는 경우 엔드포인트를 지정해야 합니다.
  endpoints {
    ec2 = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}



# 1. VPC 호출
module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# 2. EC2 호출
module "ec2" {
  source = "./modules/ec2"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id
  ubuntu_ami = var.ubuntu_ami
  instance_type = var.instance_type
  db_private_ip = module.db.db_private_ip
}

module "db" {
  source = "./modules/db"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  ubuntu_ami = var.ubuntu_ami
  instance_type = var.instance_type
  web_security_id = module.ec2.web_sg_id
}
