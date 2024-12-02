provider "aws" {
  region = "us-east-1"
}
#resource "aws_security_group" "sg" {
  #name = "mysecuritygroup"
  #description = "Allow inbound traffic"
 # ingress = [for port in [22,80,443,8080,3306] : {
  #  description = "Allow inbound traffic"
  #  from_port = port
   # to_port = port
   # protocol = "tcp"
   # cidr_blocks = ["0.0.0.0/0"]
   # ipv6_cidr_blocks = []
    #  prefix_list_ids  = []
     # security_groups  = []
     # self             = false
    #}]
    #egress {
      #from_port = 0
     # to_port = 0
     # protocol = "-1"
     # cidr_blocks = ["0.0.0.0/0"]
    #}
    #tags = {
     # Name = "mysecuritygroup"
    #}
#}
#for loop with diff source
#variable "ports_map" {
 # default = {
   # 22   = ["192.168.1.0/24"]    # SSH allowed from internal network
   # 80   = ["0.0.0.0/0"]         # HTTP open to all
   # 443  = ["0.0.0.0/0"]         # HTTPS open to all
   # 8080 = ["203.0.113.0/24"]    # Custom app port restricted
   # 9000 = ["10.0.0.0/16"]       # Monitoring port restricted
  #}
#}
#resource "aws_security_group" "sg" {
 # name = "mysecuritygroup"
 # description = "Allow inbound traffic"
  #ingress = [
   # for port, sources in var.ports_map : {
    #    description = "in bound for port ${port}"
    #  from_port   = port
     # to_port     = port
     # protocol    = "tcp"
     # cidr_blocks = sources
     # ipv6_cidr_blocks = []
     # prefix_list_ids  = []
     # security_groups  = []
     # self             = false
   # }
 # ]
#}
#dynamic block
resource "aws_security_group" "sg" {
  name = "mysecuritygroup"
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress"{
    for_each = var.egress_ports
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      protocol = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}