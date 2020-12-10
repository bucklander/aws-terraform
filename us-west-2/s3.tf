resource "aws_s3_bucket" "alb-logs" {
  bucket = "alb-logs-d82h"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "ALB Access Logs"
  }
}

## The following IAM policy allows 
resource "aws_s3_bucket_policy" "alb-logs-policy" {
  bucket = aws_s3_bucket.alb-logs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.alb-logs.bucket}/AWSLogs/${var.acct_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.alb-logs.bucket}"
    }
  ]
}
POLICY
}