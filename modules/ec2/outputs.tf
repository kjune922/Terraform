
output "web_sg_id" {
  description = "DB 보안그룹에서 참조할 Web서버의 보안그룹 id"
  value = aws_security_group.lee_sg.id
}

# 이제는 인스턴스 ip대신 로드밸런서 주소를 봐야 접속가능
output "alb_dns_name" {
  value = aws_lb.lee_alb.dns_name
}

