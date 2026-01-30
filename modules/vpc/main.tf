resource "aws_vpc" "lee_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
  Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.lee_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "ap-northeast-2a"

  tags = {
  Name = "${var.project_name}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.lee_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = false # 이게 프라이빗서브넷 증표
  tags = {
  Name = "${var.project_name}-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lee_vpc.id
  tags = {
    Name = "lee_igw"
    }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lee_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
    Name = "public-route-table"
    }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lee_vpc.id
  tags = {
  Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
