FROM debian:10.1 
ENV DEBIAN_FRONTEND noninteractive 

MAINTAINER Issam Martos <issam.martos@protonmail.com> 

RUN apt update &&\
    apt install -y wget apache2 libapache2-mod-php7.3 mariadb-server php7.3 php7.3-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip &&\ 
    rm -rf /var/lib/apt /var/cache/apt /usr/share/man /usr/share/info /usr/share/doc &&\ 
    cd /tmp &&\ 
    wget -q --no-check-certificate http://wordpress.org/wordpress-5.2.3.tar.gz &&\ 
    tar -xzf wordpress-5.2.3.tar.gz &&\ 
    mv wordpress/ /var/www/html &&\ 
    chown -R www-data:www-data /var/www/html/wordpress &&\ 
    chmod 755 -R /var/www/html/wordpress &&\ 
    echo "<VirtualHost *:80> \ 
      ServerAdmin admin@admin \ 
      DocumentRoot /var/www/html/wordpress \ 
      ServerName wordpress-devops \ 
      \ 
      <Directory /var/www/html/wordpress> \ 
        Options FollowSymlinks \ 
        AllowOverride All \ 
        Require all granted \ 
      </Directory> \ 
      \ 
      ErrorLog /var/log/apache2/wordpress-devops_error.log \ 
      CustomLog /var/log/apache2/wordpress-devops_acces.log combined \ 
    </VirtualHost>" > /etc/apache2/sites-available/wordpress.conf &&\ 
    ln -s /etc/apache2-sites-available/wordpress.conf /etc/apache2/sites-enabled/wordpress-conf &&\ 
    ln -sf /dev/stdout /var/log/apache2/wordpress-devops_acces.log &&\ 
    ln -sf /dev/stderr /var/log/apache2/wordpress-devops_error.log &&\ 
    a2enmod rewrite &&\ 
    apache2ctl restart &&\ 
    rm -fr /tmp/*

EXPOSE 80
ENTRYPOINT ["apache2ctl","-D","FOREGROUND"] 
