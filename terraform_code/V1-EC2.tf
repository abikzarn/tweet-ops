provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
  ami           = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"
  key_name      = "mine"
  subnet_id     = "subnet-066148bf06403b80b"
  security_groups = ["sg-04a4026ab15f5d163"]
  tags = {
    Name = "demo-server"
  } 

}  