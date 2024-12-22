#!/bin/bash
set -e  # Beendet das Skript, wenn ein Fehler auftritt

# Variablen aus der Konfigurationsdatei laden
source ./config_files/configvariables.sh

# Sicherstellen, dass das Zielverzeichnis existiert
if [ ! -d ~/ec2mysqlserver ]; then
    echo "Erstelle Verzeichnis ~/ec2mysqlserver..."
    mkdir -p ~/ec2mysqlserver
fi

# Überprüfen, ob das MySQL-Installationsskript vorhanden ist
MySQL_installation_File="./config_files/mysqlinstall.sh"
if [ ! -f $MySQL_installation_File ]; then
    echo "Fehler: $MySQL_installation_File konnte nicht gefunden werden. Bitte überprüfen Sie den Pfad oder erstellen Sie die Datei."
    exit 1
fi

# Starten der EC2-Instanz für MySQL und Extrahieren der Instanz-ID
echo "Starte MySQL EC2-Instanz..."
export AWS_PAGER=""

INSTANCE_ID1=$(aws ec2 run-instances \
--image-id ami-08c40ec9ead489470 \
--count 1 \
--instance-type t2.micro \
--key-name $KEY_NAME \
--security-groups $SEC_GROUP_NAME \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MySQL}]' \
--query 'Instances[0].InstanceId' \
--output text)

# Überprüfen, ob eine Instanz-ID zurückgegeben wurde
if [ -z "$INSTANCE_ID1" ]; then
    echo "Fehler: Keine Instanz-ID zurückgegeben."
    exit 1
fi

echo "Gestartete Instanz-ID: $INSTANCE_ID1"

# Ermitteln der öffentlichen IP-Adresse der Instanz
PUBLIC_IP1=$(aws ec2 describe-instances \
--instance-ids "$INSTANCE_ID1" \
--query "Reservations[].Instances[].PublicIpAddress" \
--output text)

# Sicherstellen, dass eine öffentliche IP-Adresse gefunden wurde
if [ -z "$PUBLIC_IP1" ]; then
    echo "Fehler: Keine öffentliche IP-Adresse gefunden."
    exit 1
fi

# Überprüfen, ob die Instanz und das System bereit sind
echo "Warte, bis die Instanz gestartet und bereit ist und alle Prüfungen bestanden wurden..."

while true; do
    # Überprüfen des Systemstatus und Instanzstatus
    STATUS=$(aws ec2 describe-instance-status --instance-id "$INSTANCE_ID1" \
    --query "InstanceStatuses[0].InstanceStatus.Status" --output text)
    SYSTEM_STATUS=$(aws ec2 describe-instance-status --instance-id "$INSTANCE_ID1" \
    --query "InstanceStatuses[0].SystemStatus.Status" --output text)

    if [ "$STATUS" == "ok" ] && [ "$SYSTEM_STATUS" == "ok" ]; then
        echo "Instanz ist bereit, alle Überprüfungen erfolgreich abgeschlossen!"
        break
    else
        echo "Instanz und/oder Systemprüfung noch nicht abgeschlossen. Überprüfe in 10 Sekunden erneut..."
        sleep 10
    fi
done

echo "Gefundene öffentliche IP-Adresse: $PUBLIC_IP1"

# Übertragen des MySQL-Installationsskripts auf die Instanz
echo "Übertrage das mysqlinstall.sh-Skript auf die Instanz..."
scp -i ~/.ssh/$KEY_NAME.pem -o StrictHostKeyChecking=accept-new ./config_files/mysqlinstall.sh ubuntu@"$PUBLIC_IP1":/home/ubuntu/mysqlinstall.sh
scp -i ~/.ssh/$KEY_NAME.pem -o StrictHostKeyChecking=accept-new ./config_files/configvariables.sh ubuntu@"$PUBLIC_IP1":/home/ubuntu/configvariables.sh

# Sicherstellen, dass die Dateien erfolgreich hochgeladen wurden
if [ $? -ne 0 ]; then
    echo "Fehler: Das Skript konnte nicht auf die Instanz hochgeladen werden."
    exit 1
fi

# Abschnitt für SSH-Verbindung und Remote-Befehle
echo "-------------------------------------------------------------------------------------"

# Ausführen des MySQL-Installationsskripts auf der Instanz
echo "Führe das MySQL-Installationsskript auf der Instanz aus..."
ssh -i ~/.ssh/$KEY_NAME.pem -o StrictHostKeyChecking=accept-new ubuntu@"$PUBLIC_IP1" << 'EOF'
    echo "Setze Berechtigungen für mysqlinstall.sh..."
    chmod +x /home/ubuntu/mysqlinstall.sh
    echo "Starte die Ausführung von mysqlinstall.sh..."
    /home/ubuntu/mysqlinstall.sh
EOF

echo "-------------------------------------------------------------------------------------"

# Überprüfen, ob die Ausführung erfolgreich war
if [ $? -ne 0 ]; then
    echo "Fehler: Das MySQL-Installationsskript konnte nicht erfolgreich ausgeführt werden."
    exit 1
else
    echo "MySQL-Installation erfolgreich abgeschlossen!"
fi

# Variablen in die Konfigurationsdatei schreiben
echo "INSTANCE_ID1=$INSTANCE_ID1" >> ./config_files/configvariables.sh
echo "PUBLIC_IP1=\"$PUBLIC_IP1\"" >> ./config_files/configvariables.sh
echo "MySQL_installation_File=\"$MySQL_installation_File\"" >> ./config_files/configvariables.sh

