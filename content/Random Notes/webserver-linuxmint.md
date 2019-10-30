# Install a Webserver on Linux Mint
To install a Lighttpd Webserver with PHP, MySQL(MariaDB) and PHPMyAdmin,
use one of the following instructions as root.

## Install all at once

    apt-get install lighttpd php5-cgi php5-mysql php5-mcrypt mariadb-server phpmyadmin
    lighty-enable-mod fastcgi 
    lighty-enable-mod fastcgi-php
    php5enmod mcrypt 
    service lighttpd force-reload
    ln -s /usr/share/phpmyadmin/ /var/www

## Install step by step
lighttpd webserver:

    apt-get install lighttpd

lighttpd php & mysql bindings:

    apt-get install php5-cgi php5-mcrypt php5-mysql

enable php:

    lighty-enable-mod fastcgi 
    lighty-enable-mod fastcgi-php
    php5enmod mcrypt 

start/restart lighttpd:

    service lighttpd force-reload

mariadb/mysql server + frontend:

    apt-get install mariadb-server
    apt-get install phpmyadmin

move phpmyadmin to htdocs:

    ln -s /usr/share/phpmyadmin/ /var/www
