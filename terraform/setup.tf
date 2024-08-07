terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
      version = "~> 4.0"
   }
 }
}

# Configure AWS account settings
provider "aws" {
 profile = "default"
 region  = var.aws_region
}

# Local execution
provider "null" {
 
}