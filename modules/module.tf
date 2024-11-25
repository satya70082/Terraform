module "dev" {
  source = "../basic-ec2"
  ami = "ami-012967cc5a8c9f891"
  instance_type = "t2.micro"
    key_name = "satyayt"
    availability_zone = "us-east-1a"
}