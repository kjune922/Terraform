output "instance_id" {
  description = "생성된 EC2 인스턴스의 ID"
  value       = aws_instance.lee_app.id
}

output "public_ip" {
  description = "생성된 EC2의 퍼블릭 IP"
  value       = aws_instance.lee_app.public_ip
}
