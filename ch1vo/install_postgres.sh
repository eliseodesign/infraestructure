#!/bin/bash

# Salir inmediatamente si un comando falla
set -e

# Archivo de log para el proceso de instalación
LOG_FILE="/var/log/install_postgres.log"

# Actualizar el sistema y arreglar cualquier problema de dependencias
echo "Actualizando el sistema y corrigiendo dependencias..." | tee -a $LOG_FILE
sudo apt-get update -y --fix-missing | tee -a $LOG_FILE
sudo apt-get upgrade -y | tee -a $LOG_FILE
sudo apt-get install -f -y | tee -a $LOG_FILE

# Agregar el repositorio oficial de PostgreSQL
echo "Agregando repositorio oficial de PostgreSQL..." | tee -a $LOG_FILE
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list' | tee -a $LOG_FILE
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - | tee -a $LOG_FILE
sudo apt-get update -y | tee -a $LOG_FILE

# Instalar PostgreSQL y PostGIS
echo "Instalando PostgreSQL y PostGIS..." | tee -a $LOG_FILE
sudo apt-get install -y postgresql-12 postgresql-12-postgis-3 | tee -a $LOG_FILE

# Verificar que PostgreSQL se haya instalado correctamente
echo "Verificando instalación de PostgreSQL..." | tee -a $LOG_FILE
if ! command -v psql &> /dev/null; then
    echo "Error: PostgreSQL no se instaló correctamente." | tee -a $LOG_FILE
    exit 1
fi

# Configurar PostgreSQL para escuchar en todas las interfaces
echo "Configurando PostgreSQL para aceptar conexiones remotas..." | tee -a $LOG_FILE
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/12/main/postgresql.conf | tee -a $LOG_FILE

# Permitir conexiones remotas desde cualquier IP
echo "Permitiendo conexiones remotas desde cualquier IP..." | tee -a $LOG_FILE
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/12/main/pg_hba.conf | tee -a $LOG_FILE

# Reiniciar PostgreSQL para aplicar cambios
echo "Reiniciando PostgreSQL..." | tee -a $LOG_FILE
sudo systemctl restart postgresql | tee -a $LOG_FILE

# Crear usuario y base de datos
DB_USER="usuario"
DB_PASSWORD="contraseña_segura"
echo "Creando usuario y base de datos..." | tee -a $LOG_FILE
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" | tee -a $LOG_FILE
sudo -u postgres psql -c "CREATE DATABASE api_db OWNER $DB_USER;" | tee -a $LOG_FILE
sudo -u postgres psql -c "CREATE EXTENSION postgis;" | tee -a $LOG_FILE

# Configurar el firewall para permitir el tráfico en el puerto 5432 (PostgreSQL)
echo "Configurando el firewall..." | tee -a $LOG_FILE
sudo ufw allow 5432/tcp | tee -a $LOG_FILE
sudo ufw allow 22/tcp | tee -a $LOG_FILE
sudo ufw --force enable | tee -a $LOG_FILE

echo "Instalación y configuración de PostgreSQL completada con éxito." | tee -a $LOG_FILE
