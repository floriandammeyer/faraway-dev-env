#!/usr/bin/env bash

if [ ! -f /var/log/vagrant-provisioning ];
then

    touch /var/log/vagrant-provisioning

    # Load the configuration file
    source config.sh

    ##########################################
    # Preparations
    apt-get update
    apt-get -y install debconf-utils python-software-properties git git-core curl make

    # Install PHP 5.4
    add-apt-repository -y ppa:ondrej/php5-oldstable
    apt-get update
    apt-get -y install php5 php5-dev php-pear
    pecl install xdebug

    # TODO: php.ini anpassen und kopieren (z. b. xdebug konfigurieren, mail-configurieren (mailcatcher))
    # @see http://berk.es/2011/05/29/mailcatcher-for-drupal-and-other-php-applications-the-simple-version/

    # Install Apache2 with PHP support
    apt-get -y install apache2 libapache2-mod-php5

    # Install MySQL server with root password 'password'
    debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password password'
    debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password password'
    apt-get -y install mysql-server-5.5 php5-mysql

    # TODO: für später
    # apt-get install phpmyadmin

     # Install rubygems and mailcatcher
    apt-get install ruby rubygems
    gem install mailcatcher

    # Install NodeJS, NPM and bower
    add-apt-repository -y ppa:chris-lea/node.js
    apt-get update
    # The added repository also installs npm when installilng nodejs!
    apt-get -y install nodejs
    npm install -g bower

    ####################
    ## Set up Apache2
    # IMPORTANT! Only remove /var/www if it is not a symlink!!
    # If it already is a symlink, it most likely points to our /vagrant directory.
    # Hence removing /var/www will also remove everything in our shared folder /vagrant!
    if [ ! -h /var/www ];
    then
        rm -rf /var/www
        ln -fs /vagrant /var/www
    fi

    a2enmod rewrite
    sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default
    service apache2 restart
    ####################

    ###################
    ## Set up MySQL
    # Copy our pre-configured configuration file and restart the MySQL server
    cp -rf /vagrant/vagrant-up/config-presets/mysql/my.cnf /etc/mysql/my.cnf
    service mysql restart

    # Create the default database and grant all privileges on this database to the root user
    mysql -uroot -ppassword <<< 'CREATE DATABASE default_database;'
    mysql -uroot -ppassword <<< 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%";'
    mysql -uroot -ppassword <<< 'FLUSH PRIVILEGES;'

    # Import the default database structure
    if [ -f $database_init_script ];
    then
        mysql -uroot -ppassword default_database < $database_init_script

        if [ -f $database_content_script ];
        then
            mysql -uroot -ppassword default_database < $database_content_script
        fi
    fi
fi

