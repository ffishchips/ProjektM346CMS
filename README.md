# 🚧Projekt M346
[![Bojan Maljuric](https://img.shields.io/badge/Bojan_Maljuric-FF4500?style=for-the-badge)](https://github.com/ffishchips)  
[![Fabian Manser](https://img.shields.io/badge/Fabian_Manser-4169E1?style=for-the-badge)](https://github.com/githubpro772)  
[![Antonio Jon](https://img.shields.io/badge/Antoni_Jon-696969?style=for-the-badge)](https://github.com/Antonio-Jon)
# Repository aufbau  
# 🎢Einleitung 
Wir haben eine AWS Wordpress installation vorgenommen und in diesem Github Repository ist die Beschreibung und Anleitung wie man dieselbe installation rekonstruieren kann um das selbe Ergebnis zu erzielen. Im Repository findet man die Testfälle Skripte die wir benutzt und getestet haben.
# 🗂️Inhaltsverzeichnis
1. [Einleitung](#-einleitung)
2. [Anforderung](#-anforderung)
3. [Installation](#-installation)
4. [Testfälle](#-testfälle)
# 🤔Anforderung 
Sie benötigen folgende Anforderungen zu erfüllen um das Skript erfolgreich ausführen zu können.  
- Ein AWS-Account mit administrativen Berechtigungen, sowie eine AWS instance mit aws Befehlen.  
- Git ist installiert.
- Ein Webbrowser für den Zugriff auf die WordPress-Seite.

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

Datenbank-Name: wordpress
Benutzername: wpadmin
Passwort: WordpressTest
Datenbankhost: <IP_MySQLServer
Tabellen-Präfix: Ihnen überlassen

Falls Sie die richtige IP eingetippt haben, sollte die Verbindung geklappt haben und Sie können mit Wordpress loslegen.

# 📃Testfälle
- [HTTP & HTTPS Verbindung Test](Testfall1.md)
- [Website via Namen erreichen Test](Testfall2.md)
- [Test](Testfall3.md)
-
