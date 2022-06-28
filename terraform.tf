terraform {
  required_version = "1.2.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
#   profile = "boris-private"
  region  = "eu-central-1"

  default_tags {
    tags = {
      Cluster       = var.cluster_name
      CreatedBy     = "terraform"
      SourceControl = "https://github.com/berkil/6over6"
    }
  }
}