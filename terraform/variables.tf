variable "region" {
  default = "eu-west-1"
}

variable "raw_videos_bucket_name" {
  default = "wizeline-cdf-video-raw"
}

variable "chunked_videos_bucket_name" {
  default = "wizeline-cdf-video-chunks"
}

variable "src_dir" {
  default = "../src"
}

variable "target_dir" {
  default = "../target"
}

variable "package_dir" {
  default = "../target/pkg"
}