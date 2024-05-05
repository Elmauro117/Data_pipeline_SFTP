

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

variable "region" {
  default = "us-east-1"
  type    = string
}

provider "aws" {
  region     = "${var.region}"
  access_key = "**********"
  secret_key = "********************"
}


/// BUCKETS
data "aws_s3_bucket" "bucket_msk" {
  bucket = "your s 3 bucket"
}

data "aws_s3_bucket" "s3_bu" {
  bucket = "your s 3 bucket"
}


