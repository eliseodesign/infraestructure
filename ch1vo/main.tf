terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  description = "El token de API de DigitalOcean"
  type        = string
}

variable "ssh_key_id" {
  description = "ID de la clave SSH en DigitalOcean"
  type        = string
}

variable "db_user" {
  description = "Usuario de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
}

# Crear el Droplet
resource "digitalocean_droplet" "apich1vo" {
  name   = "apich1vo"
  region = "sfo2"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-20-04-x64"

  ssh_keys = [var.ssh_key_id]

  tags = ["api", "production"]
}

# Crear el Proyecto ch1vo
resource "digitalocean_project" "ch1vo" {
  name        = "ch1vo"
  description = "Proyecto para la API de ch1vo"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [digitalocean_droplet.apich1vo.urn]
}

# Crear el Firewall para proteger el Droplet
resource "digitalocean_firewall" "ch1vo_firewall" {
  name = "ch1vo-firewall"

  # Aplica el firewall al droplet
  droplet_ids = [digitalocean_droplet.apich1vo.id]

  # Permitir SSH (puerto 22)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Permitir HTTP (puerto 80)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Permitir HTTPS (puerto 443)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Permitir acceso a la base de datos (puerto 5432 para PostgreSQL, por ejemplo)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "5432"
    source_addresses = ["0.0.0.0/0", "::/0"]  # O especifica las direcciones permitidas
  }

  # Reglas de salida permitiendo todo el tráfico saliente
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
