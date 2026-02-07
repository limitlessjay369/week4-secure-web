terraform {
  backend "s3" {
    bucket         = "week4-terraform-state-jaytwitty"
    key            = "week4-secure-web/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "week4-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}