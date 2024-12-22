# Funktionalität des Skripts awsinstall.sh
Testzeitpunkt:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;18.12.2024 15:10  
Testperson:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Antonio Jon  
Testumgebung: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ausführung des Skripts auf einer lokalen Shell mit Zugriff auf AWS CLI und einer korrekten Konfigurationsdatei.  

Testvorgehen  
1. Überprüfung, ob das Skript ohne Fehler ausgeführt wird.  
2. Validierung der Automatisierungsschritte:  
- Erstellung des Key-Pairs.  
- Erstellung der Sicherheitsgruppe und deren Regeln.  
- Starten einer EC2-Instanz.  
3. Kontrolle der erzeugten Ressourcen (Key-Pair, Sicherheitsgruppe, EC2-Instanz) über die AWS Management Console.  

Testergebnis  
- Das Skript wurde erfolgreich ausgeführt.  
- Alle Automatisierungsschritte wurden korrekt durchgeführt:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Das Key-Pair wurde erstellt und sicher gespeichert.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Die Sicherheitsgruppe mit den entsprechenden Regeln (Ports 22, 80) wurde angelegt.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Die EC2-Instanz wurde gestartet und ist erreichbar.  

Fazit  
Das Skript funktioniert fehlerfrei und erfüllt seine Aufgaben wie erwartet.  
Empfehlung: Das Skript kann produktiv genutzt werden. Es wird empfohlen, regelmäßig Backups der Konfigurationsdateien durchzuführen.


![image](Images/testfall3.png)

> [Zurück zum ReadMe file](README.md)  
> [# Wordpress Verbindung zum Datenbankserver funktioniert](Testfall2.md)
