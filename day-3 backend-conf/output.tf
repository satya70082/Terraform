output "public_ip" {
  value = aws_instance.sample-server.public_ip
  
}
output "ami_id" {
  value = aws_instance.sample-server.ami
  
}