resource "aws_ecr_repository" "app" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "IMMUTABLE"

  tags = {
    Name = var.repository_name
  }
}

