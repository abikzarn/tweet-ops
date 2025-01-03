

# Create EC2 instance for Jenkins
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

# Create EC2 instance for Ansible & Build Slave
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