terraform {
  required_version = "1.2.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "sos-tf-backend"
    key            = "sos-boris-task"
    region         = "eu-central-1"
    profile        = "46463132488-boris-power-user-46463132488"
    kms_key_id     = "alias/sos-boris-task-bucket-BucketKey"
    encrypt        = true
    dynamodb_table = "sos-tf-be-Lock-Table"
  }

}

provider "aws" {
  profile = "46463132488-boris-power-user-46463132488"
  region  = "eu-central-1"

  default_tags {
    tags = {
      Cluster       = var.cluster_name
      CreatedBy     = "terraform"
      SourceControl = "https://github.com/berkil/6over6"
    }
  }
}