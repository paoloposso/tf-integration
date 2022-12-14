resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"
  acl = "tsttt"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aaaaaaa"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "bbbbbbb"
    }
  }
}

resource "aws_s3_access_point" "example" {
  bucket = aws_s3_bucket.example.id
  name   = "accesspoint-example"

  public_access_block_configuration {
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
  }

  # VPC must be specified for S3 on Outposts
  vpc_configuration {
    vpc_id = aws_vpc.example.id
  }
}

resource "aws_elb" "lb" {
  name               = "test-lb"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}