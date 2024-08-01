resource "aws_s3_bucket" "raw_videos_bucket" {
  bucket = var.raw_videos_bucket_name
}

resource "aws_s3_bucket" "chunked_videos_bucket" {
  bucket = var.chunked_videos_bucket_name
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

