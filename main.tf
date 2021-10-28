terraform {
  required_version = "~> 1.0.9"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "dustinalandzes"

    workspaces {
      name = "personal-terraform"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
}

resource "digitalocean_droplet" "gibson_droplet" {
  name   = "seafile-gibson"
  region = "sfo2"
  tags = [
  "seafile"]
  count             = "1"
  size              = "s-2vcpu-4gb"
  image             = "56427524"
  backups           = true
  graceful_shutdown = false
}

resource "digitalocean_firewall" "gibson_firewall" {
  name = "gibson-firewall"
  tags = [
  "seafile"]
  count = "1"
  inbound_rule {
    port_range = "22"
    protocol   = "tcp"
    source_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
  inbound_rule {
    port_range = "443"
    protocol   = "tcp"
    source_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
  }
  inbound_rule {
    port_range = "80"
    protocol   = "tcp"
    source_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  outbound_rule {
    destination_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
    protocol = "icmp"
  }
  outbound_rule {
    destination_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
    port_range = "all"
    protocol   = "tcp"
  }
  outbound_rule {
    destination_addresses = [
      "0.0.0.0/0",
      "::/0",
    ]
    port_range = "all"
    protocol   = "udp"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "joplin" {
  acl = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_iam_user" "joplin" {
  name = "joplin-s3-bucket-user"
}

resource "aws_iam_access_key" "joplin" {
  user = aws_iam_user.joplin.name
}

resource "aws_iam_user_policy" "joplin" {
  name = "joplin-s3-bucket-user-policy"
  user = aws_iam_user.joplin.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect : "Allow",
        Action : [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.joplin.arn,
          "${aws_s3_bucket.joplin.arn}/*",
        ]
      }
    ]
  })
}