terraform {
  required_version = ">= 1.2.7, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.27.0, < 5.0.0"
    }
  }
}
