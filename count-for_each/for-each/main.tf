provider "aws" {
  region = "us-east-1"
  
}
variable "ami" {
   type = string
    default = "ami-0453ec754f44f9a4a"
 }
 variable "instance_type" {
   type = string
    default = "t2.micro"
   
 }
 variable "list" {
   type =list(string)
   default = [ "dev","prod","test"] 
 }
 resource "aws_instance" "dev" {
   ami =var.ami
   instance_type = var.instance_type
   key_name = "satyayt"
   for_each = toset(var.list)
   tags = {
     Name =each.value
   }
  }
  