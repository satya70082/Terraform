variable "region" {
  description = "AWS region"
  default = "us-east-1"
  
}
variable "instance_type" {
  description = "EC2 instance type"
  default = ""
  
}
variable "key_name" {
  description = "EC2 key pair name"
  default = ""
  
}
variable "ami" {
  description = "AMI ID"
  default = ""
  
}
variable "availability_zone" {
  description = "Availability zone"
  default = ""
  
}