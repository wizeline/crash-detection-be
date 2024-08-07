
# Local command to build and push Docker image
resource "null_resource" "docker_build_and_push_detect_collision" {
  triggers = {
    source_code_hash = "${filebase64sha256("${var.src_dir}/collision/lambda_function.py")}"
  }
  provisioner "local-exec" {
    command = <<EOT
      cd ${var.src_dir}/collision
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_ecr_repository.collision_lambda_repo.repository_url}
      docker build -t ${var.ecr_detect_collission_repository_name} .
      
      docker tag ${var.ecr_detect_collission_repository_name} ${data.aws_ecr_repository.collision_lambda_repo.repository_url}:latest
      docker push ${data.aws_ecr_repository.collision_lambda_repo.repository_url}:latest
      
    EOT
  }
  depends_on = [ aws_ecr_repository.collision_lambda_repo ]
}

resource "aws_lambda_function" "detect_collision_lambda" {
  source_code_hash = "${filebase64sha256("${var.src_dir}/collision/lambda_function.py")}"
  function_name = "${var.prefix}${var.lambda_detect_collision_function_name}"
  image_uri     = "${data.aws_ecr_repository.collision_lambda_repo.repository_url}:latest"
  package_type  = "Image"
  role = aws_iam_role.lambda_role.arn
  timeout     = 10
  memory_size = 128
  depends_on = [ null_resource.docker_build_and_push_detect_collision ]
}

resource "aws_lambda_permission" "allow_s3_to_call_collision_videos_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.detect_collision_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.chunked_videos_bucket.arn
}

resource "aws_s3_bucket_notification" "chunked_videos_bucket_notification" {
  bucket = aws_s3_bucket.chunked_videos_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.detect_collision_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
  depends_on = [aws_lambda_permission.allow_s3_to_call_collision_videos_lambda]
}

# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "collision_videos_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.detect_collision_lambda.function_name}"
  retention_in_days = 7
}