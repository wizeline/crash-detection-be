variable "aws_region" {
  description = "AWS region"
}

variable "prefix" {
  description = "Prefix for all names"
}

variable "s3_raw_videos_bucket_name" {
  description = "S3 bucket for raw videos"
}

variable "s3_chunked_videos_bucket_name" {
  description = "S3 buicket for chunked videos"
}

variable "ecr_chunk_videos_repository_name" {
  description = "ECR repository for chunk video lambda"
}

variable "lambda_chunk_videos_function_name" {
  description = "AWS Lambda function name for chunk videos"
}

variable "lambda_detect_collision_function_name" {
  description = "AWS Lambda function name for detect collision"
}
variable "ecr_detect_collission_repository_name" {
  description = "ECR repository for detect collision lambda"
}

variable "lambda_function_role" {}

variable "lambda_s3_policy" {}

variable "src_dir" {
  default = "../src"
}

variable "target_dir" {
  default = "../target"
}

variable "package_dir" {
  default = "../target/pkg"
}
