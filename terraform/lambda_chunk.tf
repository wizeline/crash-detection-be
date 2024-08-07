
# Local command to build and push Docker image
resource "null_resource" "docker_build_and_push_chunk" {
  triggers = {
    source_code_hash = "${filebase64sha256("${var.src_dir}/chunk/lambda_function.py")}"
  }
  provisioner "local-exec" {
    command = <<EOT
      cd ${var.src_dir}/chunk
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_ecr_repository.chunk_lambda_repo.repository_url}
      docker build -t ${var.ecr_chunk_videos_repository_name} .

      docker tag ${var.ecr_chunk_videos_repository_name} ${data.aws_ecr_repository.chunk_lambda_repo.repository_url}:latest
      docker push ${data.aws_ecr_repository.chunk_lambda_repo.repository_url}:latest
    EOT
  }
  depends_on = [ aws_ecr_repository.chunk_lambda_repo ]
}

resource "aws_lambda_function" "chunk_videos_lambda" {
  source_code_hash = "${filebase64sha256("${var.src_dir}/chunk/lambda_function.py")}"
  function_name = "${var.prefix}${var.lambda_chunk_videos_function_name}"
  image_uri     = "${data.aws_ecr_repository.chunk_lambda_repo.repository_url}:latest"
  package_type  = "Image"
  role = aws_iam_role.lambda_role.arn
  timeout     = 10
  memory_size = 128
  environment {
    variables = {
      CHUNKS_BUCKET = aws_s3_bucket.chunked_videos_bucket.id
    }
  }
  depends_on = [ null_resource.docker_build_and_push_chunk ]
}

resource "aws_lambda_permission" "allow_s3_to_call_chunk_videos_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chunk_videos_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw_videos_bucket.arn
}

resource "aws_s3_bucket_notification" "raw_videos_bucket_notification" {
  bucket = aws_s3_bucket.raw_videos_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.chunk_videos_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
  depends_on = [aws_lambda_permission.allow_s3_to_call_chunk_videos_lambda]
}

# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "chunk_videos_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.chunk_videos_lambda.function_name}"
  retention_in_days = 7
}