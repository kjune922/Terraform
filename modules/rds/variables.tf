variable "project_name" {
  description = "프로젝트 이름"
  type = string
}

variable "vpc_id" {
  description = "어느 동네에 DB만들꺼?"
  type = string
}

variable "private_subnet_ids" {
  description = "어느 구역에 DB만들꺼?"
  type = list(string) # 이렇게 하면 여러개를 받을수있음
}

variable "web_security_id" {
  description = "Web_sg_id가 달린애들만 db가 받겠다?"
  type = string
}

variable "db_username" {
  description = "db 사용자이름"
  type = string
}

variable "db_password" {
  description = "db 비밀번호"
  type = string
}

