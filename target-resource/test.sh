#!/bin/bash
resources=(
  "aws_s3_bucket.bucket"
  "aws_instance.server"
)

for resource in "${resources[@]}"; do
  targets+=" -target=$resource"
done

terraform apply $targets
