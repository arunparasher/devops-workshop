provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-02457590d33d576c3"
  instance_type = "t2.micro"
  key_name = "terra"
}