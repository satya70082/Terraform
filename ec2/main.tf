resource "aws_instance" "sample-server" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    availability_zone = var.availability_zone
    tags = {
        Name = "sample-server"
    }
  
}