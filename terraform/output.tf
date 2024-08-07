# Output the S3 bucket names
output "bucket_raw_name" {
  value = aws_s3_bucket.raw_videos_bucket.id
}
output "bucket_chunked_name" {
  value = aws_s3_bucket.chunked_videos_bucket.id
}


# Output the ECR names
output "ecr_chunk_videos" {
  value = aws_ecr_repository.chunk_lambda_repo.arn
}
output "ecr_collision_videos" {
  value = aws_ecr_repository.collision_lambda_repo
}