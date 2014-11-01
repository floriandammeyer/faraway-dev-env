#!/bin/bash

if [ ! -f /var/log/vagrant-provisioning ];
then

    touch /var/log/vagrant-provisioning

    ##########################################
    # Preparations
    apt-get update
    apt-get -y install debconf-utils python-software-properties git git-core curl make g++

    # Install PHP 5.4 and its extensions
    add-apt-repository -y ppa:ondrej/php5-oldstable
    apt-get update
    apt-get -y install php5 php5-dev php-pear php5-curl php5-imap php5-mysqlnd php5-sqlite php5-pgsql
    # Install Xdebug
    pecl install xdebug

    # Install a more recent version of ruby and mailcatcher
    # @see http://venturecraft.com.au/development/installing-mailcatcher-with-homestead-vagrant/
    apt-get -y install ruby1.9.1-dev libsqlite3-dev
    gem install mailcatcher

    # Install Apache2 with PHP support
    apt-get -y install apache2 libapache2-mod-php5

    # Install MySQL server with root password 'password'
    debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password password'
    debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password password'
    apt-get -y install mysql-server-5.5 php5-mysql

    # Install and configure phpMyAdmin
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password password'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password password'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password password'
    debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
    apt-get -y install phpmyadmin

    # Installing PHP-PCNTL is not straight forward because we need to build it first
    cwd=$(pwd)
    apt-get -y install dpkg-dev
    mkdir /var/tmp/php5-pcntl
    cd /var/tmp/php5-pcntl
    apt-get source php5
    cd $(find -maxdepth 1 -name "php5*" -type d)
    cd ext/pcntl
    phpize
    ./configure
    make
    make install
    echo "extension=pcntl.so" > /etc/php5/mods-available/pcntl.ini
    chmod a=r /etc/php5/mods-available/pcntl.ini
    chmod u+w /etc/php5/mods-available/pcntl.ini
    ln -s /etc/php5/mods-available/pcntl.ini /etc/php5/conf.d/10-pcntl.ini
    rm -rf /var/tmp/php5-pcntl
    cd cwd

    # enable and configure Xdebug
    cp -rf /vagrant/vagrant-up/config-presets/php5/mods-available/xdebug.ini /etc/php5/mods-available/xdebug.ini
    chmod a=r /etc/php5/mods-available/xdebug.ini
    chmod u+w /etc/php5/mods-available/xdebug.ini
    ln -s /etc/php5/mods-available/xdebug.ini /etc/php5/conf.d/10-xdebug.ini
    # copy php.ini for apache2
    cp -rf /vagrant/vagrant-up/config-presets/php5/apache2/php.ini /etc/php5/apache2/php.ini
    # Configure phpMyAdmin
    cp -rf /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
    cp -rf /vagrant/vagrant-up/config-presets/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php
    # Now load the new apache configuration
    service apache2 restart

    # Install NodeJS, NPM and bower
    add-apt-repository -y ppa:chris-lea/node.js
    apt-get update
    # The added repository also installs npm when installing nodejs!
    apt-get -y install nodejs
    npm install -g bower

    # Register mailcatcher as a service and start it
    # Next time the system boots the service will be started automatically
    cp -rf /vagrant/vagrant-up/config-presets/upstart/mailcatcher.conf /etc/init/mailcatcher.conf
    service mailcatcher start

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

    # Import the default database structure
    /vagrant/vagrant-up/database-setup.sh
fi

