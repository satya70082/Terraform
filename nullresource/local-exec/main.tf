provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg" {
  name        = "mysecuritygroup"
  description = "Allow inbound traffic"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For testing; limit to specific IPs in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "dev" {
  filter {
    name   = "tag:Name"
    values = ["dev"]
  }
}

data "aws_subnet" "dev2" {
  filter {
    name   = "tag:Name"
    values = ["dev2"]
  }
}

resource "aws_db_subnet_group" "subnet" {
  name       = "mydbsubnetgroup"
  subnet_ids = [
    data.aws_subnet.dev.id,
    data.aws_subnet.dev2.id
  ]
}

resource "aws_db_instance" "rds" {
  identifier           = "mydbinstance"
  allocated_storage    = 20
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  engine_version       = "8.0.39"
  username             = "admin"
  password             = "admin123"
  publicly_accessible  = true  # Change to true for testing purposes
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnet.name
  vpc_security_group_ids = [aws_security_group.sg.id]
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = ["subnet-038c77dfb92712301","subnet-0643b24c87e54fa25"]
}

resource "null_resource" "db_initializer" {
  depends_on = [aws_db_instance.rds]
provisioner "local-exec" {
  command = <<EOT
  mysql -h ${aws_db_instance.rds.address} -u admin -padmin123 -e "source ./db.sql"
  EOT
}

  
  
}
  terraform {
   backend "s3" {
    bucket = "satyastatefil5276"
    key = "terraform.tfstate"
    region = "us-east-1"
   # dynamodb_table = "terraform-state-lock-dynamo"
    encrypt = true
     
   }
 }





