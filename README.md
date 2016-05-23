## Installation
Den Inhalt des Repositorys in ein leeres Verzeichnes kopieren. Anwendungscode kann direkt im Wurzelverzeichnis
des Projekts abgelegt werden, idealerweise legt man dafür aber ein Unterverzeichnis an, z. B. namens "src/". Bei
Verwendung eines Frameworks wird dieses einem die Verzeichnisstruktur vorgeben.

Das Verzeichnis "public/" ist das Wurzelverzeichnis des Webservers. Alle Dateien, die vom Webserver direkt 
ausgeliefert werden sollen, müssen deshalb unterhalb dieses Verzeichnisses abgelegt werden.
 
Als Einstiegspunkt in die Anwendung ist die Datei "index.php" im "public/" Verzeichnis vorkonfiguriert. Die beigelegte
".htaccess" Datei leitet alle Anfragen auf die "index.php" um, sodass per internem Routing darauf reagiert werden kann.
Dies ist natürlich hauptsächlich auf die Verwendung mit Frameworks ausgelegt. Für sehr einfache Anwendungen ist das
Standard-Setup dieser Entwicklungsumgebung zu viel des Guten.

Um den Vagrant-Server zu starten muss die Datei "Vagrantfile.sample" aus dem Ordner "vagrant/" ins Wurzelverzeichnis
des Projekts kopiert und in "Vagrantfile" umbenannt werden. 

Danach kann mit dem Befehl "vagrant up" ein virtueller Webserver für das jeweilige Projekt gestartet werden.

Die "composer.json"- und ".bowerrc"-Dateien sind bereits vorkonfiguriert, damit entsprechende Packages direkt in die 
richtigen Verzeichnisse installiert werden. 

Es kann zwischen Apache2 und Nginx als Webserver gewählt werden. Dazu einfach die entsprechenden Zeilen im 
Ansible-Playbook ("vagrant/ansible/playbook.yml") auskommentieren.

Für sehr einfache Anwendungen oder Frameworks mit sehr speziellen Vorgaben kann im Ansible-Playbook außerdem 
ein anderes Wurzelverzeichnis für den Webserver eingestellt werden.

## Zugriff auf den Server
Es werden vier Ports der virtuellen Maschine auf den Host-Computer weitergeleitet.
 
2222 ist Vagrants Standardport für SSH, sodass man über localhost:2222 per SSH auf den Server zugreifen kann. 
Wie genau die Authentifizierung funktioniert steht in der Vagrant-Dokumentation.

Unter Port 8080 ist der Webserver erreichbar, über 3306 der MySQL-Server.

Ein Sonderfall ist Port 8025, der auf das Web-Frontend von MailHog weiterleitet. 
Hier bekommt man eine Übersicht über die von MailHog abgefangenen E-Mails, die durch PHP verschickt worden wären.

## Details zum System
### Ubuntu Server 14.04 64bit mit folgenden Tools:

- Python
- PHP 5.6

- Apache2 oder Nginx
- Nodejs
- NPM
- Bower

- MySQL
- phpMyAdmin (noch nicht in die neue Konfiguration aufgenommen, wird derzeit also noch nicht installiert!)

### Details:
##### Apache2
> Das DocumentRoot-Verzeichnis des Webservers wird automatisch auf das "public/" Verzeichnis des Projekts gemappt.
> Dadurch ist das Projekt nach "vagrant up" direkt über http://localhost:8080/ erreichbar.

##### MySQL-Server 5.5
> Aktuellste Version des MySQL-Servers. Mit dem Benutzer "root" und dem Passwort "password" kann direkt am Server gearbeitet werden. 
> Es wird automatisch eine Standarddatenbank namens "default_database" angelegt. Bisher gibt es noch kein Datenbank-Setup-Script, das die Datenbank automatisch befüllt.

##### phpMyAdmin
> Unter http://localhost:8080/phpmyadmin ist die phpMyAdmin-Oberfläche erreichbar. phpMyAdmin ist bereits so konfiguriert,
> dass man direkt ohne Login auf die Datenbank zugreifen kann.
> HINWEIS: Dies ist noch nicht korrekt eingerichtet!

##### PHP 5.6
> zusätzlich zu den (Ubuntu-) Standardmodulen sind die PHP-Module Pear, Curl, Imap, Mysqlnd, Sqlite3, PostgreSql, MySQL und pcntl installiert.
> Außerdem ist Xdebug als nützliches Entwickler-Tool dabei. 

##### MailHog
> MailHog ist ein kleines Go-Programm, das einen lokalen SMTP-Server ausführt. PHP ist schon so konfiguriert,
> dass per "mail()" gesendete E-Mails an diesen Server geschickt werden. Anstatt die E-Mails wie ein normaler SMTP-Server
> an ihre Adressaten weiterzuleiten, werden sie bloß abgefangen und gespeichert und können über http://localhost:8025/ online angesehen werden.