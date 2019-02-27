FROM alpine:3.7


# insall nginx php.
ADD nginx-1.10.2.tar.gz /
RUN  echo "http://dl-4.alpinelinux.org/alpine/v3.7/community/" >> /etc/apk/repositories && \
     echo "http://dl-4.alpinelinux.org/alpine/v3.7/testing/" >> /etc/apk/repositories 
RUN  apk add --update curl gcc make lighttpd php php-cgi php-mysql php-mysqli php-json php-pdo php-phar php-bcmath php-bz2 php-calendar php-ctype php-curl php-dom php-exif php-ftp php-gd php-gettext php-iconv php-imap php-intl php-json php-ldap php-mcrypt php-openssl php-pdo_mysql php-pdo_pgsql php-pdo_sqlite php-pgsql php-posix php-soap php-sockets php-sqlite3 php-wddx php-xml php-xmlreader php-xsl php-zip php-zlib spawn-fcgi \
     && rm -rf /var/cache/apk/*
RUN  cd /nginx-1.10.2 \
     && ./configure --prefix=/var/lib/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx/nginx.pid --lock-path=/run/nginx/nginx.lock --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --user=nginx --group=nginx --with-ipv6 --with-file-aio --with-pcre-jit --with-http_dav_module --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_v2_module --with-http_auth_request_module --with-mail --with-mail_ssl_module --with-http_realip_module \
     && make \
     && make install
RUN  mkdir /logs \
     && mkdir -p /var/www/html \
     && mkdir -p /usr/src \
     && mkdir -p /data
COPY  nginx/nginx.conf  /etc/nginx/nginx.conf
COPY  nginx/default.conf  /etc/nginx/conf.d/default.conf

COPY  start.sh  /start.sh

ENV DISCUZ_TEMPLATE=default

WORKDIR /var/www/html
EXPOSE 80 9000
CMD  ["sh","/start.sh"]
