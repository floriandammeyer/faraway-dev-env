#!/usr/bin/env bash
# Pfad zur Datei mit SQL-Befehlen zur Initialisierung der Datenbank-Struktur
#
# Hinweis: Auf dem Server wird das Projektverzeichnis unter dem Verzeichnis "/vagrant" verfügbar gemacht.
# Die unten beschriebene Datei befindet sich also in unsrem Projekt-Ordner im Unterordner "data/sql/"
database_init_script="/vagrant/data/sql/structure.sql"

# Pfad zur Datei mit SQL-Befehlen zum Einrichten des Datenbank-Inhalts
# Zum Beispiel ein alter Export von Daten aus dem Produktivsystem, um die Testdatenbank mit Daten zu füllen
database_content_script="/vagrant/data/sql/data.sql"