# Joplin S3 Bucket Terraform Module

<img width="64" src="https://raw.githubusercontent.com/laurent22/joplin/dev/Assets/LinuxIcons/256x256.png" /> 
<img width="64 src="https://registry.terraform.io/images/providers/aws.png" />
<img width="64" src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Amazon-S3-Logo.svg/218px-Amazon-S3-Logo.svg.png" />

This is a repository for a Terraform module that creates an AWS S3 bucket, along with an IAM user that only has access to that bucket.

It will output the bucket, access key and secret you need to add to Joplin.

[Terraform Registry](https://registry.terraform.io/modules/DustinAlandzes/joplin-s3-bucket/aws/latest)

## usage

Copy and paste into your Terraform configuration, and run terraform init:
```hcl
module "joplin-s3-bucket" {
  source  = "DustinAlandzes/joplin-s3-bucket/aws"
  version = "0.1.0"
}
```

To get outputs, you can modify your outputs.tf to look like this:
```hcl
output "joplin_s3_bucket" {
  value       = module.joplin-s3-bucket.joplin_s3_bucket
  description = "The S3 bucket's name"
}

output "joplin_aws_key" {
  value       = module.joplin-s3-bucket.joplin_aws_key
  description = "AWS key in Joplin"
}

output "joplin_aws_secret" {
  value       = module.joplin-s3-bucket.joplin_aws_secret
  description = "AWS secret in Joplin"
  sensitive   = true
}
```

I use this with Terraform cloud. You can register a free account, create an organization and workspace, set the `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY` environment variables and make your terraform block look like this:
```hcl
terraform {
  required_version = "~> 1.0.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "my-organization"

    workspaces {
      name = "my-terraform-workspace"
    }
  }
}
```

Because `joplin_aws_secret` is marked as sensitive you'll need to get it from the state (The State tab in terraform cloud).

## documentation

https://github.com/laurent22/joplin#s3-synchronisation

