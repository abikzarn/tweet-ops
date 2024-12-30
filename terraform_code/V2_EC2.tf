
# Provider =AWS
provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "demo-server" {
  ami             = "ami-01816d07b1128cd2d"
  instance_type   = "t2.micro"
  key_name        = "mine"
  subnet_id       = "subnet-066148bf06403b80b"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  tags = {
    Name = "demo-server"
  }

}

# Create security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh"
  }
}