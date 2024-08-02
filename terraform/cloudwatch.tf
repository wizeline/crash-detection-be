
# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "chunk_videos_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.chunk_videos_lambda.function_name}"
  retention_in_days = 14
}

# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "detect_collision_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.detect_collision_lambda.function_name}"
  retention_in_days = 14
}
