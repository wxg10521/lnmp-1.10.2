FROM alpine:3.7


# insall nginx php.
ADD nginx-1.10.2.tar.gz /
RUN  echo "http://mirrors.ustc.edu.cn/alpine/v3.7/community/" >> /etc/apk/repositories && \
     echo "http://mirrors.ustc.edu.cn/alpine/v3.7/main/" >> /etc/apk/repositories 
#RUN  echo "http://dl-4.alpinelinux.org/alpine/v3.7/community/" >> /etc/apk/repositories && \
#     echo "http://dl-4.alpinelinux.org/alpine/v3.7/main/" >> /etc/apk/repositories 
RUN  apk add --update curl gcc g++ make lighttpd php5 php5-cgi php5-mysql php5-mysqli php5-json php5-pdo php5-phar php5-bcmath php5-bz2 php5-calendar php5-ctype php5-curl php5-dom php5-exif php5-ftp php5-gd php5-gettext php5-iconv php5-imap php5-intl php5-json php5-ldap php5-mcrypt php5-openssl php5-pdo_mysql php5-pdo_pgsql php5-pdo_sqlite php5-pgsql php5-posix php5-soap php5-sockets php5-sqlite3 php5-wddx php5-xml php5-xmlreader php5-xsl php5-zip php5-zlib spawn-fcgi \
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
