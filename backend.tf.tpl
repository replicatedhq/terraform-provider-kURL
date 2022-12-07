terraform {
  backend "s3" {
    bucket = "$S3_NAME"
    region = "$S3_REGION"
    key    = "kurl-terraform-aws/terraform.tfstate"
  }
}
