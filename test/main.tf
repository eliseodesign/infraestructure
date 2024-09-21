terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "web-1"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["bf:08:e4:37:5d:fe:c3:eb:cf:c2:28:21:8d:0c:56:fb"]
}