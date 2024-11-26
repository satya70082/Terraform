provider "aws" {
  region = "us-east-1"
  
}
resource "aws_key_pair" "test" {
  key_name = "public"

    public_key = file("C:/Users/satya/.ssh/id_rsa.pub")
}
resource "aws_instance" "server" {
  ami = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.test.key_name
  tags = {
    Name = "server"
  }
}