resource "aws_s3_bucket" "raw_videos_bucket" {
  bucket = var.raw_videos_bucket_name
}

resource "aws_s3_bucket" "chunked_videos_bucket" {
  bucket = var.chunked_videos_bucket_name
}

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_function_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda execution policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create a policy for S3 read and write access to both buckets
resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda_s3_policy"
  path        = "/"
  description = "IAM policy for Lambda S3 access to raw and chunks buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.raw_videos_bucket.arn}/*",
          "${aws_s3_bucket.chunked_videos_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = [
          aws_s3_bucket.raw_videos_bucket.arn,
          aws_s3_bucket.chunked_videos_bucket.arn
        ]
      }
    ]
  })
}

# Attach S3 policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
  role       = aws_iam_role.lambda_role.name
}

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

# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.chunk_videos_lambda.function_name}"
  retention_in_days = 14
}

resource "aws_s3_bucket_notification" "raw_videos_bucket_notification" {
  bucket = aws_s3_bucket.raw_videos_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.chunk_videos_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }

  depends_on = [aws_lambda_permission.allow_s3_to_call_lambda]
}

resource "aws_lambda_permission" "allow_s3_to_call_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chunk_videos_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw_videos_bucket.arn
}


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
