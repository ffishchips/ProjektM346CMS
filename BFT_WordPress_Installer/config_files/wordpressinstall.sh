#!/bin/bash
set -e  # Beendet das Skript bei Fehlern

# Update Paketliste
echo "Updating package list..."
sudo apt-get update -y 

# Installiere Apache
echo "Installing Apache..."
sudo apt install -y apache2

# Installiere PHP und MySQL Modul für PHP
echo "Installing PHP and MySQL modules..."
sudo apt install -y php libapache2-mod-php php-mysql

# Lade die neueste Version von WordPress herunter
echo "Downloading WordPress..."
cd /tmp
wget https://wordpress.org/latest.tar.gz

# Entpacke WordPress
echo "Extracting WordPress..."
tar -xvf latest.tar.gz

# Verschiebe WordPress nach /var/www/html
echo "Moving WordPress to the web directory..."
sudo mv wordpress/ /var/www/html

# Stelle sicher, dass die Rechte korrekt gesetzt sind
echo "Setting file permissions..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Apache neu starten
echo "Restarting Apache..."
sudo systemctl restart apache2

# Installiere Certbot für SSL-Zertifikate (optional)
echo "Installing Certbot for SSL..."
sudo apt install -y certbot python3-certbot-apache

# Hinweis: Certbot benötigt eine Domain für SSL, wenn du es nicht verwenden willst, kannst du es überspringen
# oder SSL später manuell einrichten, wenn du es doch benötigst.

echo "WordPress wurde erfolgreich installiert!"
echo "Zugriff auf WordPress erfolgt über die öffentliche IP-Adresse deiner EC2-Instanz."
