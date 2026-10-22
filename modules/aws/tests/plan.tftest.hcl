# Offline plan tests: the AWS provider is mocked, so no account or credentials are needed.
mock_provider "aws" {}

run "network_and_lb_shape" {
  command = plan

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected one public subnet per availability zone."
  }

  assert {
    condition     = aws_lb.this.load_balancer_type == "application" && aws_lb.this.drop_invalid_header_fields
    error_message = "Expected an ALB that drops invalid header fields."
  }

  assert {
    condition     = aws_lb_listener.https.ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    error_message = "HTTPS listener must use a TLS 1.2+ policy."
  }
}

run "bucket_is_private_and_versioned" {
  command = plan

  assert {
    condition = (
      aws_s3_bucket_public_access_block.artifacts.block_public_acls &&
      aws_s3_bucket_public_access_block.artifacts.block_public_policy &&
      aws_s3_bucket_public_access_block.artifacts.ignore_public_acls &&
      aws_s3_bucket_public_access_block.artifacts.restrict_public_buckets
    )
    error_message = "All four public access blocks must be on."
  }

  assert {
    condition     = aws_s3_bucket_versioning.artifacts.versioning_configuration[0].status == "Enabled"
    error_message = "Bucket versioning must be enabled."
  }
}

run "needs_two_azs" {
  command = plan

  variables {
    availability_zones  = ["us-east-1a"]
    public_subnet_cidrs = ["10.30.1.0/24"]
  }

  expect_failures = [var.availability_zones]
}
