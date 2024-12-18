#!/bin/bash
set -e  # Beendet das Skript bei Fehlern

# Variablen definieren
source /home/ubuntu/variables.sh

# Passwörter für MySQL
MYSQL_ROOT_PASSWORD="Bojan$Fabian"
MYSQL_WP_ADMIN_USER_PASSWORD="WordpressTest"

# Update die Paketliste und installiere MySQL
echo "Aktualisiere die Paketliste..."
sudo apt update -y

echo "Installiere MySQL Server..."
sudo apt install -y mysql-server

# Sicherstellen, dass der MySQL-Dienst läuft
echo "Starte MySQL-Dienst..."
sudo systemctl start mysql
sudo systemctl enable mysql

# MySQL Benutzer und Datenbank erstellen
echo "Erstelle Datenbank 'wordpress' und Benutzer 'wpadmin'..."
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpadmin'@'%' IDENTIFIED BY '${MYSQL_WP_ADMIN_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpadmin'@'%';
FLUSH PRIVILEGES;
EOF

echo "Datenbank und Benutzer erfolgreich erstellt."

# MySQL Konfiguration für Remote-Verbindungen
MYSQL_CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"
if ! grep -q "bind-address" "$MYSQL_CONFIG_FILE"; then
    echo "Konfiguriere MySQL für Remote-Verbindungen..."
    echo "bind-address = 0.0.0.0" | sudo tee -a "$MYSQL_CONFIG_FILE" > /dev/null
else
    echo "Remote-Verbindungskonfiguration bereits vorhanden. Überprüfe Datei: $MYSQL_CONFIG_FILE"
    sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' "$MYSQL_CONFIG_FILE"
fi

# MySQL-Dienst neu starten, damit Änderungen wirksam werden
echo "Starte MySQL-Dienst neu..."
sudo systemctl restart mysql

echo "MySQL ist jetzt für Remote-Verbindungen konfiguriert."

# Abschlussmeldung
echo "MySQL-Setup abgeschlossen. Datenbank: 'wordpress', Benutzer: 'wpadmin'."
