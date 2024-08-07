resource "aws_ecr_repository" "chunk_lambda_repo" {
  name = "${var.prefix}${var.ecr_chunk_videos_repository_name}"
}

data "aws_ecr_repository" "chunk_lambda_repo" {
  name = aws_ecr_repository.chunk_lambda_repo.name
}

resource "aws_ecr_repository" "collision_lambda_repo" {
  name = "${var.prefix}${var.ecr_detect_collission_repository_name}"
}

data "aws_ecr_repository" "collision_lambda_repo" {
  name = aws_ecr_repository.collision_lambda_repo.name
}

