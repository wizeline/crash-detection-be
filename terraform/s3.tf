
# Create raw videos bucket
resource "aws_s3_bucket" "raw_videos_bucket" {
  bucket = "${var.prefix}${var.s3_raw_videos_bucket_name}"
}

# Create chunked videos bucket
resource "aws_s3_bucket" "chunked_videos_bucket" {
  bucket = "${var.prefix}${var.s3_chunked_videos_bucket_name}"
}
