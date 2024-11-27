provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  region = "us-west-2"
  alias = "america"
}
resource "aws_s3_bucket" "test" {
  bucket = "del558bvsfh"
}
resource "aws_s3_bucket" "test1" {
  bucket = "fshjsjkmshtrst"
    provider = aws.america
}