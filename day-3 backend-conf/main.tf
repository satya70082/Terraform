resource "aws_instance" "local" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.local-subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
associate_public_ip_address = "true"
  tags = {
    Name = "terraform-instance"
  }
}
#vpc
resource "aws_vpc" "local-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "local-vpc"
  }
}
#subnet
resource "aws_subnet" "local-subnet" {
  vpc_id = aws_vpc.local-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "local-subnet"
  }
  
} 
#internet gateway
resource "aws_internet_gateway" "local-igw" {
    vpc_id = aws_vpc.local-vpc.id
    tags = {
      Name = "local-igw"
    }
}
  

#route table
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
#subnet association
resource "aws_route_table_association" "local-rt" {
  subnet_id = aws_subnet.local-subnet.id
  route_table_id = aws_route_table.local-route.id
}
#security group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.local-vpc.id
  name = "allow-ssh-http"

  tags = {
    Name = "sg"
  }

  ingress {
    description = "Allow SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  
    ingress {
      description = "Allow HTTP from VPC"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      description = "Allow all traffic out"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}