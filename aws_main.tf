# 로컬환경설정
provider "aws" {
  region                      = "ap-northeast-2"

  # 로컬 시뮬레이터를 사용하는 경우 엔드포인트를 지정해야 합니다.
  # 실제 AWS ㄱㄱ
}



# 1. VPC 호출
module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_cidr_2 = var.private_subnet_cidr_2
}

# 2. EC2 호출
module "ec2" {
  source = "./modules/ec2"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  ubuntu_ami = var.ubuntu_ami
  instance_type = var.instance_type
  db_endpoint = module.rds.db_endpoint
  public_subnet_ids = [module.vpc.public_subnet_id,module.vpc.public_subnet_2_id]
}


# 4. RDS 호출
module "rds" {
  source = "./modules/rds"
  project_name = var.project_name
  db_username = "kjune922"
  db_password = "dlrudalswns2!"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = [module.vpc.private_subnet_id,module.vpc.private_subnet_2_id]
  web_security_id = module.ec2.web_sg_id
}
  
