#!/bin/bash
set -e  # Skript wird bei Auftreten eines Fehlers sofort beendet

# Definieren und Laden von Variablen
source ./config_files/configvariables.sh
FILE_PATH="./config_files/configvariables.sh"

# EC2-Instanzen suchen und beenden
echo "Suche nach EC2-Instanzen, die der Sicherheitsgruppe $SEC_GROUP_NAME zugeordnet sind..."
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=instance.group-name,Values=$SEC_GROUP_NAME" \
    --query "Reservations[*].Instances[*].InstanceId" --output text)

if [ -n "$INSTANCE_IDS" ]; then
    echo "Beende und lösche die folgenden EC2-Instanzen: $INSTANCE_IDS..."
    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS
    echo "Die EC2-Instanzen wurden erfolgreich beendet und gelöscht."
else
    echo "Keine EC2-Instanzen mit der Sicherheitsgruppe $SEC_GROUP_NAME gefunden."
fi

# Sicherheitsgruppe entfernen
echo "Entferne die Sicherheitsgruppe $SEC_GROUP_NAME..."
if aws ec2 describe-security-groups --group-names $SEC_GROUP_NAME &>/dev/null; then
    aws ec2 delete-security-group --group-name $SEC_GROUP_NAME
    echo "Die Sicherheitsgruppe $SEC_GROUP_NAME wurde erfolgreich entfernt."
else
    echo "Die Sicherheitsgruppe $SEC_GROUP_NAME existiert nicht."
fi

# Key Pair entfernen
echo "Entferne das Key Pair $KEY_NAME..."
if aws ec2 describe-key-pairs --key-names $KEY_NAME &>/dev/null; then
    aws ec2 delete-key-pair --key-name $KEY_NAME
    rm -f ~/.ssh/${KEY_NAME}.pem
    echo "Das Key Pair $KEY_NAME wurde erfolgreich gelöscht."
else
    echo "Das Key Pair $KEY_NAME existiert nicht."
fi

# Elastic IP-Adressen entfernen

# Abrufen aller Elastic IP-Adressen
elastic_ips=$(aws ec2 describe-addresses --query 'Addresses[*].[AllocationId]' --output text)

# Überprüfen, ob Elastic IP-Adressen vorhanden sind
if [ -z "$elastic_ips" ]; then
    echo "Keine Elastic IP-Adressen gefunden."
    exit 1
else
    echo "Gefundene Elastic IP-Adressen:"
    echo "$elastic_ips"
fi

# Freigeben jeder Elastic IP-Adresse
for allocation_id in $elastic_ips; do
    echo "Gebe die Elastic IP-Adresse mit der Allocation-ID $allocation_id frei..."
    aws ec2 release-address --allocation-id $allocation_id
    if [ $? -eq 0 ]; then
        echo "Die Elastic IP-Adresse wurde erfolgreich freigegeben."
    else
        echo "Fehler beim Freigeben der Elastic IP-Adresse mit der Allocation-ID $allocation_id."
    fi
done

# Standardvariablen-Datei entfernen
if [ -f "$FILE_PATH" ]; then
    rm "$FILE_PATH"
    echo "Die Datei mit den Standardvariablen wurde erfolgreich gelöscht."
else
    echo "Die Datei mit den Standardvariablen existiert nicht."
fi

# Standardvariablen-Datei neu erstellen
touch "$FILE_PATH"
echo "KEY_NAME=\"bft-key\"" >> "$FILE_PATH"
echo "SEC_GROUP_NAME=\"bft-sec-group\"" >> "$FILE_PATH"
echo "CONFIG_STEP=1" >> "$FILE_PATH"

echo "Die Standardvariablen wurden erfolgreich neu erstellt."
