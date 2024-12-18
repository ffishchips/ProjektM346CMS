#!/bin/bash
set -e  # Beendet das Skript, wenn ein Fehler auftritt

# Variablen aus der Konfigurationsdatei laden
source ./config_files/variables.sh

# Key Pair erstellen
echo "Überprüfe, ob das Key Pair existiert..."
if [ ! -f ~/.ssh/$KEY_NAME.pem ]; then
    echo "Erstelle Key Pair '$KEY_NAME'..."
    mkdir -p ~/.ssh
    aws ec2 create-key-pair --key-name "$KEY_NAME" \
        --key-type rsa \
        --query 'KeyMaterial' \
        --output text > ~/.ssh/$KEY_NAME.pem
    chmod 400 ~/.ssh/$KEY_NAME.pem
    echo "Key Pair erfolgreich erstellt und in ~/.ssh/$KEY_NAME.pem gespeichert."
else
    echo "Key Pair ~/.ssh/$KEY_NAME.pem existiert bereits. Überspringe diesen Schritt."
fi

# Sicherheitsgruppe erstellen
echo "Überprüfe, ob die Sicherheitsgruppe '$SEC_GROUP_NAME' existiert..."
if ! aws ec2 describe-security-groups --group-names "$SEC_GROUP_NAME" &>/dev/null; then
    echo "Erstelle Sicherheitsgruppe '$SEC_GROUP_NAME'..."
    aws ec2 create-security-group \
        --group-name "$SEC_GROUP_NAME" \
        --description "EC2-Webserver-Sicherheitsgruppe"

    # Regeln für die Sicherheitsgruppe hinzufügen
    echo "Füge Regeln für die Sicherheitsgruppe '$SEC_GROUP_NAME' hinzu..."
    aws ec2 authorize-security-group-ingress \
        --group-name "$SEC_GROUP_NAME" \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress \
        --group-name "$SEC_GROUP_NAME" \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0
    echo "Regeln erfolgreich hinzugefügt."
else
    echo "Sicherheitsgruppe '$SEC_GROUP_NAME' existiert bereits. Überspringe diesen Schritt."
fi

echo "Skript erfolgreich abgeschlossen."
