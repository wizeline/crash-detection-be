resource "aws_s3_bucket" "raw_videos_bucket" {
  bucket = var.raw_videos_bucket_name
}

resource "aws_s3_bucket" "chunked_videos_bucket" {
  bucket = var.chunked_videos_bucket_name
}
