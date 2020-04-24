# We are pinning at 1.13.8 due to the 1.13.9 image having a vastly different
# /etc/ssl/openssl.cnf that does not work with our below commands
FROM nginx:1.13.8-alpine

ADD constraints.txt /root/constraints.txt

ENV PYTHONDONTWRITEBYTECODE=1

# The following packages are required to get httpbin/brotlipy/cffi installed
#     openssl-dev python2-dev libffi-dev gcc libstdc++ make musl-dev
# Symlinking /usr/lib/libstdc++.so.6 to /usr/lib/libstdc++.so is specifically required for brotlipy
RUN set -x && \
    apk add --no-cache openssl ca-certificates python3 py3-pip openssl-dev python3-dev libffi-dev gcc libstdc++ make musl-dev && \
    python3 -V && \
    python3 -c 'import site; print(site.getsitepackages()[0])' && \
    update-ca-certificates && \
    ln -s /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so && \
    mkdir -p /root/ca/certs /root/ca/private /root/ca/newcerts && \
    echo 1000 > /root/ca/serial && \
    touch /root/ca/index.txt && \
    sed -i 's/\.\/demoCA/\/root\/ca/g' /etc/ssl/openssl.cnf && \
    pip3 install --no-compile -c /root/constraints.txt gunicorn httpbin && \
    apk del ca-certificates py3-pip openssl-dev python3-dev libffi-dev gcc libstdc++ make musl-dev && \
    rm -rf /root/.cache/pip && \
    find /usr/lib/python3.5 -type f -regex ".*\.py[co]" -delete && \
    find /usr/lib/python3.5 -type d -name "__pycache__" -delete

ADD nginx.sites.conf.tmpl /nginx.sites.conf.tmpl
ADD customize.py /customize.py
ADD gen_certs.sh /gen_certs.sh
ADD services.sh /services.sh

EXPOSE 80 443

CMD ["/services.sh"]
