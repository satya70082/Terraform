terraform {
   backend "s3" {
    bucket = "satyastatefile125"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt = true
     
   }
 }