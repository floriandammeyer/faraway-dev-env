## Installation
Den Inhalt des Repositorys einfach ins Wurzelverzeichnis des Projekts kopieren. Schon kann mit "vagrant up" ein
virtueller Webserver für das jeweilige Projekt gestartet werden.

## Zugriff auf den Server
Es werden vier Ports der virtuellen Maschine auf den Host-Computer weitergeleitet. 
2222 ist Vagrants Standardport für SSH, sodass man über localhost:2222 per SSH auf den Server zugreifen kann. 
Wie genau das mit der Authentifizierung funktioniert steht in der Vagrant-Dokumentation.
Unter Port 8080 ist der Webserver erreichbar, über 3306 der MySQL-Server.
Ein Sonderfall ist Port 1080, der auf das Web-Frontend von Mailcatcher weiterleitet. Hier bekommt man eine Übersicht über die "versendeten" E-Mails.

## Details zum System
### Ubuntu 14.04 mit folgenden Tools:

- Curl
- Git
- G++
- Make

- Ruby
- Python
- PHP

- Apache2
- Nodejs
- NPM
- Bower

- MySQL
- phpMyAdmin

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