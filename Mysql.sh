
# Actualizar repositorios
apt update -y

# Instalar Apache, PHP, MariaDB y extensiones necesarias
apt install -y apache2 php libapache2-mod-php mariadb-server php-mysql php-mbstring php-zip php-gd php-json php-curl unzip wget

# Habilitar y arrancar servicios
systemctl enable apache2
systemctl start apache2
systemctl enable mariadb
systemctl start mariadb

# Crear base de datos y usuario en MariaDB
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS gestion_usuarios;
CREATE USER IF NOT EXISTS 'alexandro'@'%' IDENTIFIED BY 'alexandro';
GRANT ALL PRIVILEGES ON gestion_usuarios.* TO 'alexandro'@'%';
FLUSH PRIVILEGES;
EOF

# Permitir conexiones remotas a MariaDB (desde la VM Apache)
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb

# Preconfigurar phpMyAdmin para instalacion silenciosa
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# Instalar phpMyAdmin sin interaccion
apt install -y phpmyadmin

# Habilitar extensiones PHP necesarias
phpenmod mbstring
systemctl restart apache2

# Permitir acceso remoto a phpMyAdmin (opcional)
sed -i 's/Require local/Require all granted/' /etc/apache2/conf-available/phpmyadmin.conf
systemctl restart apache2

echo " Instalacion completada. Accede a phpMyAdmin en: http://localhost:8081/phpmyadmin"
