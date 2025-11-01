
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
