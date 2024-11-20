#vpc
resource "aws_vpc" "local-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "local-vpc"
  }
}
# public-subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.local-vpc.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "public-subnet"
  }
  
} 
#private-subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.local-vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "private-subnet"
  }
}
#internet gateway
resource "aws_internet_gateway" "local-igw" {
    vpc_id = aws_vpc.local-vpc.id
    tags = {
      Name = "local-igw"
    }
}
  #elastic ip
resource "aws_eip" "lb" {
  domain = "vpc"
  tags = {
    Name = "lb"
  }
}
#nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id = aws_subnet.public-subnet.id
  tags = {
    Name = "nat"
  }
}

# public-route table
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
# private-route table
resource "aws_route_table" "private-route" {
    vpc_id = aws_vpc.local-vpc.id  
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
  
}
    tags = {
      Name = "private-route"
    }
}
# public-subnet association
resource "aws_route_table_association" "local-rt" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.local-route.id
}
# private-subnet association
resource "aws_route_table_association" "private-rt" {
  subnet_id = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route.id
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
#ec2 instance
resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.private-subnet.id
  security_groups = [aws_security_group.sg.id]
  associate_public_ip_address = "false"
  tags = {
    Name = "web-server"
  }
}
