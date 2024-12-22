# 🚧Projekt M346
[![Bojan Maljuric](https://img.shields.io/badge/Bojan_Maljuric-FF4500?style=for-the-badge)](https://github.com/ffishchips)  
[![Fabian Manser](https://img.shields.io/badge/Fabian_Manser-4169E1?style=for-the-badge)](https://github.com/githubpro772)  
[![Antonio Jon](https://img.shields.io/badge/Antonio_Jon-696969?style=for-the-badge)](https://github.com/Antonio-Jon)
# Repository aufbau  
- README.md -> Ist das Haupt file 
- TestfallX.md -> Unsere Testfall files

# 🎢Einleitung 
Wir haben eine AWS Wordpress installation vorgenommen und in diesem Github Repository ist die Beschreibung und Anleitung wie man dieselbe installation rekonstruieren kann um das selbe Ergebnis zu erzielen. Im Repository findet man die Testfälle Skripte die wir benutzt und getestet haben.
# 🗂️Inhaltsverzeichnis
1. [🎢Einleitung](#einleitung)
2. [🤔Anforderung](#anforderung)
3. [🔧Erklärung der Skripts](#erklärung-der-Skripts)
4. [⬇️Installation](#installation)
5. [📃Testfälle](#testfälle)
# 🤔Anforderung 
Sie benötigen folgende Anforderungen zu erfüllen um das Skript erfolgreich ausführen zu können.  
- Ein AWS-Account, sowie eine AWS instance mit aws Befehlen.  
- Git desktop ist installiert.
- Ein Webbrowser für den Zugriff auf die WordPress-Seite.

# 🔧Erklärung der Skripts  
## Skript: deleteall.sh
Das Skript deleteall.sh dient dazu, AWS-Ressourcen zu bereinigen, die durch ein bestimmtes Setup erstellt wurden. Es arbeitet in mehreren Schritten:  

   1. Variablen laden: Es lädt Konfigurationsvariablen aus einer Datei (configvariables.sh). 

   2. EC2-Instanzen entfernen: Es sucht nach EC2-Instanzen, die mit einer bestimmten Sicherheitsgruppe (SEC_GROUP_NAME) verknüpft sind, beendet und löscht diese. 

   3. Sicherheitsgruppe entfernen: Es überprüft, ob die Sicherheitsgruppe existiert, und löscht sie, falls vorhanden. 

   4. Key Pair löschen: Es entfernt das Key Pair (KEY_NAME) und die zugehörige lokale .pem-Datei, falls sie existiert. 

   5. Elastic IP-Adressen freigeben: Es listet alle Elastic IP-Adressen auf und gibt sie frei. 

   6. Konfigurationsdatei aktualisieren: Es löscht die bestehende Konfigurationsdatei und erstellt sie neu mit Standardwerten. 

Das Skript ist so gestaltet, dass es bei Fehlern sofort abbricht (set -e), und gibt während der Ausführung Statusmeldungen aus.  
## Skript: awsinstall.sh
Das Skript awsinstall.sh dient dazu, eine AWS-Infrastruktur zu erstellen und einzurichten. Es arbeitet folgende Schritte ab: 

ASCII-Art-Anzeige: Zu Beginn zeigt das Skript eine ASCII-Art-Ausgabe zur Begrüssung und als visuellen Hinweis. 

&nbsp;Sicherheitsgruppe und Key Pair erstellen: 

   - Führt ein separates Skript (keyandgroup.sh) aus, um eine AWS-Sicherheitsgruppe und ein Key Pair zu erstellen. 

&nbsp;MySQL-Instanz starten und einrichten: 

   - Führt das Skript mysqlinstance.sh aus, um eine AWS-MySQL-Instanz zu erstellen und einzurichten. 

   - Wenn dieses Skript fehlschlägt, wird der Prozess abgebrochen. 

&nbsp;Elastic IP für MySQL konfigurieren: 

   - Führt das Skript elasticIP.sh aus, um der MySQL-Instanz eine Elastic IP-Adresse zuzuweisen. 

&nbsp;Webserver-Instanz starten und einrichten: 

   - Führt das Skript webinstance.sh aus, um eine AWS-Webserver-Instanz zu erstellen und einzurichten. 

   - Auch hier wird der Prozess bei einem Fehler abgebrochen. 

&nbsp;Elastic IP für Webserver konfigurieren: 

   - Führt das Skript elasticIP.sh erneut aus, um dem Webserver eine Elastic IP-Adresse zuzuweisen. 

&nbsp;Abschlussmeldung: 

   - Gibt eine Erfolgsmeldung aus, wenn alle Schritte erfolgreich abgeschlossen wurden. 

Das Skript ist darauf ausgelegt, den gesamten Installationsprozess für eine AWS-basierte Infrastruktur automatisch durchzuführen.  

## Skript: configvariables.sh
Das Skript configvariables.sh enthält grundlegende Konfigurationsvariablen, die von anderen Skripten genutzt werden. Hier ist eine kurze Erklärung der einzelnen Variablen: 

KEY_NAME="bft-key" 

   - Der Name des AWS Key Pairs, das für den Zugriff auf EC2-Instanzen genutzt wird. 

SEC_GROUP_NAME="bft-sec-group" 

   - Der Name der AWS-Sicherheitsgruppe, die für die Konfiguration von Netzwerkzugriffen (z. B. Ports und IP-Beschränkungen) verwendet wird. 

CONFIG_STEP=1 

   - Ein Zähler oder Indikator für den aktuellen Konfigurationsschritt, vom elasticIP.sh. 

Diese Datei wird in den Skripten mit source eingebunden, um die Variablen zentral zu verwalten und Änderungen leicht vornehmen zu können. 

## Skript: mysqlinstall.sh
Das Skript mysqlinstall.sh richtet eine MySQL-Datenbankserver-Instanz ein, konfiguriert sie und bereitet sie für die Nutzung vor. Hier die Schritte, die es ausführt: 

Variablen definieren: 

   - Es lädt globale Konfigurationsvariablen aus configvariables.sh. 

   - Es definiert Passwörter für den MySQL-Root-Benutzer und den WordPress-Admin-Benutzer. 

MySQL installieren: 

   - Aktualisiert die Paketliste (sudo apt update -y). 

   - Installiert den MySQL-Server mit sudo apt install -y mysql-server. 

MySQL-Dienst starten: 

   - Startet und aktiviert den MySQL-Dienst, damit er beim Booten automatisch gestartet wird. 

Datenbank und Benutzer erstellen: 

   - Erstellt eine Datenbank namens wordpress. 

   - Legt einen Benutzer wpadmin an, mit dem Passwort aus der Variablen MYSQL_WP_ADMIN_USER_PASSWORD. 

   - Erteilt diesem Benutzer alle Rechte auf die Datenbank wordpress. 

Remote-Zugriff konfigurieren: 

   - Prüft die Datei /etc/mysql/mysql.conf.d/mysqld.cnf und ändert die Einstellung bind-address auf 0.0.0.0, damit MySQL Verbindungen von externen Clients akzeptiert. 

   - Startet den MySQL-Dienst neu, um die Änderungen zu übernehmen. 

Abschlussmeldung: 

   - Gibt eine Erfolgsmeldung aus, dass die MySQL-Installation und -Konfiguration abgeschlossen ist, und nennt die eingerichtete Datenbank (wordpress) und den Benutzer (wpadmin). 

Dieses Skript ist darauf ausgelegt, MySQL für lokale und Remote-Verwendungen vorzubereiten, insbesondere in einem Setup, das eine WordPress-Installation unterstützt. 

## Skript: wordpressinstall.sh
Das Skript wordpressinstall.sh dient zur Installation und Einrichtung von WordPress auf einem Apache-Webserver. Es führt folgende Schritte aus: 

Systempakete aktualisieren: 

   - Aktualisiert die Paketliste mit sudo apt-get update -y. 

Apache installieren: 

   - Installiert den Apache-Webserver mit sudo apt install -y apache2. 

PHP und MySQL-Module für PHP installieren: 

   - Installiert PHP sowie die MySQL-Module für die Kommunikation zwischen PHP und MySQL. 

WordPress herunterladen: 

   - Lädt die neueste Version von WordPress von der offiziellen Webseite herunter (wget https://wordpress.org/latest.tar.gz). 

WordPress entpacken und verschieben: 

   - Entpackt das heruntergeladene Archiv. 

   - Verschiebt die WordPress-Dateien in das Verzeichnis /var/www/html, das als Root-Verzeichnis für Apache dient. 

Dateiberechtigungen setzen: 

   - Setzt die Besitzerrechte auf www-data, den Standardbenutzer von Apache. 

   - Stellt sicher, dass die Dateien mit passenden Zugriffsrechten (chmod -R 755) versehen sind. 

Apache neu starten: 

   - Startet den Apache-Dienst neu, damit die Änderungen wirksam werden. 

SSL-Zertifikate einrichten (optional): 

   - Installiert Certbot, ein Tool zur einfachen Einrichtung von SSL-Zertifikaten. 

   - Hinweis: Für SSL wird eine gültige Domain benötigt. Alternativ kann dieser Schritt übersprungen werden. 

Abschlussmeldung: 

   - Gibt eine Erfolgsmeldung aus und weist darauf hin, dass WordPress über die öffentliche IP-Adresse der EC2-Instanz zugänglich ist. 

Das Skript richtet WordPress auf einer EC2-Instanz ein und sorgt dafür, dass es einsatzbereit ist, wobei SSL optional eingerichtet werden kann. 

## Skripit: elasticIP.sh
Das Skript elasticIP.sh dient zur Konfiguration von Elastic IP-Adressen (EIPs) in AWS und weist diese zwei EC2-Instanzen schrittweise zu. Hier ist eine Erklärung der Funktionsweise: 

Ablauf des Skripts 

&nbsp;Initialisierung und Lade der Konfiguration: 

   - Lädt Variablen wie CONFIG_STEP, INSTANCE_ID1, INSTANCE_ID2, und SEC_GROUP_NAME aus der Datei configvariables.sh. 

&nbsp;Konfigurationsschritt prüfen: 

   - Das Skript prüft, welcher Schritt der Konfiguration (1 oder 2) aktuell ausgeführt werden muss, basierend auf der Variablen CONFIG_STEP. 

Schritt 1: Elastic IP für INSTANCE_ID1 

   - Fordert eine neue Elastic IP-Adresse an und speichert deren Allocation ID. 

   - Weist die Elastic IP-Adresse der ersten Instanz (INSTANCE_ID1) zu. 

   - Ruft die öffentliche IP-Adresse der zugewiesenen Elastic IP ab. 

   - Aktualisiert die Konfigurationsdatei configvariables.sh:  

   - Speichert die neue öffentliche IP in der Variablen PUBLIC_IP1. 

   - Setzt CONFIG_STEP=2, um zum nächsten Schritt zu wechseln. 

   - Gibt eine Tabelle mit der Instanz-ID und der zugewiesenen öffentlichen IP aus. 

Schritt 2: Elastic IP für INSTANCE_ID2 

   - Analog zu Schritt 1:  

   - Fordert eine neue Elastic IP an, weist sie der zweiten Instanz (INSTANCE_ID2) zu, und speichert die zugehörige öffentliche IP. 

   - Aktualisiert die Konfigurationsdatei configvariables.sh:  

   - Speichert die neue öffentliche IP in PUBLIC_IP2. 

   - Setzt CONFIG_STEP=done, um den Konfigurationsprozess als abgeschlossen zu markieren. 

   - Gibt eine Tabelle mit der zweiten Instanz-ID und deren öffentlicher IP aus. 

Sicherheitsgruppenregel für MySQL: 

   - Erlaubt eingehenden TCP-Verkehr auf Port 3306 (MySQL) ausschliesslich von der neuen IP-Adresse (NEW_PUBLIC_IP) der zweiten Instanz. 

Wenn CONFIG_STEP=done: 

   - Gibt eine Nachricht aus, dass alle Elastic IPs bereits konfiguriert sind, und beendet das Skript. 

Besonderheiten und Hinweise: 

   - Das Skript gewährleistet durch die set -e-Anweisung, dass es bei Fehlern sofort abbricht. 

   - Änderungen an der Datei configvariables.sh werden direkt vorgenommen, um den Fortschritt zwischen den Schritten zu speichern. 

   - Tabellenansichten und farbige Ausgaben (z. B. \e[1m) verbessern die Benutzerfreundlichkeit. 

   - Die Sicherheitsgruppe wird dynamisch aktualisiert, um den Datenbankzugriff zu beschränken. 

Das Skript automatisiert die Zuweisung von Elastic IPs und sorgt für Sicherheit und Nachvollziehbarkeit der Änderungen. 

## Skript: keyandgroup.sh
Das Skript keyandgroup.sh erstellt ein AWS-Schlüsselpaar und eine Sicherheitsgruppe, falls diese noch nicht existieren. Im Detail funktioniert es wie folgt: 

Funktionalitäten des Skripts 

&nbsp;Initialisierung:  

   - Das Skript verwendet die configvariables.sh, um Schlüsselvariablen wie KEY_NAME und SEC_GROUP_NAME zu laden. 

   - Die Option set -e sorgt dafür, dass das Skript bei einem Fehler sofort beendet wird.  

&nbsp;Erstellen eines Key Pairs: 

   - Prüfen, ob das Key Pair bereits existiert:  

   - Es wird geprüft, ob eine Datei mit dem Namen ~/.ssh/$KEY_NAME.pem existiert. 

   - Falls nicht, wird das Key Pair mit dem AWS CLI-Befehl create-key-pair erstellt. 

   - Das private Schlüsselmaterial wird in der Datei ~/.ssh/$KEY_NAME.pem gespeichert. 

   - Die Datei erhält restriktive Berechtigungen (chmod 400), um Sicherheit zu gewährleisten. 

   - Wenn das Key Pair bereits existiert:  

   - Gibt das Skript eine Nachricht aus und überspringt die Erstellung. 

&nbsp;Erstellen einer Sicherheitsgruppe: 

   - Prüfen, ob die Sicherheitsgruppe existiert:  

   - Mit dem AWS CLI-Befehl describe-security-groups wird überprüft, ob die Gruppe bereits vorhanden ist. 

   - Erstellen der Sicherheitsgruppe:  

   - Wenn die Sicherheitsgruppe nicht existiert, wird sie mit dem Namen und einer Beschreibung angelegt. 

   - Zwei Regeln für den eingehenden Datenverkehr (ingress) werden hinzugefügt:  

   - HTTP (Port 80): Ermöglicht Zugriff von überall (0.0.0.0/0). 

   - SSH (Port 22): Ermöglicht Zugriff von überall (0.0.0.0/0). 

   - Wenn die Sicherheitsgruppe bereits existiert:  

   - Gibt das Skript eine Nachricht aus und überspringt diesen Schritt. 

&nbsp;Sicherheitsaspekte: 

   - Schlüsselschutz:  

   - Der private Schlüssel wird lokal gespeichert und geschützt (chmod 400). 

&nbsp;Offene Ports:  

   - Standardmässig erlaubt das Skript weltweiten Zugriff auf Port 80 und Port 22. Dies kann ein Sicherheitsrisiko sein und sollte auf spezifische IP-Bereiche eingeschränkt werden, wenn möglich. 

&nbsp;Ausgabe und Abschluss: 

   - Informiert den Benutzer über den Fortschritt und den Status der Key Pair- und Sicherheitsgruppen-Erstellung. 

   - Bei Abschluss wird eine Erfolgsmeldung angezeigt. 

Das Skript bietet eine solide Grundlage, um Schlüsselpaare und Sicherheitsgruppen für AWS EC2-Instanzen effizient einzurichten. 

## Skript: mysqlinstance.sh
Das Skript mysqlinstance.sh dient zur Automatisierung der Erstellung und Konfiguration einer AWS EC2-Instanz mit MySQL. Es beinhaltet Schritte zur Instanzerstellung, Konfiguration und Bereitstellung des MySQL-Servers auf der Instanz. 

Ablauf und Funktionalitäten 

&nbsp;Vorbereitung 

   - Laden von Konfigurationsvariablen:  

   - configvariables.sh wird verwendet, um Variablen wie KEY_NAME und SEC_GROUP_NAME zu laden. 

   - Verzeichnis erstellen:  

   - Sicherstellen, dass das Verzeichnis ~/ec2mysqlserver existiert, um Dateien lokal zu speichern. 

   - MySQL-Installationsskript prüfen:  

   - Überprüfen, ob das MySQL-Installationsskript mysqlinstall.sh im Verzeichnis config_files existiert. 

&nbsp;EC2-Instanz starten 

   - Instanz mit AWS CLI erstellen:  

   - aws ec2 run-instances startet eine EC2-Instanz mit den übergebenen Parametern:  

   - AMI ID: ami-08c40ec9ead489470 (Amazon Linux 2 oder Ubuntu-Image). 

   - Instance Type: t2.micro (kostenloses Kontingent). 

   - Key Pair und Sicherheitsgruppe: Definiert durch KEY_NAME und SEC_GROUP_NAME. 

   - Instanz-ID extrahieren:  

   - Mit --query 'Instances[0].InstanceId' wird die Instanz-ID abgerufen. 

   - Öffentliche IP-Adresse abrufen:  

   - Mit aws ec2 describe-instances wird die öffentliche IP der Instanz ermittelt.  

&nbsp;Statusprüfung 

   - Warten auf Bereitschaft der Instanz:  

   - Eine Schleife überprüft regelmässig den Systemstatus und Instanzstatus der EC2-Instanz (ok bedeutet, dass sie betriebsbereit ist). 

   - Wenn beide Werte auf ok stehen, wird fortgefahren. 

&nbsp;MySQL-Installationsskript hochladen 

   - Hochladen von Dateien auf die Instanz:  

   - Mithilfe von scp wird das mysqlinstall.sh-Skript und die configvariables.sh auf die Instanz kopiert. 

   - Das Skript prüft, ob das Hochladen erfolgreich war. 

&nbsp;MySQL-Installationsskript ausführen 

   - Remote-SSH-Ausführung:  

   - Das mysqlinstall.sh-Skript wird per SSH auf der Instanz ausgeführt. 

   - Die Ausführung erfolgt unter dem Benutzer ubuntu. 

   - Vor der Ausführung wird das Skript ausführbar gemacht (chmod +x). 

&nbsp;Abschluss 

   - Erfolg prüfen:  

   - Das Skript überprüft, ob das MySQL-Installationsskript erfolgreich ausgeführt wurde. 

   - Bei Erfolg werden die Instanz-ID und die öffentliche IP-Adresse in die configvariables.sh geschrieben. 

&nbsp;Sicherheitsaspekte 

   - Sicherheitsgruppen:  

&nbsp;Die Instanz verwendet die Sicherheitsgruppe $SEC_GROUP_NAME, die entsprechende Ports (z. B. 22 für SSH) freischalten sollte. 

   - Schlüsselsicherheit:  

&nbsp;Der private Schlüssel (~/.ssh/$KEY_NAME.pem) wird verwendet und durch Berechtigungen geschützt (chmod 400). 

   - IP-Beschränkungen:  

&nbsp;Zugriffe auf die EC2-Instanz können weiter eingeschränkt werden, indem die CIDR-Blöcke der Sicherheitsgruppe angepasst werden. 

Dieses Skript bietet eine robuste Grundlage für die Automatisierung des Aufsetzens einer MySQL-Server-Umgebung in AWS. 

## Skript: webinstance.sh
Das Skript webinstance.sh automatisiert die Bereitstellung einer EC2-Instanz für die Installation und Konfiguration eines WordPress-Webservers. Es umfasst Schritte wie das Erstellen der Instanz, die Übertragung des Installationsskripts und die Ausführung von Befehlen zur Einrichtung des Webservers. 

Ablauf und Funktionalitäten 

&nbsp;Vorbereitung 

   1. Laden von Konfigurationsvariablen:  

   2. Mit configvariables.sh werden Variablen wie KEY_NAME und SEC_GROUP_NAME geladen. 

   3. Verzeichnis erstellen:  

   4. Das Verzeichnis ~/ec2webserver wird erstellt, falls es nicht existiert. 

   5. WordPress-Installationsskript prüfen:  

   6. Überprüfung, ob das WordPress-Installationsskript wordpressinstall.sh existiert. Falls nicht, wird das Skript beendet. 

&nbsp;EC2-Instanz starten 

&nbsp;&nbsp;Instanz mit AWS CLI erstellen:  

&nbsp;&nbsp;&nbsp;aws ec2 run-instances startet eine neue EC2-Instanz mit den folgenden Parametern:  

   - AMI ID: ami-08c40ec9ead489470 (Amazon Linux 2 oder Ubuntu). 

   - Instance Type: t2.micro. 

   - Key Pair und Sicherheitsgruppe: Definiert durch KEY_NAME und SEC_GROUP_NAME. 

   - Tagging: Der Instanz wird das Tag Name=Webserver zugewiesen. 

&nbsp;&nbsp;&nbsp;Instanz-ID extrahieren:  

   - Die Instanz-ID wird aus der Antwort extrahiert und in der Variable INSTANCE_ID2 gespeichert. 

&nbsp;&nbsp;&nbsp;Öffentliche IP-Adresse abrufen:  

   - Mit aws ec2 describe-instances wird die öffentliche IP-Adresse der Instanz in PUBLIC_IP2 gespeichert. 

Statusprüfung 

&nbsp;Bereitschaft der Instanz prüfen:  

   - Eine Schleife überprüft regelmässig, ob die Instanz betriebsbereit ist, indem sie den Systemstatus und Instanzstatus abfragt. Sobald beide Werte ok sind, wird fortgefahren. 

WordPress-Installationsskript hochladen 

&nbsp;Skript übertragen:  

   - Das WordPress-Installationsskript wordpressinstall.sh und die Konfigurationsdatei configvariables.sh werden per scp auf die Instanz kopiert. 

&nbsp;Erfolg prüfen:  

   - Überprüfung, ob die Dateien erfolgreich hochgeladen wurden. Im Fehlerfall wird das Skript beendet. 

WordPress-Installationsskript ausführen 

&nbsp;Remote-SSH-Ausführung:  

   - Das Skript wordpressinstall.sh wird per SSH auf der EC2-Instanz ausgeführt. 
   - Vor der Ausführung wird sichergestellt, dass das Skript ausführbar ist (chmod +x). 

Abschluss 

&nbsp;Erfolg prüfen:  

   - Falls die Ausführung des WordPress-Installationsskripts erfolgreich war, wird eine Erfolgsmeldung angezeigt. 

&nbsp;Konfigurationsvariablen speichern:  

   - Die Instanz-ID und die öffentliche IP-Adresse der Webserver-Instanz werden in die Datei configvariables.sh geschrieben. 

Sicherheitsaspekte 

&nbsp;Sicherheitsgruppen:  

   - Es wird eine Sicherheitsgruppe verwendet, die den Zugriff auf den Webserver (z. B. HTTP-Port 80) und SSH (Port 22) ermöglicht. Diese Regeln sollten überprüft werden. 

&nbsp;Schlüsselverwaltung:  

   - Der private Schlüssel (~/.ssh/$KEY_NAME.pem) wird verwendet und ist durch Berechtigungen geschützt (chmod 400). 

&nbsp;IP-Einschränkungen:  

   - Erwägen Sie, den Zugriff auf die EC2-Instanz auf bestimmte IP-Adressen einzuschränken. 

 

Dieses Skript bietet eine solide Basis für die Bereitstellung und Konfiguration eines Webservers mit WordPress auf AWS. 

Das Skript ist so gestaltet, dass es bei Fehlern sofort abbricht (set -e), und gibt während der Ausführung Statusmeldungen aus.  
# ⬇️Installation
1. Starten Sie den AWS-Lab

Das Starten des AWS kann einige Minuten dauern. Bis dorthin können Sie bis zum Schritt 4. weitermachen. Ab Schritt 4 muss der AWS schon laufen.

2. Ordner kopieren

Kopieren Sie den [BFT_WordPress_Installer](BFT_WordPress_Installer) auf Ihre AWS Instance. Achten Sie darauf, dass die Ordnerstrukter beibehalten wird.

3. Rechte vergeben

Falls die Dateien kein Ausführrecht besitzen (sollte der Fall sein), können Sie mit dem Befehl z.B chmod +x Datei.sh das Skript ausführbar machen. Am besten bei allen Skript das Ausführrecht einschalten

4. Credentials ändern

Gehen Sie zu ihr AWS und kopieren Sie Ihre Credentials heraus und fügen Sie sie in die Datei ~/.aws/credentials ein.

5. Verbindungstest

Mit einem AWS Befehl wie aws s3 ls können Sie die Verbindung testen

6. install.sh im Ordner BFT_WordPress_Installer ausführen

Gehen Sie in den Ordner hinein und führen Sie das Skript install.sh mit dem Befehl ./install.sh aus.
Alles wird nun automatisiert für Sie installiert.

7. Wordpress mit Datenbank verbinden

Um Wordpress benutzen zu können müssen Sie per IP der Wordpress Instance <IP_WorpressServer>/wordpress folgende Informationen eingeben.

- Datenbank-Name: wordpress
- Benutzername: wpadmin
- Passwort: WordpressTest
- Datenbankhost: <IP_MySQLServer
- Tabellen-Präfix: Ihnen überlassen

Falls Sie die richtige IP eingetippt haben, sollte die Verbindung geklappt haben und Sie können mit Wordpress loslegen.

# 📃Testfälle
- [HTTP & HTTPS Verbindung Test](Testfall1.md)
- [Wordpress Verbindung zum Datenbankserver Test](Testfall2.md)
- [Funktionalität des Skripts install.sh](Testfall3.md)
