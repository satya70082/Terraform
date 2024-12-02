provider "aws" {
  region = "us-east-1"
}
variable "create_bucket" {
  description = "value to create bucket"
  type = bool
  default = true
}
resource "random_string" "suffix" {
  count = var.create_bucket ? 1 : 0
  length = 8
    upper = false
    special = false
}
resource "aws_s3_bucket" "bucket" {
  count = var.create_bucket ? 1 : 0
  bucket = "mybucket-${random_string.suffix[count.index].id}"
    acl    = "private"
    tags = {
      Name = "conditional bucket"
      Environment = "dev"
    }
}
output "name" {
  value = aws_s3_bucket.bucket[0].bucket
  
}
#input_vars
#terraform apply -var="ami=ami-0440d3b780d96b29d" -var="instance_type=t2.micro"
#insert varaibles while apply time