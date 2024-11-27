#iam user
resource "aws_iam_user" "user" {
  name = var.user
}
# IAM Role
resource "aws_iam_role" "role" {
  name               = var.role
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
})
tags = {
   Name = var.role
}
}
#iam custom policy
resource "aws_iam_policy" "policy" {
  name = var.policy
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"ec2:*"
			],
			"Resource": [
				"*"
			]
		}
	]
})
}

#attach iam policy to user
resource "aws_iam_user_policy_attachment" "user_admin_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
# attach iam policy to role
resource "aws_iam_role_policy_attachment" "role_admin_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create an IAM group
resource "aws_iam_group" "example_group" {
  name = "group"
}
# Attach the full access policy to the group
resource "aws_iam_group_policy_attachment" "attach_full_access" {
  group      = aws_iam_group.example_group.name
  policy_arn = aws_iam_policy.policy.arn
}
# Add the user to the group
resource "aws_iam_user_group_membership" "user_group" {
  user = aws_iam_user.user.name
  groups = [
    aws_iam_group.example_group.name
  ]
}

#provider "aws" {
  #region = "us-east-1"
  
#}
#resource "aws_iam_user" "user" {
 # name = "user1"
#}
#resource "aws_iam_user_policy_attachment" "user_admin_attachment" {
 # user       = aws_iam_user.user.name
 # policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#}
