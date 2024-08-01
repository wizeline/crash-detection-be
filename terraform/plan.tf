
# Output the Lambda function ARN
output "lambda_function_arn" {
  value = aws_lambda_function.chunk_videos_lambda.arn
}

# Output the S3 bucket names
output "raw_bucket_name" {
  value = aws_s3_bucket.raw_videos_bucket.id
}

output "chunks_bucket_name" {
  value = aws_s3_bucket.chunked_videos_bucket.id
}
