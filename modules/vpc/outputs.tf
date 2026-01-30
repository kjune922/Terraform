output "vpc_id" {
  description = "생성된 vpc의 아이디"
  value = aws_vpc.lee_vpc.id
}

output "public_subnet_id" {
  description = "생성된 퍼블릭 서브넷 아이디"
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "생성된 프라이빗 서브넷 아이디"
  value = aws_subnet.private_subnet.id
}
