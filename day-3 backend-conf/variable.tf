variable "region" {
  description = "The AWS region to deploy resources"
  default     = "ap-south-1"
  
}
variable "ami" {
  description = "The AMI to use for the instance"
  default     = ""
  
}
variable "key_name" {
  description = "The key pair name to use for the instance"
  default     = ""
  
}
variable "instance_type" {
  description = "The instance type to use for the instance"
  default     = ""
  
}