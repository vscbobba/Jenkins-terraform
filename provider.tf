terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
  backend "s3" {
   bucket = "terraform-project-1-2024"
   key = "state/terraform.tfstate"
   region = "us-east-1"
   encrypt = true
   dynamodb_table = "2024"
  }
}

provider "aws" {
    region = "us-east-1"
}
