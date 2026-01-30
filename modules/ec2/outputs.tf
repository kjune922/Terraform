output "instance_id" {
  description = "생성된 EC2 인스턴스의 ID"
  value       = aws_instance.lee_app.id
}

output "public_ip" {
  description = "생성된 EC2의 퍼블릭 IP"
  value       = aws_instance.lee_app.public_ip
}

output "web_sg_id" {
  description = "DB 보안그룹에서 참조할 Web서버의 보안그룹 id"
  value = aws_security_group.lee_sg.id
}
