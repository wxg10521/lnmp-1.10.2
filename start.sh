#!/bin/sh

echo "Start spawn-fcgi"
spawn-fcgi -a 127.0.0.1 -p 9000 -C 5 -f /usr/bin/php-cgi 

echo "Start nginx"
#nginx -g "daemon off;" 
nginx && tail -f /var/log/nginx/*