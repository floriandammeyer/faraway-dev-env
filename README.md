## Installation
Den Inhalt des Repositorys in ein leeres Verzeichnes kopieren. Anwendungscode muss im Unterverzeichnis "app/" abgelegt
werden, damit der Webserver die Dateien finden kann.
Um den Vagrant-Server zu starten muss die Datei "Vagrantfile.sample" aus dem Ordner "vagrant/" ins Wurzelverzeichnis
des Projekts kopiert und in "Vagrantfile" umbenannt werden. 

Danach kann mit dem Befehl "vagrant up" ein virtueller Webserver für das jeweilige Projekt gestartet werden.

Die "composer.json"- und ".bowerrc"-Dateien sind bereits vorkonfiguriert, damit entsprechende Packages direkt in die 
richtigen Verzeichnisse unterhalb des "app/"-Verzeichnisses installiert werden. 

Es kann zwischen Apache2 und Nginx als Webserver gewählt werden. Dazu einfach die entsprechenden Zeilen im 
Ansible-Playbook ("vagrant/ansible/playbook.yml") auskommentieren.

## Zugriff auf den Server
Es werden vier Ports der virtuellen Maschine auf den Host-Computer weitergeleitet. 
2222 ist Vagrants Standardport für SSH, sodass man über localhost:2222 per SSH auf den Server zugreifen kann. 
Wie genau die Authentifizierung funktioniert steht in der Vagrant-Dokumentation.
Unter Port 8080 ist der Webserver erreichbar, über 3306 der MySQL-Server.
Ein Sonderfall ist Port 1080, der auf das Web-Frontend von Mailcatcher weiterleitet. 
Hier bekommt man eine Übersicht über die "versendeten" E-Mails.

## Details zum System
### Ubuntu Server 14.04 64bit mit folgenden Tools:

- Ruby
- Python
- PHP

- Apache2 oder Nginx
- Nodejs
- NPM
- Bower

- MySQL
- phpMyAdmin (noch nicht in die neue Konfiguration aufgenommen, wird derzeit also noch nicht installiert!)

### Details:
##### Apache2
> Das DocumentRoot-Verzeichnis des Webservers wird automatisch auf das Wurzelverzeichnis des Projekts gemappt.
> Dadurch ist das Projekt nach "vagrant up" direkt über http://localhost:8080/ erreichbar.

##### MySQL-Server 5.5
> Aktuellste Version des MySQL-Servers. Mit dem Benutzer "root" und dem Passwort "password" kann direkt am Server gearbeitet werden. 
> Es wird automatisch eine Standarddatenbank namens "default_database" angelegt. Über die in database-config.sh definierten Dateien kann diese Datenbank automatisch gefüllt werden.

##### phpMyAdmin
> Unter http://localhost:8080/phpmyadmin ist die phpMyAdmin-Oberfläche erreichbar. phpMyAdmin ist bereits so konfiguriert,
> dass man direkt ohne Login auf die Datenbank zugreifen kann.

##### PHP 5.4
> zusätzlich zu den (Ubuntu-) Standardmodulen sind die PHP-Module Pear, Curl, Imap, Mysqlnd, Sqlite3, PostgreSql, MySQL und pcntl installiert.
> Außerdem ist Xdebug als nützliches Entwickler-Tool dabei. 

##### mailcatcher
> Mailcatcher ist ein kleines Ruby-Programm, das einen lokalen SMTP-Server ausführt. PHP ist schon so konfiguriert,
> dass es per "mail()" gesendete E-Mails an diesen Server schickt. Anstatt die E-Mails wie ein normaler SMTP-Server
> an ihre Adressaten weiterzuleiten, werden sie bloß abgefangen und gespeichert und können über http://localhost:1080/ online angesehen werden.

# TODO: Konfigurationsmöglichkeit für Ansible außerhalb des vagrant-Verzeichnisses ablegen, damit man innerhalb des vagrant-Ordners keine Dateien ändern muss wenn man z. B. nginx statt Apache haben möchte, sodass man das Vagrant-Verzeichnis als Git-Subrepo einrichten kann?
