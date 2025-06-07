provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-02457590d33d576c3"
  instance_type = "t2.micro"
key_name = "terra"
  security_groups = [aws_security_group.demo-sg.id]
}

resource "aws_security_group" "demo-sg {
  name        = "demo-sg"
  description = "SSH and HTTP access"
  tags = {
    Name = "demo-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = ["0.0.0.0/0"]
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
