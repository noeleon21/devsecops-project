terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket_name" {
  bucket = var.s3_name
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_object" "object_name" {
  bucket = aws_s3_bucket.bucket_name.id
  key    = var.s3_website
  source = var.s3_source
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.bucket_name.id

  index_document {
    suffix = aws_s3_object.object_name.id
  }

  error_document {
    key = "error.html"
  }

}



data "aws_iam_policy_document" "public_read" {
  statement {
    actions = ["s3:GetObject"]
  
    principals {
      type        = "*"
      identifiers = ["*"]
     
    }
    resources = [
      "${aws_s3_bucket.bucket_name.arn}/*"
    
    ]
    effect = "Allow"
   
  }
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.bucket_name.id
  policy = data.aws_iam_policy_document.public_read.json
}
