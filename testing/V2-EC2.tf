provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-02457590d33d576c3"
  instance_type = "t2.micro"
  key_name      = "terra"
  security_groups = [aws_security_group.demo-sg.name]
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