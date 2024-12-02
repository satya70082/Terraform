provider "aws" {
  region = "us-east-1"
  
}
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "lambda-bucket-satya"
  force_destroy = true

  tags = {
    Name = "LambdaBucket"
  }
}

# Configure public access block for the bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket_access_block" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



#upload lambda code to s3 bucket
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "lambda-function.zip"
  source = "lambda-function.zip"
  etag = filemd5("lambda-function.zip")
}
#iam role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
#attach policy to iam role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
#lambda function
resource "aws_lambda_function" "lambda" {
  function_name = "lambda-function"
  runtime = "python3.9"
  role = aws_iam_role.lambda_role.arn
   handler = "lambda-function.lambda_handler"

    s3_bucket = aws_s3_bucket.lambda_bucket.id
    s3_key = aws_s3_object.lambda_code.key
    timeout = 20
    memory_size = 128
    environment {
         variables = {
      ENV_VAR_KEY = "ENV_VAR_VALUE" # Example environment variable
    }
    }
    tags = {
      Name = "lambda-function"
    }
}
