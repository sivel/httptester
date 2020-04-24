#!/usr/bin/python3
import json
import os
import sys
from string import Template

DEFAULT_SERVER_NAME = 'default.test'

values = {
    'default_server_name': os.getenv(
        'DEFAULT_SERVER_NAME',
        DEFAULT_SERVER_NAME
    ),
    'sni1_server_name': os.getenv(
        'SNI1_SERVER_NAME',
        'sni1.{}'.format(DEFAULT_SERVER_NAME)
    ),
    'sni2_server_name': os.getenv(
        'SNI2_SERVER_NAME',
        'sni2.{}'.format(DEFAULT_SERVER_NAME)
    ),
    'fail_server_name': os.getenv(
        'FAIL_SERVER_NAME',
        'fail.{}'.format(DEFAULT_SERVER_NAME)
    ),
}

with open('nginx.sites.conf.tmpl') as f:
    template_string = f.read()

t = Template(template_string)
rendered = t.substitute(values)

print('Writing /etc/nginx/conf.d/default.conf', file=sys.stderr)
with open('/etc/nginx/conf.d/default.conf', 'w+') as f:
    f.write(rendered)

print('export {}'.format(' '.join(
    map('='.join, ((k.upper(), v) for k, v in values.items()))
)))
