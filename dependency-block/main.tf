provider "aws" {
  region = "us-east-1"
  
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "gkjnkjpokjk"
  depends_on = [ aws_instance.dev ]
}
resource "aws_instance" "dev" {
    ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.micro"
}