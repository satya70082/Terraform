provider "aws" {
  region = "us-east-1"
}

# Key Pair
resource "aws_key_pair" "test" {
  key_name   = "public"
  public_key = file("C:/Users/satya/.ssh/id_rsa.pub")
}

# VPC
resource "aws_vpc" "local-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "local-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.local-vpc.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "local-igw" {
  vpc_id = aws_vpc.local-vpc.id
  tags = {
    Name = "local-igw"
  }
}

# Public Route Table
resource "aws_route_table" "local-route" {
  vpc_id = aws_vpc.local-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.local-igw.id
  }

  tags = {
    Name = "local-route"
  }
}

# Public Subnet Route Table Association
resource "aws_route_table_association" "local-rt" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.local-route.id
}

# Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.local-vpc.id
  name   = "allow-ssh-http"

  tags = {
    Name = "sg"
  }

  ingress {
    description = "Allow SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.test.key_name
  subnet_id             = aws_subnet.public-subnet.id
  security_groups       = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "web-server"
    }
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/satya/.ssh/id_rsa")
      host        = self.public_ip
    }
    provisioner "local-exec" {
      command = "touch file.txt"
    }
    provisioner "remote-exec" {
      inline = [
        "touch file200",
"echo hello from aws >> file200",
      ]
    }
    provisioner "file" {
      source = "file10"
destination = "/home/ubuntu/file10"
    }
}

  
