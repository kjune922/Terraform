output "public_ip" {
	description = "생성된 EC2의 퍼블릭 IP"
	value = module.ec2.public_ip
}

output "instance_id" {
	description = "EC2 인스턴스 ID"
	value = module.ec2.instance_id
}

output "private_subnet_2_id" {
  description = "프라이빗 서브넷2의 id"
  value = module.vpc.private_subnet_2_id
}
