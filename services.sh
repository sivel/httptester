#!/bin/sh
eval $(python3 /customize.py)
/bin/sh /gen_certs.sh
/usr/bin/gunicorn -D httpbin:app
/usr/sbin/nginx -g "daemon off;"
