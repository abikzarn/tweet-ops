
# Provider =AWS
provider "aws" {
  region = "us-east-1"
}

# Create EC2 instance
resource "aws_instance" "jenkins-master" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t3.medium"
  key_name               = "mine"
  subnet_id              = aws_subnet.dpw-public_subnet_01.id
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  tags = {
    Name = "jenkins-master"
  }
}

resource "aws_instance" "ansible-build-slave" {
  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t2.micro"
  key_name               = "mine"
  subnet_id              = aws_subnet.dpw-public_subnet_01.id
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  for_each               = toset(["build-slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }
}


# Create security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.dpw-vpc.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["88.166.154.24/32"]
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

resource "aws_vpc" "dpw-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpw-vpc"
  }
}

resource "aws_subnet" "dpw-public_subnet_01" {
  vpc_id                  = aws_vpc.dpw-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dpw-public_subnet_01"
  }
}

//Creating an Internet Gateway 
resource "aws_internet_gateway" "dpw-igw" {
  vpc_id = aws_vpc.dpw-vpc.id
  tags = {
    Name = "dpw-igw"
  }
}

// Create a route table 
resource "aws_route_table" "dpw-public-rt" {
  vpc_id = aws_vpc.dpw-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpw-igw.id
  }
  tags = {
    Name = "dpw-public-rt"
  }
}

// Associate subnet with route table

resource "aws_route_table_association" "dpw-rta-public-subnet-1" {
  subnet_id      = aws_subnet.dpw-public_subnet_01.id
  route_table_id = aws_route_table.dpw-public-rt.id
}