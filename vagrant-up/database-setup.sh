#!/bin/bash

source $(dirname $0)/database-config.sh

# Create the default database and grant all privileges on this database to the root user
mysql -uroot -ppassword <<< 'CREATE DATABASE default_database;'
mysql -uroot -ppassword <<< 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%";'
mysql -uroot -ppassword <<< 'FLUSH PRIVILEGES;'

if [ -f "${database_init_script}" ];
then
    mysql -uroot -ppassword default_database < "${database_init_script}"

    if [ -f "${database_content_script}" ];
    then
        mysql -uroot -ppassword default_database < "${database_content_script}"
    fi
fi