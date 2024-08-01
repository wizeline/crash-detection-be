# Create a ZIP archive of the Lambda function code
data "archive_file" "chunk_videos_lambda_zip" {
  type        = "zip"
  source_dir  = "${var.package_dir}/"
  output_path = "${var.target_dir}/chunk_videos_lambda_function.zip"
}

# Create the Lambda function
resource "aws_lambda_function" "chunk_videos_lambda" {
  filename         = "${var.target_dir}/chunk_videos_lambda_function.zip"
  function_name    = "chunk_videos_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "chunk_videos_lambda_function.lambda_handler"
  source_code_hash = data.archive_file.chunk_videos_lambda_zip.output_base64sha256
  runtime          = "python3.8"
  timeout     = 10
  memory_size = 128
  environment {
    variables = {
      CHUNKS_BUCKET = aws_s3_bucket.chunked_videos_bucket.id
    }
  }
}

resource "aws_lambda_permission" "allow_s3_to_call_chunk_videos_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chunk_videos_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw_videos_bucket.arn
}
