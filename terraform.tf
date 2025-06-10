terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
  }
}

# backend code to store the tfstate file and lock it when one accessing/editing
terraform {
  backend "s3" {
    bucket         = "tws-resources-tfstate-storage-bucket"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "TWS-resources-tfstate-s3-locking-table"
  }
}