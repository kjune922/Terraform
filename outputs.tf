
output "private_subnet_2_id" {
  description = "프라이빗 서브넷2의 id"
  value = module.vpc.private_subnet_2_id
}

output "alb_dns_name" {
  value = module.ec2.alb_dns_name
}

