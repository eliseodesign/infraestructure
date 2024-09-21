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
