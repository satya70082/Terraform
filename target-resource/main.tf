provider "aws" {
  region = "us-east-1"
  
}
resource "aws_instance" "server" {
  ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.micro"
}
resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-bucket254"
}
#terraform apply -target=aws_s3_bucket.dependent
#terraform destroy -target=aws_s3_bucket.dependent