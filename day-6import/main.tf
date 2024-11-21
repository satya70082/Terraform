resource "aws_instance" "satya" {
  ami = "ami-0aebec83a182ea7ea"
    instance_type = "t2.micro"

}
resource "aws_s3_bucket" "name" {
  bucket = "satya-terraform-bucket"
}