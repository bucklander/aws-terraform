resource "aws_s3_bucket" "alb-logs-d82h" {
  bucket = "alb-logs-d82h"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  tags = {
    Name = "ALB Access Logs"
  }
}
