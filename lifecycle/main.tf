resource "aws_instance" "dev" {
  ami = "ami-012967cc5a8c9f891"
    instance_type = "t2.small"
    key_name = "satyayt"
    availability_zone = "us-east-1b"
    tags = {
      Name = "terraformform"
    }
    #lifecycle {
     #   ignore_changes = [ tags, ]
    #}
    #lifecycle {
     #   create_before_destroy = true 
    #}
    #lifecycle {
     #  prevent_destroy = true
   # }
}