provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo_server" {
  ami           = "ami-02457590d33d576c3"
  instance_type = "t2.micro"
  key_name      = "terra"
  # security_groups = [aws_security_group.demo-sg.name]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id = aws_subnet.dpp-public-subnet-01.id
}

resource "aws_security_group" "demo-sg" {  # Fixed closing quote
  name        = "demo-sg"
  description = "SSH and HTTP access"
  tags = {
    Name = "demo-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.demo-sg.id  # Corrected reference
  cidr_ipv4         = "0.0.0.0/0"  # Fixed syntax
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demo-sg.id  # Corrected reference
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpp-vpc"
  }
}

resource "aws_subnet" "dpp-public-subnet-01" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "dpp-public-subnet-01"
  }
}

resource "aws_subnet" "dpp-public-subnet-02" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dpp-public-subnet-02"
  }
}

resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id
  tags = {
    Name = "dpp-igw"
  }
}

resource "aws_route_table" "dpp-public-route-table" {
  vpc_id = aws_vpc.dpp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp-igw.id
  }
  tags = {
    Name = "dpp-public-route-table"
  }
}

resource "aws_route_table_association" "dpp-public-subnet-01-association" {
  subnet_id = aws_subnet.dpp-public-subnet-01.id
  route_table_id = aws_route_table.dpp-public-route-table.id
}

resource "aws_route_table_association" "dpp-public-subnet-02-association" {
  subnet_id = aws_subnet.dpp-public-subnet-02.id
  route_table_id = aws_route_table.dpp-public-route-table.id
}