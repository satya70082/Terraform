terraform {
   backend "s3" {
    bucket = "aditya7892"
    key = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
     
   }
 }