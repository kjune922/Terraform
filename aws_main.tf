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
    rds = "http://localhost:4566"
  }
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
  subnet_id = module.vpc.public_subnet_id
  ubuntu_ami = var.ubuntu_ami
  instance_type = var.instance_type
  db_private_ip = module.db.db_private_ip
}

# 3. DB 호출 (일단그냥둠)
module "db" {
  source = "./modules/db"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  ubuntu_ami = var.ubuntu_ami
  instance_type = var.instance_type
  web_security_id = module.ec2.web_sg_id
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
  
