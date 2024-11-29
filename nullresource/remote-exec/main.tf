provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-0453ec754f44f9a4a"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_key_pair" "test" {
  key_name   = "public"
  public_key = file("c:/Users/satya/.ssh/id_rsa.pub")
}

locals {
  name = "project"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.name}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "${local.name}-subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}
}
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
  
}
resource "aws_security_group" "sg" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.vpc.id
  ingress {
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
}

resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test.key_name
  subnet_id              = aws_subnet.subnet.id
  security_groups        = [aws_security_group.sg.id]
  associate_public_ip_address = true  
  tags = {
    Name = "${local.name}-instance"
  }
}


resource "null_resource" "tests" {
  depends_on = [aws_instance.ec2]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("c:/Users/satya/.ssh/id_rsa")
      host        = aws_instance.ec2.public_ip
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}
