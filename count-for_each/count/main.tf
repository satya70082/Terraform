provider "aws" {
  region = "us-east-1"
  
}
#without list variable
#resource "aws_instance" "server" {
  #ami = "ami-0453ec754f44f9a4a"
    #instance_type = "t2.micro"
    #key_name = "satyayt"
    #count = 2
    #tags = {
        #Name = "dev"
        #Name = "dev-${count.index}"
        
#}
#}
 #with variables list of string
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
    default = ["dev","prod"]
 }
 resource "aws_instance" "dev" {
   ami =var.ami
   instance_type = var.instance_type
   key_name = "satyayt"
   count =length(var.list)
   tags  ={
    Name =var.list[count.index]
   }
 }
 #crating multiple users
 #variable "iam_user" {
  # description = "The name of the IAM user"
  # type = list(string)
  # default = ["user1", "user2"]
 #}
 #resource "aws_iam_user" "user" {
  # count = length(var.iam_user)
   #name = var.iam_user[count.index]
 #}