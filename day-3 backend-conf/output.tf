output "public_ip" {
  value = aws_instance.local.public_ip
  
}
output "ami" {
    value = var.ami
  
}