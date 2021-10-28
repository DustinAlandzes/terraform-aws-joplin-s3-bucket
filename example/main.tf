terraform {
  required_version = "~> 1.0.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "joplin-s3-bucket" {
  source  = "DustinAlandzes/joplin-s3-bucket/aws"
  version = "0.1.0"
}
