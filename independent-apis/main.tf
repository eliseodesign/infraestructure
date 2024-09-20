# Proveedor de DigitalOcean
provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_droplet" "web_server" {
  name   = "api-droplet"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-20-04-x64"

  ssh_keys = [var.ssh_key_id]

  tags = ["api", "production"]

  # Script de inicialización (cloud-init)
  user_data = file("init.sh")
}


# Obtener la IP del Droplet
output "droplet_ip" {
  value = digitalocean_droplet.web_server.ipv4_address
}

