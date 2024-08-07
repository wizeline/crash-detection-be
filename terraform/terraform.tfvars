# AWS
aws_region="eu-west-1"

# Prefix to be applied to all aws name resoureces created
prefix="cdf"

# S3
s3_raw_videos_bucket_name="wizeline-video-raw"
s3_chunked_videos_bucket_name="wizeline-video-chunks"

# ECR
ecr_chunk_videos_repository_name="chunk-videos"
ecr_detect_collission_repository_name="detect-collision"

# Lambda
lambda_function_role="lambda_function_role"
lambda_s3_policy="lambda_s3_policy"

lambda_chunk_videos_function_name="chunk_videos"
lambda_detect_collision_function_name="detect_collision"