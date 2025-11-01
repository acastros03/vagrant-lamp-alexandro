# 🧱 Pila LAMP en Dos Niveles


## 📘 Descripción General
Este proyecto implementa una infraestructura de **dos niveles** utilizando **Vagrant** y **Debian 12 (Bookworm)**. Se despliega una aplicación de gestión de usuarios, separando los servicios web (Apache + PHP) y base de datos (MariaDB) en dos máquinas virtuales.

---

## 📦 Estructura del Proyecto

```
vagrant-lamp-alexandro/
├── Vagrantfile
├── Apache.sh
├── Mysql.sh
├── README.md
└── Imagen/
    ├── Apache.png
    └── PhpMyAdmin.png
```

---
### 🧩 Arquitectura

| Máquina            | Rol                     | IP Privada      | Acceso a Internet | Puerto local |
|------------------|------------------------|----------------|-----------------|--------------|
| AlexandroApache   | Servidor Web (Apache + PHP) | 192.168.1.5   | ✅ (NAT)         | 8080 → 80   |
| AlexandroMysql    | Servidor BD (MariaDB + PhpMyAdmin) | 192.168.1.6 | ❌               | 8081 → 80, 3306 → 3306 |

---

## ⚙️ Vagrantfile
```ruby
Vagrant.configure("2") do |config|

  # Servidor Apache
  config.vm.define "AlexandroApache" do |apache|
    apache.vm.box = "debian/bookworm64"
    apache.vm.hostname = "AlexandroApache"

    # Red privada compartida
    apache.vm.network "private_network", ip: "192.168.1.5"

    # Reenvio de puertos
    apache.vm.network "forwarded_port", guest: 80, host: 8080

    # Aprovisionamiento automatico
    apache.vm.provision "shell", path: "Apache.sh"
  end

  # Servidor MySQL 
  config.vm.define "AlexandroMysql" do |mysql|
    mysql.vm.box = "debian/bookworm64"
    mysql.vm.hostname = "AlexandroMysql"

    # Red privada compartida
    mysql.vm.network "private_network", ip: "192.168.1.6"

    # Reenvio opcional
    mysql.vm.network "forwarded_port", guest: 80, host: 8081

    # Acceso remoto MySQL desde host
    mysql.vm.network "forwarded_port", guest: 3306, host: 3306

    # Aprovisionamiento automatico
    mysql.vm.provision "shell", path: "Mysql.sh"
  end

```

---

## 🖥️ Scripts de Aprovisionamiento

### 🔹 Apache.sh
```bash
# Actualizar sistema
apt update -y

# Instalar Apache y PHP
apt install -y apache2 php libapache2-mod-php php-mysql unzip wget git

# Limpiar contenido previo
rm -rf /var/www/html/*

# Descargar la aplicacion de ejemplo (gestion de usuarios)
cd /var/www/html
git clone https://github.com/iesalbarregas/gestion-usuarios.git app
mv app/* .
rm -rf app

# Asignar permisos
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Reiniciar Apache
systemctl restart apache2

```

### 🔹 Mysql.sh
```bash
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

echo "Instalacion completada. Accede a phpMyAdmin en: http://localhost:8081/phpmyadmin"
```

---

## 🌐 Accesos
- **Apache:** http://localhost:8080
- **MariaDB / phpMyAdmin:** http://localhost:8081/phpmyadmin
- **Usuario DB:** `alexandro`  
- **Contraseña DB:** `alexandro`
---

## 📸 Comprobacion
- Apache
  
 ![Apache funcionando](Imagen/Apache.png)

- PhpMyAdmin

 ![PhpMyAdmin funcionando](Imagen/PhpMyAdmin.png)

 - Video

    <a href="https://drive.google.com/file/d/1fe8vetvKCYnkI0j7P0l-yU1Yo8AcpSjB/view?usp=drive_link" target="_blank">Ver video en Google Drive</a>




