module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "satyayt"
  monitoring             = true
  subnet_id              = "subnet-024724dae4895cf40"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}