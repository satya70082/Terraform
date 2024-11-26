variable "ami" {
  description = "The AMI to use for the instance"
    default =  "ami-0453ec754f44f9a4a"
  
}
variable "region" {
  description = "The region to launch the instance"
    default = "us-east-1"
  
}
variable "profile" {
  description = "The profile to use for the instance"
    default = "kk"
  
}
variable "instance_type" {
  description = "The type of instance to launch"
    default = "t2.micro"
  
}