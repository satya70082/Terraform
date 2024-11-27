provider "aws" {
  region = "us-east-1"
  
}
resource "aws_instance" "server" {
  ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.micro"
    key_name = "satyayt"
    user_data = file("script.sh")
    tags = {
    Name = "terraform-server"
}
}