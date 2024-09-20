#!/bin/bash

# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# Instalar Nginx, Git, Python y Node.js
sudo apt install -y nginx git python3 python3-pip nodejs npm

# Habilitar el firewall para Nginx
sudo ufw allow 'Nginx Full'

# Clonar los repositorios de las APIs
mkdir -p /var/www
cd /var/www
git clone https://github.com/tu-usuario/api-python.git
git clone https://github.com/tu-usuario/api-node.git

# Configurar y ejecutar la API de Python
cd /var/www/api-python
pip3 install -r requirements.txt
nohup python3 app.py &

# Configurar y ejecutar la API de Node.js
cd /var/www/api-node
npm install
nohup npm start &

# Configurar Nginx para hacer proxy inverso a las APIs
cat <<EOT >> /etc/nginx/sites-available/api
server {
    listen 80;

    location /ai-service {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /geo-legacy {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

EOT

# Enlazar la configuración de Nginx y reiniciar
sudo ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled/
sudo systemctl restart nginx
