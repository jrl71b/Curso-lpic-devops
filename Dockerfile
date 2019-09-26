FROM debian:9
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl apache2 php php-mysql && \
    cd /var/www/html && \
    rm -f index.html && \
    curl https://wordpress.org/latest.tar.gz --output latest.tar.gz && \
    tar xzf latest.tar.gz --strip-components=1 && \
    chown -R www-data:www-data . && \
    rm -f latest.tar.gz && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/sterr /var/log/apache2/error.log && \
    apt remove -y curl && \
    rm -rf /var/lib/apt /var/lib/dpkg /var/cache/apt /usr/share/doc /usr/share/man /usr/share/info
EXPOSE 80 
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
