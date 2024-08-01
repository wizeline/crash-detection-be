
# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.chunk_videos_lambda.function_name}"
  retention_in_days = 14
}

