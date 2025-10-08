terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# 1. Create an S3 bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = "gocool.space" # <-- CHANGE THIS to something globally unique
}

# 2. Configure the S3 bucket for website hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# 3. Set a public access block to allow public reads
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.website_bucket.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

# 4. Apply a bucket policy to make objects publicly readable
resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.website_bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Sid       = "PublicReadGetObject"
            Effect    = "Allow"
            Principal = "*"
            Action    = "s3:GetObject"
            Resource  = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*"
        },
        ]
    })
    depends_on = [aws_s3_bucket_public_access_block.public_access]
}
