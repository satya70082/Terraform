resource "aws_instance" "sample-server" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.local-subnet.id
    key_name = var.key_name
    associate_public_ip_address = "true"
    tags = {
        Name = "sample-server"
    }
  
}
#vpc
resource "aws_vpc" "sample-vpc" {
    cidr_block = "192.168.0.0/16"
    tags = {
        Name = "sample-vpc"
    }
}
#subnet
resource "aws_subnet" "local-subnet" {
    vpc_id = aws_vpc.sample-vpc.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-south-1a"
  
}
#internet gateway
resource "aws_internet_gateway" "sample-igw" {
    vpc_id = aws_vpc.sample-vpc.id
    tags = {
        Name = "sample-igw"
    }
}
#route table
resource "aws_route_table" "sample-route" {
  vpc_id = aws_vpc.sample-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample-igw.id
  }
}

#route table association
resource "aws_route_table_association" "sample-route-association" {
    subnet_id = aws_subnet.local-subnet.id
    route_table_id = aws_route_table.sample-route.id
}