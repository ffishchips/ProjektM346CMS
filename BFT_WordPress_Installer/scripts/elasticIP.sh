#!/bin/bash
set -e  # Beendet das Skript, wenn ein Fehler auftritt

# Variablen aus der Konfigurationsdatei laden
source ./config_files/configvariables.sh

# Überprüfen, welcher Konfigurationsschritt als nächstes ausgeführt werden soll
if [[ "$CONFIG_STEP" == "1" ]]; then
    echo "Beginne mit der Konfiguration der Elastic IP für Instanz 1 ($INSTANCE_ID1)..."

    # Neue Elastic IP-Adresse anfordern
    NEW_ALLOCATION=$(aws ec2 allocate-address --query "AllocationId" --output text)

    if [ -z "$NEW_ALLOCATION" ]; then
        echo "Fehler: Es konnte keine neue Elastic IP erstellt werden."
        exit 1
    fi

    echo "Neue Elastic IP wurde erfolgreich erstellt. Zuordnung-ID: $NEW_ALLOCATION"

    # Elastic IP der ersten Instanz zuweisen
    aws ec2 associate-address --instance-id "$INSTANCE_ID1" --allocation-id "$NEW_ALLOCATION"

    # Die öffentliche IP-Adresse der neuen Elastic IP abrufen
    NEW_PUBLIC_IP=$(aws ec2 describe-addresses --allocation-ids "$NEW_ALLOCATION" --query "Addresses[0].PublicIp" --output text)
    echo "Die neue öffentliche IP-Adresse für Instanz 1 lautet: $NEW_PUBLIC_IP"

    # Aktualisierung von PUBLIC_IP1 in der Konfigurationsdatei
    sed -i "s|^PUBLIC_IP1=.*|PUBLIC_IP1=\"$NEW_PUBLIC_IP\"|" ./config_files/configvariables.sh

    # Aktualisieren des Konfigurationsstatus
    sed -i "s|^CONFIG_STEP=.*|CONFIG_STEP=2|" ./config_files/configvariables.sh
    echo "Die Konfiguration von Instanz 1 wurde abgeschlossen."

    # Tabellarische Ausgabe der Instanz-ID und zugewiesenen öffentlichen IP
    echo "+--------------------------------+------------------------------+"  
    printf "| %-30s | %-29s |\n" "Instanz-ID" "Öffentliche IP"
    echo "+--------------------------------+------------------------------+"  
    printf "| %-30s | %-28s |\n" "$INSTANCE_ID1" "$PUBLIC_IP1"
    echo "+--------------------------------+------------------------------+"  

elif [[ "$CONFIG_STEP" == "2" ]]; then
    echo "Beginne mit der Konfiguration der Elastic IP für Instanz 2 ($INSTANCE_ID2)..."

    # Neue Elastic IP-Adresse anfordern
    NEW_ALLOCATION=$(aws ec2 allocate-address --query "AllocationId" --output text)

    if [ -z "$NEW_ALLOCATION" ]; then
        echo "Fehler: Es konnte keine neue Elastic IP erstellt werden."
        exit 1
    fi

    echo "Neue Elastic IP wurde erfolgreich erstellt. Zuordnung-ID: $NEW_ALLOCATION"

    # Elastic IP der zweiten Instanz zuweisen
    aws ec2 associate-address --instance-id "$INSTANCE_ID2" --allocation-id "$NEW_ALLOCATION"

    # Die öffentliche IP-Adresse der neuen Elastic IP abrufen
    NEW_PUBLIC_IP=$(aws ec2 describe-addresses --allocation-ids "$NEW_ALLOCATION" --query "Addresses[0].PublicIp" --output text)
    echo "Die neue öffentliche IP-Adresse für Instanz 2 lautet: $NEW_PUBLIC_IP"

    # Aktualisierung von PUBLIC_IP2 in der Konfigurationsdatei
    sed -i "s|^PUBLIC_IP2=.*|PUBLIC_IP2=\"$NEW_PUBLIC_IP\"|" ./config_files/configvariables.sh

    # Konfigurationsstatus auf "abgeschlossen" setzen
    sed -i "s|^CONFIG_STEP=.*|CONFIG_STEP=done|" ./config_files/configvariables.sh
    echo "Die Konfiguration von Instanz 2 wurde abgeschlossen."
    echo""

    # Tabellarische Ausgabe der Instanz-ID und zugewiesenen öffentlichen IP
    clear
    echo ""
    echo -e "\e[1mDie Konfiguration ist abgeschlossen. Mit den folgenden Daten kann auf die fertige WordPress-Instanz zugegriffen werden:\e[0m"
    echo "+------------------------------+------------------------------+"  
    printf "| %-30s | %-30s |\n" "Instanz-ID" "Öffentliche IP"
    echo "+------------------------------+------------------------------+"  
    printf "| %-30s | %-30s |\n" "$INSTANCE_ID2" "$NEW_PUBLIC_IP"
    echo "+------------------------------+------------------------------+"  

aws ec2 authorize-security-group-ingress \
    --group-name "$SEC_GROUP_NAME" \
    --protocol tcp \
    --port 3306 \
    --cidr "$NEW_PUBLIC_IP"/32

else
    echo "Alle Elastic IPs wurden bereits erfolgreich konfiguriert. Es sind keine weiteren Schritte erforderlich."
    exit 0
fi
