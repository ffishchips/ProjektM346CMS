#!/bin/bash
set -e  # Beendet das Skript, wenn ein Fehler auftritt
source ./config_files/configvariables.sh

cat << 'EOF'
██████╗ ███████╗████████╗
██╔══██╗██╔════╝╚══██╔══╝
██████╔╝█████╗     ██║   
██╔══██╗██╔══╝     ██║   
██████╔╝██║        ██║   
╚═════╝ ╚═╝        ╚═╝   

 █████╗ ██╗    ██╗███████╗
██╔══██╗██║    ██║██╔════╝
███████║██║ █╗ ██║███████╗
██╔══██║██║███╗██║╚════██║
██║  ██║╚███╔███╔╝███████║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝

██╗    ██╗ ██████╗ ██████╗ ██████╗ ██████╗ ██████╗ ███████╗███████╗███████╗
██║    ██║██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
██║ █╗ ██║██║   ██║██████╔╝██║  ██║██████╔╝██████╔╝█████╗  ███████╗███████╗
██║███╗██║██║   ██║██╔══██╗██║  ██║██╔═══╝ ██╔══██╗██╔══╝  ╚════██║╚════██║
╚███╔███╔╝╚██████╔╝██║  ██║██████╔╝██║     ██║  ██║███████╗███████║███████║
 ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝

EOF
echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"

# Skript für das Erstellen der Sicherheitsgruppe und des Key Pairs ausführen
bash ./scripts/keyandgroup.sh

# AWS MySQL-Instanz wird gestartet und eingerichtet
bash ./scripts/mysqlinstance.sh

if [[ $? -ne 0 ]]; then
    echo "Fehler: Das Skript mysqlinstance.sh konnte nicht erfolgreich ausgeführt werden."
    echo "Der Installationsprozess wird abgebrochen."
    exit 1
fi

# Elastic IP-Adresse für die MySQL-Instanz einrichten
echo "Elastic IP für MySQL wird konfiguriert..."
./scripts/elasticIP.sh

echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"

# AWS Webserver-Instanz wird gestartet und eingerichtet
bash ./scripts/webinstance.sh

if [[ $? -ne 0 ]]; then
    echo "Fehler: Das Skript webinstance.sh konnte nicht erfolgreich ausgeführt werden."
    echo "Der Installationsprozess wird abgebrochen."
    exit 1
fi

# Elastic IP-Adresse für den Webserver einrichten
echo "Elastic IP für den Webserver wird konfiguriert..."
./scripts/elasticIP.sh

# Abschluss der Installation
echo "Die Installation wurde erfolgreich abgeschlossen."

