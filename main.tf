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
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
}

resource "digitalocean_droplet" "gibson_droplet" {
  name              = "seafile-gibson"
  region            = "sfo2"
  tags              = ["seafile"]
  count             = "1"
  size              = "s-2vcpu-4gb"
  image             = "56427524"
  backups           = true
  graceful_shutdown = false
}

resource "digitalocean_firewall" "gibson_firewall" {
  name  = "gibson-firewall"
  tags  = ["seafile"]
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
