#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SRC_DIR=$SCRIPT_DIR/../src

cd $SCRIPT_DIR/
terraform init
terraform refresh

# Uncomment when the buckets already exists in AWS and you get a "BucketAlreadyOwnedByYou" 
#terraform import aws_s3_bucket.raw_videos_bucket cdfwizeline-video-raw 
#terraform import aws_s3_bucket.chunked_videos_bucket cdfwizeline-video-chunks 


# Uncomment when │ Error: creating IAM Policy (lambda_s3_policy): EntityAlreadyExists: A policy called lambda_s3_policy already exists. Duplicate names are not allowed.
#terraform import aws_iam_policy.lambda_s3_policy arn:aws:iam::058264526494:policy/cdflambda_s3_policy

# Uncomment when │ Error: creating IAM Role (lambda_function_role): EntityAlreadyExists: Role with name lambda_function_role already exists.
#terraform import aws_iam_role.lambda_role arn:aws:iam::058264526494:role/cdflambda_function_role

terraform apply -auto-approve



